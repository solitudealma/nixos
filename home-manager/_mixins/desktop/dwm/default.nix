{pkgs, ...}: {
  imports = [
    ./dunst
    ./picom
  ];
  home = {
    file = {
      ".xinitrc".text = ''
        #!/bin/sh
        [[ -f ~/.Xresources ]] && xrdb -merge -I"$HOME" ~/.Xresources
        exec dwm
      '';
    };
    packages = with pkgs; [
      acpi
      brightnessctl
      dex
      feh
      flameshot
      i3lock-color
      libnotify
      lm_sensors
      redshift
      slstatus
      xclip
      xfce.xfce4-power-manager
      xorg.xdpyinfo
      xorg.xeyes
      xorg.xf86inputsynaptics
      xorg.xinit
      xorg.xrandr
      xorg.xrdb
      xss-lock
    ];
  };
}
