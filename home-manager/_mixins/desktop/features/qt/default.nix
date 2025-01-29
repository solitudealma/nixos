{
  lib,
  pkgs,
  ...
}: let
  inherit (pkgs.stdenv) isLinux;
in
  lib.mkIf isLinux {
    # https://discourse.nixos.org/t/struggling-to-configure-gtk-qt-theme-on-laptop/42268/
    home = {
      packages = with pkgs; [
        libsForQt5.qtstyleplugin-kvantum
        libsForQt5.qt5ct
      ];
    };

    qt = {
      enable = true;
      platformTheme.name = "gtk";
      style = {
        name = "adwaita-dark";
      };
    };

    systemd.user.sessionVariables = {
      QT_STYLE_OVERRIDE = "adwaita-dark";
    };

    xdg.configFile = {
      qt5ct = {
        target = "qt5ct/qt5ct.conf";
        text = lib.generators.toINI {} {
          Appearance = {
            icon_theme = "Papirus-Dark";
          };
        };
      };
      qt6ct = {
        target = "qt6ct/qt6ct.conf";
        text = lib.generators.toINI {} {
          Appearance = {
            icon_theme = "Papirus-Dark";
          };
        };
      };
    };
  }
