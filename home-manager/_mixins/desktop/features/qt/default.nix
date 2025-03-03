{
  lib,
  pkgs,
  ...
}: let
  inherit (pkgs.stdenv) isLinux;
in
  lib.mkIf isLinux {
    # https://discourse.nixos.org/t/struggling-to-configure-gtk-qt-theme-on-laptop/42268/
    # https://discourse.nixos.org/t/guide-to-installing-qt-theme/35523/2
    home = {
      packages = with pkgs; [
        everforest-gtk-kvantum
        libsForQt5.qtstyleplugin-kvantum
        libsForQt5.qt5ct
      ];
    };

    qt = {
      enable = true;
      platformTheme.name = "gtk";
      style = {
        name = "kvantum";
      };
    };

    systemd.user.sessionVariables = {
      QT_STYLE_OVERRIDE = "kvantum";
    };

    xdg.configFile = {
      "kvantum/kvantum.kvconfig" = {
        text = lib.generators.toINI {} {General.theme = "Everforest";};
      };
      "kvantum/Everforest/Everforest.kvconfig" = {
        text = ''${
            pkgs.fetchurl {
              url = "https://raw.githubusercontent.com/SirEthanator/Hyprland-Dots/refs/heads/main/.config/Kvantum/Everforest/Everforest.kvconfig";
              hash = "sha256-0PBvlXopJEBRCqAQcYTThmfA76d26NUFK5JfCZjXokA=";
            }
          }'';
      };
      qt5ct = {
        target = "qt5ct/qt5ct.conf";
        text = lib.generators.toINI {} {
          Appearance = {
            icon_theme = "Papirus-Light";
          };
        };
      };
      qt6ct = {
        target = "qt6ct/qt6ct.conf";
        text = lib.generators.toINI {} {
          Appearance = {
            icon_theme = "Papirus-Light";
          };
        };
      };
    };
  }
