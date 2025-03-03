{
  config,
  desktop,
  lib,
  pkgs,
  ...
}: let
  rime-solitudealma-custom = pkgs.callPackage ./rime-solitudealma-custom.nix {};

  fcitx5-rime-with-addons =
    (pkgs.fcitx5-rime.override {
      librime = pkgs.nur-xddxdd.lantianCustomized.librime-with-plugins;
      rimeDataPkgs = with pkgs; [
        oh-my-rime
        nur-xddxdd.rime-custom-pinyin-dictionary
        rime-data
        nur-xddxdd.rime-dict
        rime-frost
        nur-xddxdd.rime-moegirl
        rime-solitudealma-custom
        nur-xddxdd.rime-zhwiki
      ];
    })
    .overrideAttrs
    (old: {
      # Prebuild schema data
      nativeBuildInputs = (old.nativeBuildInputs or []) ++ [pkgs.parallel];
      postInstall =
        (old.postInstall or "")
        + ''
          for F in $out/share/rime-data/*.schema.yaml; do
            echo "rime_deployer --compile "$F" $out/share/rime-data $out/share/rime-data $out/share/rime-data/build" >> parallel.lst
          done
          parallel -j$(nproc) < parallel.lst || true
        '';
    });
in {
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5 = {
      addons = with pkgs; [
        fcitx5-configtool
        fcitx5-fluent
        fcitx5-lua
        fcitx5-gtk # gtk im module
        libsForQt5.fcitx5-qt
        fcitx5-rime-with-addons
      ];
      waylandFrontend = lib.elem desktop ["niri" "dwl" "cosmic"];
      settings = {
        addons = {
          classicui.globalSection.Theme = "Gruvbox-Dark";
          notifications = {
            globalSection = {
            };
            sections = {
              HiddenNotifications = {
                "0" = "wayland-diagnose-other";
              };
            };
          };
        };
        inputMethod = {
          "Groups/0" = {
            # Group Name
            Name = "Default";
            # Layout
            "Default Layout" = "us";
            # Default Input Method
            DefaultIM = "rime";
          };
          "Groups/0/Items/0" = {
            # Name
            Name = "keyboard-us";
            # Layout
            Layout = "";
          };
          "Groups/0/Items/1" = {
            # Name
            Name = "rime";
            # Layout
            Layout = "";
          };
          GroupOrder = {
            "0" = "Default";
          };
        };
        globalOptions = {
          Hotkey = {
            # 反复按切换键时进行轮换
            EnumerateWithTriggerKeys = "True";
            # 向前切换输入法
            # EnumerateForwardKeys=
            # 向后切换输入法
            # EnumerateBackwardKeys=
            # 轮换输入法时跳过第一个输入法
            EnumerateSkipFirst = "False";
          };
          "Hotkey/TriggerKeys" = {
            "0" = "Control+space";
            "1" = "Zenkaku_Hankaku";
            "2" = "Hangul";
          };
          "Hotkey/AltTriggerKeys" = {
            "0" = "Shift_L";
          };
          "Hotkey/EnumerateGroupForwardKeys" = {
            "0" = "Super+space";
          };
          "Hotkey/EnumerateGroupBackwardKeys" = {
            "0" = "Shift+Super+space";
          };
          "Hotkey/ActivateKeys" = {
            "0" = "Hangul_Hanja";
          };
          "Hotkey/DeactivateKeys" = {
            "0" = "Hangul_Romaja";
          };
          "Hotkey/PrevPage" = {
            "0" = "Up";
          };
          "Hotkey/NextPage" = {
            "0" = "Down";
          };
          "Hotkey/PrevCandidate" = {
            "0" = "Shift+Tab";
          };
          "Hotkey/NextCandidate" = {
            "0" = "Tab";
          };
          "Hotkey/TogglePreedit" = {
            "0" = "Control+Alt+P";
          };
          Behavior = {
            # 默认状态为激活
            ActiveByDefault = "False";
            # 重新聚焦时重置状态
            resetStateWhenFocusIn = "No";
            # 共享输入状态
            ShareInputState = "No";
            # 在程序中显示预编辑文本
            PreeditEnabledByDefault = "True";
            # 切换输入法时显示输入法信息
            ShowInputMethodInformation = "True";
            # 在焦点更改时显示输入法信息
            showInputMethodInformationWhenFocusIn = "False";
            # 显示紧凑的输入法信息
            CompactInputMethodInformation = "True";
            # 显示第一个输入法的信息
            ShowFirstInputMethodInformation = "True";
            # 默认页大小
            DefaultPageSize = 5;
            # 覆盖 Xkb 选项
            OverrideXkbOption = "False";
            # 自定义 Xkb 选项
            # CustomXkbOption=
            # Force Enabled Addons
            # EnabledAddons=
            # Force Disabled Addons
            # DisabledAddons=
            # Preload input method to be used by default
            PreloadInputMethod = "True";
            # 允许在密码框中使用输入法
            AllowInputMethodForPassword = "False";
            # 输入密码时显示预编辑文本
            ShowPreeditForPassword = "False";
            # 保存用户数据的时间间隔（以分钟为单位）
            AutoSavePeriod = 30;
          };
        };
      };
    };
  };
}
