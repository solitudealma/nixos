{
  lib,
  pkgs,
  ...
}: {
  programs.river = {
    enable = true;
    extraPackages = with pkgs; [
      xwayland
      swaylock-effects # lockscreen
      pavucontrol
      swayidle

      brightnessctl
      playerctl
      polkit_gnome
      foot

      waybar

      blueman
      lswt
      wlr-randr

      wlprop
      wf-recorder
      rofi-wayland
      rofi-rbw
      eog
      libnotify
      dunst # notification daemon
      kanshi # auto-configure display outputs
      wdisplays
      cliphist
      wezterm
      grim
      slurp
      swappy
      satty
      swww
      blueberry
      sway-contrib.grimshot # screenshots
      wtype

      pavucontrol
      evince
      libnotify
      pamixer
      networkmanagerapplet
      file-roller
      nautilus
    ];
  };
  systemd.user.services.river = {
    description = "River - Wayland window manager";
    documentation = ["man:river(5)"];
    bindsTo = ["graphical-session.target"];
    wants = ["graphical-session-pre.target"];
    after = ["graphical-session-pre.target"];
    # We explicitly unset PATH here, as we want it to be set by
    # systemctl --user import-environment in startriver
    environment.PATH = lib.mkForce null;
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.river}/bin/river";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };
  # thunar
  services.gvfs.enable = true; # Mount, trash, and other functionalities
  services.tumbler.enable = true; # Thumbnail support for images
}
