{
  config,
  desktop,
  isInstall,
  lib,
  pkgs,
  username,
  ...
}: let
  installFor = ["solitudealma"];
in
  lib.mkIf (lib.elem username installFor || desktop == "dwm" || desktop == "gnome" || desktop == "hyprland" || desktop == "river") {
    xdg.portal.enable = true;

    # allow flatpak to use fonts and icons of system
    system.fsPackages = [pkgs.bindfs];
    fileSystems = let
      mkRoSymBind = path: {
        device = path;
        fsType = "fuse.bindfs";
        options = [
          "ro"
          "resolve-symlinks"
          "x-gvfs-hide"
        ];
      };
      aggregatedIcons = pkgs.buildEnv {
        name = "system-icons";
        paths = with pkgs; [
          #libsForQt5.breeze-qt5  # for Plasma
          gnome-themes-extra # for Gnome
        ];
        pathsToLink = ["/share/icons"];
      };
      aggregatedFonts = pkgs.buildEnv {
        name = "system-fonts";
        paths = config.fonts.packages;
        pathsToLink = ["/share/fonts"];
      };
    in {
      "/usr/share/icons" = mkRoSymBind "${aggregatedIcons}/share/icons";
      "/usr/local/share/fonts" = mkRoSymBind "${aggregatedFonts}/share/fonts";
    };

    services = {
      flatpak = lib.mkIf isInstall {
        enable = true;
        packages = [
          # { flatpakref = "<uri>"; sha256="<hash>"; }
          # { appId = "com.brave.Browser"; origin = "flathub";  }
          # "com.tencent.WeChat"
        ];
        # By default nix-flatpak will add the flathub remote;
        # Therefore Appcenter is only added when the desktop is Pantheon
        remotes = lib.mkIf (desktop == "gnome" || desktop == "hyprland") [
          {
            name = "flathub";
            location = "https://mirror.sjtu.edu.cn/flathub";
          }
          {
            name = "appcenter";
            location = "https://flatpak.elementary.io/repo.flatpakrepo";
          }
        ];
        update.auto = {
          enable = true;
          onCalendar = "weekly";
        };
      };
    };
  }
