{
  config,
  desktop,
  lib,
  pkgs,
  ...
}: let
  inherit (config._custom.globals) fonts;
  inherit (pkgs.stdenv) isLinux;
  buttonLayout =
    if config.wayland.windowManager.hyprland.enable
    then "appmenu"
    else "close,minimize,maximize";
in
  lib.mkIf isLinux {
    # TODO: Migrate to Colloid-gtk-theme 2024-06-18 or newer; now has catppuccin colors
    # - https://github.com/vinceliuice/Colloid-gtk-theme/releases/tag/2024-06-18
    dconf.settings = with lib.hm.gvariant; {
      "org/gnome/desktop/interface" = {
        # color-scheme = "prefer-dark";
        cursor-size = 20;
        cursor-theme = "Bibata-Modern-Ice";
        gtk-theme = "Everforest-Dark";
        icon-theme = "Papirus-Light";
      };

      "org/gnome/desktop/wm/preferences" = {
        button-layout = lib.mkIf (desktop != "hyprland") "${buttonLayout}";
        theme = "Everforest-Dark";
      };

      "org/pantheon/desktop/gala/appearance" = {
        button-layout = "${buttonLayout}";
      };
    };
    gtk = {
      cursorTheme = {
        name = "Bibata-Modern-Ice";
        package = pkgs.bibata-cursors;
        size = 20;
      };
      enable = true;
      font = {
        name = fonts.mono;
        package = fonts.package;
      };
      gtk2 = {
        configLocation = "${config.xdg.configHome}/.gtkrc-2.0";
        extraConfig = ''
          gtk-application-prefer-dark-theme = 1
          gtk-button-images = 1
        '';
      };
      gtk3 = {
        extraConfig = {
          gtk-application-prefer-dark-theme = 1;
          gtk-button-images = 1;
        };
      };
      gtk4 = {
        extraConfig = {
        };
      };
      iconTheme = {
        # name = "Tela-circle-dark";
        # package = pkgs.tela-circle-icon-theme;
        name = "Papirus-Light";
        package = pkgs.papirus-icon-theme.override {
          color = "green";
        };
      };
      theme = {
        name = "Everforest-Dark";
        package = pkgs.everforest-gtk-theme;
      };
    };
    home = {
      packages = with pkgs; [papirus-folders];
      pointerCursor = {
        name = "Bibata-Modern-Ice";
        package = pkgs.bibata-cursors;
        x11.enable = true;
        x11.defaultCursor = "Bibata-Modern-Ice";
        size = 20;
        gtk.enable = true;
      };
    };
  }
