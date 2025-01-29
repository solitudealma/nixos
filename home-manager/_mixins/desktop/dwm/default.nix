{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    ./dmenu
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
      dex
      dunst
      feh
      flameshot
      i3lock-color
      libnotify
      lm_sensors
      luastatus
      inputs.picom.packages.${pkgs.system}.picom
      rofi
      slstatus
      upower
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
