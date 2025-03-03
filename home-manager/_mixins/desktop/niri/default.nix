{
  inputs,
  lib,
  pkgs,
  ...
}: {
  imports = [
    inputs.niri.homeModules.niri
    ./hyprlock
    ./swaync
    ./swww
    ./waybar
    ./wlogout
  ];

  home = {
    packages = with pkgs; [
      brightnessctl
      labwc
      lswt
      wlrctl
      wl-clipboard
      xorg.xprop
      xwayland-satellite
    ];
  };

  programs = {
    niri = {
      enable = true;
      package = pkgs.niri-unstable;
      config = builtins.readFile (
        pkgs.substituteAll {
          src = ./niri.kdl;
          authAgent = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
          niri = "${lib.getExe pkgs.niri-unstable}";
          startXwayland = pkgs.writeText "a.sh" ''
            sleep 3
            xwayland-satellite :0
          '';
        }
      );
    };
  };
}
