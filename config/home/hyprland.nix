{
  pkgs,
  lib,
  inputs,
  ...
}:
with lib; {
  home.packages = with pkgs; [
    networkmanagerapplet
    hyprpicker
    swww
    wlogout

    # 剪贴板功能
    wl-clipboard
    cliphist
    wl-clip-persist

    # 截图功能
    grim
    slurp
    swappy
    satty
    clash-verge-rev
    qq
    yazi
    telegram-desktop
    discord
    element-desktop
    pot
    waybar

    # audio
    alsa-utils # provides amixer/alsamixer/...
    # mpd # for playing system sounds
    mpc-cli # command-line mpd client
    cava
    mpdris2
    playerctl
    localsend
    brightnessctl
    light
    avizo

    rofi-wayland
    imv
    swayidle
    swaylock-effects
    swaynotificationcenter
    wpsoffice-cn
    waydroid
    ffmpeg
    gojq
    kooha
    wf-recorder

    steam
    steamcmd

    nwg-look
    qt5ct

    xorg.xrdb
    xorg.xprop
    wlprop
  ];

  xdg.configFile."hypr" = {
    source = ./files/hypr;
    recursive = true; # 递归整个文件夹
    executable = true; # 将其中所有文件添加「执行」权限
  };

  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    systemd = {
      enable = true;
    };
    plugins = [
      # inputs.hycov.packages.${pkgs.system}.hycov
      # inputs.hych.packages.${pkgs.system}.hych
    ];
    extraConfig = ''
      source = ~/.config/hypr/config/env.conf
      source = ~/.config/hypr/config/bootup.conf
      source = ~/.config/hypr/config/monitor.conf
      source = ~/.config/hypr/config/binds.conf
      source = ~/.config/hypr/config/animation.conf
      # source = ~/.config/hypr/config/plugin.conf
      source = ~/.config/hypr/config/winrule.conf
      source = ~/.config/hypr/config/device.conf
    '';
  };
}
