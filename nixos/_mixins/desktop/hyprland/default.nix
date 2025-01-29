{
  config,
  inputs,
  isInstall,
  lib,
  pkgs,
  ...
}: {
  imports = [
    # inputs.hyprland.nixosModules.default
    ./greetd.nix
  ];
  environment = {
    # Enable HEIC image previews in Nautilus
    pathsToLink = ["share/thumbnailers"];
    sessionVariables = {
      # Workaround GTK4 bug:
      # - https://gitlab.gnome.org/GNOME/gtk/-/issues/7022
      # - https://github.com/hyprwm/Hyprland/issues/7854
      GDK_DISABLE = "vulkan";
      # NIXOS_OZONE_WL = 1;
      QT_WAYLAND_DISABLE_WINDOWDECORATION = 1;
    };
    systemPackages = with pkgs;
      lib.optionals isInstall [
        hyprcursor
        hyprshade
        pyprland
        brightnessctl
        lswt
        wlr-randr
        wlprop
        # Enable HEIC image previews in Nautilus
        libheif
        libheif.out
        resources
        gnome-font-viewer
        nautilus # file manager
        zenity
        polkit_gnome
        wdisplays # display configuration
        wlr-randr
        catppuccin-cursors
      ];
  };

  programs = {
    dconf.profiles.user.databases = [
      {
        settings = with lib.gvariant; {
          "org/gnome/desktop/interface" = {
            clock-format = "24h";
            # color-scheme = "prefer-dark";
            cursor-size = mkInt32 20;
            cursor-theme = "Bibata-Modern-Ice";
            document-font-name = "Maple Mono NF CN 12";
            font-name = "Maple Mono NF CN 12";
            gtk-theme = "Everforest-Dark";
            gtk-enable-primary-paste = true;
            icon-theme = "Papirus-Light";
            monospace-font-name = "Maple Mono NF CN 13";
            text-scaling-factor = mkDouble 1.0;
          };

          "org/gnome/desktop/sound" = {
            theme-name = "freedesktop";
          };

          "org/gtk/gtk4/Settings/FileChooser" = {
            clock-format = "24h";
          };

          "org/gtk/Settings/FileChooser" = {
            clock-format = "24h";
          };
        };
      }
    ];
    file-roller.enable = isInstall;
    gnome-disks.enable = isInstall;
    hyprland = {
      enable = true;
      # package = pkgs.hyprland;
      # portalPackage = inputs.hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland;
      systemd.setPath.enable = true;
    };
    nautilus-open-any-terminal = {
      enable = true;
      terminal = "st";
    };
    nm-applet = lib.mkIf config.networking.networkmanager.enable {
      enable = true;
      indicator = true;
    };
    seahorse.enable = isInstall;
    udevil.enable = true;
  };
  security = {
    pam.services.hyprlock = {};
    polkit = {
      enable = true;
    };
  };

  services = {
    dbus = {
      implementation = "broker";
      packages = with pkgs; [gcr];
    };
    devmon.enable = true;
    gnome = {
      gnome-keyring.enable = isInstall;
      sushi.enable = isInstall;
    };
    # thunar
    gvfs.enable = true; # Mount, trash, and other functionalities
    tumbler.enable = true; # Thumbnail support for images
  };
}
