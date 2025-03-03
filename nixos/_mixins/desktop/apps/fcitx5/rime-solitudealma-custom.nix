{
  lib,
  linkFarm,
  writeText,
  ...
}:
let
  makeDict =
    name: dicts:
    let
      body = builtins.toJSON {
        inherit name;
        version = "1.0";
        sort = "by_weight";
        use_preset_vocabulary = false;
        import_tables = dicts;
      };
    in
    ''
      # Rime dictionary
      # encoding: utf-8

      ---
      ${body}

      ...
    '';
in
linkFarm "rime-solitudealma-custom" (
  lib.mapAttrs writeText {
    "share/rime-data/default.custom.yaml" = builtins.toJSON {
      patch = {
        ascii_composer = {
          # 定义切换到西文模式的快捷键
          switch_key = {
            Caps_Lock = "commit_code";  # 按下 Caps Lock 会直接上屏
            Control_L = "noop";  # 按下左 Control 键不做任何操作
            Control_R = "noop";  # 按下右 Control 键不做任何操作
            Shift_L = "commit_code";  # 按下左 Shift 键会直接上屏
            Shift_R = "inline_ascii";  # 按下右 Shift 键会临时切换到西文模式
          };
          good_old_caps_lock = true;  # 启用经典的 Caps Lock 开启西文模式的方式
        };
        key_binder = {
          bindings = [
            { accept = "Control+Shift+E"; toggle = "emoji_suggestion"; when = "always"; }
            { accept = "Control+Shift+1"; toggle = "simplification"; when = "has_menu"; }
            { accept = "bracketleft"; send = "Page_Up"; when = "paging"; }      # 使用`[`进行向上翻页（第一页时候无效）
            { accept = "bracketright"; send = "Page_Down"; when = "has_menu"; } # 使用`]`进行向下翻页
            { accept = "minus"; send = "Page_Up"; when = "paging"; }     # 使用`-`进行向上翻页（第一页时候无效）
            { accept = "equal"; send = "Page_Down"; when = "has_menu"; } # 使用`=`进行向下翻页
          ];
        };
        "menu/page_size" = 6;
        schema_list = [
          { schema = "rime_mint"; }
          { schema = "double_pinyin_flypy"; }
        ];
      };
    };

    # 薄荷拼音
    "share/rime-data/rime_mint.custom.yaml" = builtins.toJSON {
      patch = {
        # Emoji模块
        emoji_suggestion = {
          opencc_config = "emoji.json";
          option_name = "emoji_suggestion";
          tips = "all";
          inherit_comment = false;
        };
        "speller/algebra" = [
          "erase/^xx$/" # 首选保留
          ## 模糊拼音
          "derive/^([zcs])h/$1/" # zh, ch, sh => z, c, s
          "derive/^([zcs])([^h])/$1h$2/" # z, c, s => zh, ch, sh
          "derive/([aei])n$/$1ng/" # en => eng, in => ing
          "derive/([aei])ng$/$1n/" # eng => en, ing => in
          "derive/([iu])an$/$lan/" # ian => iang, uan => uang
          "derive/([iu])ang$/$lan/" # iang => ian, uang => uan
          "derive/([aeiou])ng$/$1gn/"        # dagn => dang
          "derive/([dtngkhrzcs])o(u|ng)$/$1o/"  # zho => zhong|zhou
          "derive/ong$/on/"                  # zhonguo => zhong guo
          "abbrev/^([a-z])[a-z]*$/$1/"       # 简拼（首字母）
          "abbrev/^([zcs]h).+$/$1/"          # 简拼（zh, ch, sh）
          ### 自动纠错
          # 有些规则对全拼简拼混输有副作用：如「x'ai 喜爱」被纠错为「xia 下」
          # zh、ch、sh
          "derive/([zcs])h(a|e|i|u|ai|ei|an|en|ou|uo|ua|un|ui|uan|uai|uang|ang|eng|ong)$/h$1$2/"  # hzi → zhi
          "derive/([zcs])h([aeiu])$/$1$2h/"  # zih → zhi
          # ai
          "derive/^([wghk])ai$/$1ia/"  # wia → wai
          # ia
          "derive/([qjx])ia$/$1ai/"  # qai → qia
          # ei
          "derive/([wtfghkz])ei$/$1ie/"
          # ie
          "derive/([jqx])ie$/$1ei/"
          # ao
          "derive/([rtypsdghklzcbnm])ao$/$1oa/"
          # ou
          "derive/([ypfm])ou$/$1uo/"
          # uo（无）
          # an
          "derive/([wrtypsdfghklzcbnm])an$/$1na/"
          # en
          "derive/([wrpsdfghklzcbnm])en$/$1ne/"
          # ang
          "derive/([wrtypsdfghklzcbnm])ang$/$1nag/"
          "derive/([wrtypsdfghklzcbnm])ang$/$1agn/"
          # eng
          "derive/([wrtpsdfghklzcbnm])eng$/$1neg/"
          "derive/([wrtpsdfghklzcbnm])eng$/$1egn/"
          # ing
          "derive/([qtypdjlxbnm])ing$/$1nig/"
          "derive/([qtypdjlxbnm])ing$/$1ign/"
          # ong
          "derive/([rtysdghklzcn])ong$/$1nog/"
          "derive/([rtysdghklzcn])ong$/$1ogn/"
          # iao
          "derive/([qtpdjlxbnm])iao$/$1ioa/"
          "derive/([qtpdjlxbnm])iao$/$1oia/"
          # ui
          "derive/([rtsghkzc])ui$/$1iu/"
          # iu
          "derive/([qjlxnm])iu$/$1ui/"
          # ian
          "derive/([qtpdjlxbnm])ian$/$1ain/"
          # "derive/([qtpdjlxbnm])ian$/$1ina/ # 和「李娜、蒂娜、缉拿」等常用词有冲突
          # in
          "derive/([qypjlxbnm])in$/$1ni/"
          # iang
          "derive/([qjlxn])iang$/$1aing/"
          "derive/([qjlxn])iang$/$1inag/"
          # ua
          "derive/([g|k|h|zh|sh])ua$/$1au/"
          # uai
          "derive/([g|h|k|zh|ch|sh])uai$/$1aui/"
          "derive/([g|h|k|zh|ch|sh])uai$/$1uia/"
          # uan
          "derive/([qrtysdghjklzxcn])uan$/$1aun/"
          # "derive/([qrtysdghjklzxcn])uan$/$1una/" # 和「去哪、露娜」等常用词有冲突
          # un
          "derive/([qrtysdghjklzxc])un$/$1nu/"
          # ue
          "derive/([nlyjqx])ue$/$1eu/"
          # uang
          "derive/([g|h|k|zh|ch|sh])uang$/$1aung/"
          "derive/([g|h|k|zh|ch|sh])uang$/$1uagn/"
          "derive/([g|h|k|zh|ch|sh])uang$/$1unag/"
          "derive/([g|h|k|zh|ch|sh])uang$/$1augn/"
          # iong
          "derive/([jqx])iong$/$1inog/"
          "derive/([jqx])iong$/$1oing/"
          "derive/([jqx])iong$/$1iogn/"
          "derive/([jqx])iong$/$1oign/"
          # 其他
          "derive/([rtsdghkzc])o(u|ng)$/$1o/" # do → dou|dong
          "derive/ong$/on/" # lon → long
          "derive/([tl])eng$/$1en/" # ten → teng
          "derive/([qwrtypsdfghjklzxcbnm])([aeio])ng$/$1ng/" # lng → lang、leng、ling、long
        ];
        "switches/@last" = {
          name = "emoji_suggestion";
          reset = 0;
          states = [ "😣️" "😁️"];
        };
        "translator/dictionary" = "rime_mint";
      };
    };

    "share/rime-data/luna_pinyin.custom.yaml" = builtins.toJSON {
      recognizer = {
        patterns = {
          # Use / as the identifier here
          # You can freely replace your favorite identifiers (such as: `~, .\; etc., characters that need not be displayed directly on the screen)
          # Replace the / before the Greek letter at the same time
          punct = "^/([0-9]0?|[A-Za-z]+)$";
        };
      };
      punctuator = {
        symbols = {
          # Here, the letter name is used as the code of the Greek letter, and you can replace it with your favorite code as needed.
          # For example, if you want to use a as the alpha code
          # just replace the alpha below with a
          "/alpha" = ["Α" "α"];
          "/beta" = ["Β" "β"];
          "/gamma" = ["Γ" "γ"];
          "/delta" = ["Δ" "δ"];
          "/epsilon" = ["Ε" "ε"];
          "/zeta" = ["Ζ" "ζ"];
          "/eta" = ["Η" "η"];
          "/theta" = ["Θ" "θ"];
          "/iota" = ["Ι" "ι"];
          "/kappa" = ["Κ" "κ"];
          "/lambda" = ["Λ" "λ"];
          "/mu" = ["Μ" "μ"];
          "/nu" = ["Ν" "ν"];
          "/xi" = ["Ξ" "ξ"];
          "/omicron" = ["Ο" "ο"];
          "/pi" = ["Π" "π"];
          "/rho" = ["Ρ""ρ"];
          "/sigma" = ["Σ" "σ" "ς"];
          "/tau" = ["Τ" "τ"];
          "/upsilon" = ["Υ" "υ"];
          "/phi" = ["Φ" "φ"];
          "/chi" = ["Χ" "χ"];
          "/psi" = ["Ψ" "ψ"];
          "/omega" = ["Ω" "ω"];
        };
      };
    };

    "share/rime-data/rime_mint.dict.yaml" = makeDict "rime_mint" [
      "dicts/custom_simple"          # 自定义
      "dicts/rime_ice.8105"          # 霧凇拼音 常用字集合
      "dicts/rime_ice.41448"         # 霧凇拼音 完整字集合
      "dicts/rime_ice.base"          # 雾凇拼音 基础词库
      "dicts/rime_ice.ext"           # 雾凇拼音 扩展词库
      "dicts/other_kaomoji"          # 颜文字表情（按`VV`呼出)
      "dicts/rime_ice.others"        # 雾凇拼音 others词库（用于自动纠错）
      
      "cn_dicts/8105"
      "cn_dicts/41448"
      "cn_dicts/base"
      "cn_dicts/ext"
      "cn_dicts/tencent"
      "cn_dicts/others"

      "CustomPinyinDictionary"
      "moegirl"
      "rime-frost"
      "zhwiki"
    ];

    "share/rime-data/mint_mint.custom.yaml" = builtins.toJSON {
      patch = {
        # 对 speller/algebra 进行追加
        "speller/algebra/+" = [
          "derive/v/u/" # u => ü
        ];
      };
    };
  }
)