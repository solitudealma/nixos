{
  config,
  desktop,
  lib,
  pkgs,
  ...
}: {
  xdg = {
    portal = {
      configPackages = with pkgs;
        []
        ++ lib.optionals (desktop == "hyprland") [
          hyprland
        ];
      extraPortals = with pkgs;
        [
          xdg-desktop-portal
        ]
        ++ lib.optionals (desktop == "dwm") [
          xdg-desktop-portal-gtk
        ]
        ++ lib.optionals (desktop == "dwl") [
          xdg-desktop-portal-gtk
          xdg-desktop-portal-gnome
        ]
        ++ lib.optionals (desktop == "hyprland") [
          xdg-desktop-portal
          xdg-desktop-portal-gtk
          xdg-desktop-portal-hyprland #nixos/_mixins/desktop/hyprland/default.nix
        ]
        ++ lib.optionals (desktop == "niri") [
          xdg-desktop-portal-wlr
          xdg-desktop-portal-gtk
          xdg-desktop-portal-gnome
        ]
        ++ lib.optionals (desktop == "river") [
          xdg-desktop-portal-wlr
          xdg-desktop-portal-gtk
        ]
        ++ lib.optionals (desktop == "gnome") [
          xdg-desktop-portal-gnome
        ];
      config = {
        common = {
          default = ["gtk"];
        };
        dwm = lib.mkIf (desktop == "dwm") {
          default = ["gnome" "gtk"];
          "org.freedesktop.impl.portal.Secret" = ["gnome-keyring"];
        };
        dwl = lib.mkIf (desktop == "dwl") {
          default = ["gnome" "gtk"];
          "org.freedesktop.impl.portal.Secret" = ["gnome-keyring"];
        };
        gnome = lib.mkIf (desktop == "gnome") {
          default = ["gnome" "gtk"];
          "org.freedesktop.impl.portal.Secret" = ["gnome-keyring"];
        };
        hyprland = lib.mkIf (desktop == "hyprland") {
          default = ["hyprland" "gtk"];
          "org.freedesktop.impl.portal.Secret" = ["gnome-keyring"];
        };
        niri = lib.mkIf (desktop == "niri") {
          default = ["gnome" "gtk"];
          # "org.freedesktop.impl.portal.Secret" = ["gnome-keyring"];
        };
        river = lib.mkIf (desktop == "river") {
          default = ["gnome" "gtk"];
          "org.freedesktop.impl.portal.Secret" = ["gnome-keyring"];
        };
      };
      enable = true;
      xdgOpenUsePortal = true;
    };
    terminal-exec = {
      enable = true;
      settings = {
        default = ["st.desktop"];
      };
    };
  };
  # Fix xdg-portals opening URLs: https://github.com/NixOS/nixpkgs/issues/189851
  systemd.user.extraConfig = ''
    DefaultEnvironment="PATH=/run/wrappers/bin:/etc/profiles/per-user/%u/bin:/nix/var/nix/profiles/default/bin:/run/current-system/sw/bin"
  '';
}
