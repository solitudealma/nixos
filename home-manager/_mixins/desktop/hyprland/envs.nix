_: {
  laptop = {
    env = [
      # Hyprland env
      # =======================================================================================================================
      "HYPRLAND_LOG_WLR,1" # 启用更详细的 wlroot 日志记录。

      "HYPRLAND_NO_SD_NOTIFY,1" # 如果是systemd 则禁用sd_notify

      # 环境变量
      # =======================================================================================================================
      # # QT [0.34.0 添加至默认配置]
      "QT_QPA_PLATFORM,wayland;xcb"
      "QT_WAYLAND_DISABLE_WINDOWDECORATION, 1"
      "QT_QPA_PLATDORM, wayland, xcb"
      "QT_AUTO_SCREEN_SCALE_FACTOR, 1"
      "QT_QPA_PLATFORMTHEME, qt5ct"

      # Gnome cursor theme needed paths
      "XCURSOR_PATH, \${XCURSOR_PATH}:~/.local/share/icons"

      # GTK
      "GDK_SCALE, 1"
      "GDK_DPI_SCALE, 1"
      "GDK_BACKEND, wayland, x11"
      "SDL_VIDEODRIVER, wayland"
      "CLUTTER_BACKEND, wayland"

      # XDG
      "XDG_CURRENT_DESKTOP, Hyprland"
      "XDG_SESSION_TYPE, wayland"
      "XDG_SESSION_DESKTOP, Hyprland"

      # For Java
      "_JAVA_AWT_WM_NONREPARENTING, 1"

      # For firefox
      "MOZ_ENABLE_WAYLAND, 1"
      # =======================================================================================================================
    ];
  };
}
