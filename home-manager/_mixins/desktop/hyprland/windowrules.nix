_: {
  laptop = {
    windowrule = [
      # Window Rules

      # if you use blur , forcergbx doesn't work
      # windowrule = forcergbx, xwayland:1
      # windowrule = forcergbx, floating:1
      # windowrule = forcergbx, fullscreen:1
      # ===================================================================

      # ===================================================================
      #                            Float 浮动窗口
      # ===================================================================
      "float, ^(|com.github.Aylur.ags|guifetch|nm-connection-editor|pavucontrol|thunar)$" # Other

      # ===================================================================
      #                             窗口初始化大小
      # ===================================================================
      #  如果想要这条配置在hyprland工作，保证kitty config下列配置项注释掉:
      #  enabled_layouts
      #  initial_window_width
      #  initial_window_height
      #  remember_window_size
      "size 1300 800, ^(thunar)$"
      "size 600 400,  ^(nm-connection-editor|pavucontrol-qt)$" # ## open on waybar
      "size 470 470,  ^(guifetch)$"

      # ===================================================================
      #                               窗口移动
      # ===================================================================
      "move cursor -600 35, ^(nm-connection-editor|pavucontrol-qt|pavucontrol)$" # waybar 右键弹出面板
      "center, title:(st_.*|swappy|float_st)" # st
      "center, ^(thunar|guifetch)$" # Other

      # ===================================================================
      #                             Opacitys 不透明
      # ===================================================================
      "opaque,  ^(guifetch|eudic|draw.io|vimiv|swappy|mpv|music-you|pavucontrol-qt|nm-connection-editor)$" # vimiv 图片预览, swappy 截图辅助工具, mpv, music-you

      # ===================================================================
      #                               Noanim  无动画
      # ===================================================================
      # "noanim, ^(imv)$"

      # ===================================================================
      #                               Nofocus 无焦点
      # ===================================================================
      # "nofocus, ^()$"

      # ===================================================================
      #                               miniwindows
      # 适用小窗口进度条一类的浮动
      # ===================================================================
      "float,title:^(Open File)(.*)$"
      "float,title:^(Select a File)(.*)$"
      "float,title:^(Choose wallpaper)(.*)$"
      "float,title:^(Open Folder)(.*)$"
      "float,title:^(Save As)(.*)$"
      "float,title:^(Library)(.*)$"

      # ===================================================================
      #                               Notify
      # ===================================================================

      # ===================================================================
      #                               imv 截图用
      # ===================================================================
      "noanim , ^(flameshot|com.gabm.satty)$"
      "float , ^(flameshot|com.gabm.satty)$"
      "opaque, ^(com.gabm.satty)$"
      "keepaspectratio, ^(com.gabm.satty)$"
    ];
    windowrulev2 = [
      # ===================================================================
      #                            Tile 平铺
      # ===================================================================
      "tile, class:(eudic), title:^(eudic|欧陆词典)$" # fix eudic 窗口奇怪偏移

      # ===================================================================
      #                            Center 居中窗口
      # ===================================================================
      "center, initialTitle:(Polychromatic|Syncthing Tray)"
      "center, class:(QQ),     title:^(图片查看器|视频播放器|(.*聊天记录))$"

      # ===================================================================
      #                            FullScreen 全屏窗口
      # ===================================================================
      "fullscreen, class:(Waydroid)"

      # ===================================================================
      #                            Float 浮动窗口
      # ===================================================================
      "float, title:(Maestral Settings|MainPicker|overskride|Pipewire Volume Control|Trayscale)"
      "float, class:(St),  title:^(st_alsamixer|st_clock|float_st|st_cava)$" # St
      "float, class:(thunar), title:^(File Operation Progress)$" # Thunar 文件进度条
      "float, class:(QQ),     title:^(图片查看器|视频播放器|(.*聊天记录))$" # QQ 图片预览
      "float, class:(org.telegram.desktop), title:^(Media viewer)$"
      "float, class:(pot),    title:(Recognize|Config|Translator|Translate|OCR|PopClip|Screenshot Translate)" # Translation window floating
      "float, class:(firefox), title:^(扩展|Extension)(.*)(划词翻译)(.*)(独立翻译窗口)$" #\s(\(划词翻译\))\s(-)\s(独立翻译窗口).*$"
      # Extension: (划词翻译) - 独立翻译窗口 - 划词翻译 — Mozilla Firefox
      "float, class:(wyeb)" # wyeb
      "float, initialTitle:(Polychromatic|Syncthing Tray)"

      # ===================================================================
      #                             窗口初始化大小
      # ===================================================================
      #  如果想要这条配置在hyprland工作，保证kitty config下列配置项注释掉:
      #  enabled_layouts
      #  initial_window_width
      #  initial_window_height
      #  remember_window_size
      "size 1300 800, class:(QQ),    title:^(图片查看器|视屏播放|(.*聊天记录))$" # QQ 图片预览
      "size 1300 800, class:(thunar), title:^(Open File)(.*)$"
      "size 1300 800, class:(xdg-desktop-portal-gtk), title:^(Save As|Open Files)$"
      "size 1300 800, class:(St), title:^(float_st)$"
      "size 418 234,  class:(St), title:^(st_clock|st_cava)$"
      "size 185 675,  class:(St), title:^(st_alsamixer)$"

      # ===================================================================
      #                               窗口移动
      # ===================================================================

      "move cursor 0 0, class:(pot), title:(Translator|PopClip|Screenshot Translate|Translate)" # Translation window follows the mouse position.

      # ===================================================================
      #                             Opacitys 不透明
      # ===================================================================
      "opaque,  class:(firefoxdeveloperedition), title:(.*)(bilibili|哔哩哔哩|视频|YouTube|video|Video)" # Firefox 视屏网站
      "opaque,  class:(firefox), title:(.*)(bilibili|哔哩哔哩|视频|YouTube|video|Video|Aria2)" # Firefox 视屏网站
      "opaque,  class:(St), title:(st_.*)" # st  指定title的一些应用使用不透明的背景
      "opaque,  class:(QQ),    title:^(图片查看器|视屏播放|(.*聊天记录))$" # QQ 图片预览
      "opaque,  class:(org.telegram.desktop),    title:^(Media viewer|org.telegram.desktop)$" # TG 图片预览
      "opacity 1.0, title: Steam Big Picture Mode"
      "opacity 1.0, class: Gimp"

      # Tag
      "float, tag:float"
    ];
  };
}
