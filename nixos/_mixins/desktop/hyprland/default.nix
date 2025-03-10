{
  config,
  isInstall,
  lib,
  pkgs,
  username,
  ...
}: let
  inherit (config._custom.globals) fonts;
  mkHiddenWaylandSession = name:
    pkgs.writeTextDir "share/wayland-sessions/${name}.desktop" ''
      [Desktop Entry]
      Name="Hidden-${name}"
      NoDisplay=true
    '';
  dbusService =
    if config.services.dbus.implementation == "broker"
    then "dbus-broker.service"
    else "dbus.service";
  # Create a simple Wayland session that starts Hyprland and cleans up after itself
  hyprlandSession = pkgs.symlinkJoin {
    name = "hyprland-session";
    paths = [
      (pkgs.writeShellScriptBin "Hyprshim" ''
        # Ensure log directory exists
        LOG_DIR="$HOME/.local/log"
        LOG_FILE="$LOG_DIR/hyprland.log"
        mkdir -p "$LOG_DIR"
        # Rotate logs before starting new session
        if [ -f "$LOG_FILE" ]; then
          # Remove oldest log (10)
          [ -f "$LOG_FILE.10" ] && rm "$LOG_FILE.10"
          # Rotate existing logs
          for i in $(seq 9 -1 1); do
            [ -f "$LOG_FILE.$i" ] && mv "$LOG_FILE.$i" "$LOG_FILE.$((i+1))"
          done
          # Move current log to .1
          mv "$LOG_FILE" "$LOG_FILE.1"
        fi
        # Run Hyprland and log output
        ${pkgs.expect}/bin/unbuffer /run/current-system/sw/bin/Hyprland $@ 2>&1 | ${pkgs.coreutils}/bin/tee -a "$LOG_FILE" &>/dev/null
        # Log the exit code here
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] Hyprland exited with code $?" | ${pkgs.coreutils}/bin/tee -a "$LOG_FILE"
        # Clean up the session
        pkill -u "${username}" trayscale
        UNITS=(
          xdg-desktop-portal-hyprland.service
          xdg-desktop-portal-gtk.service
          xdg-desktop-portal.service
          waybar.service
          ${dbusService}
          hyprland-session.target
        )
        for UNIT in "''${UNITS[@]}"; do
          echo "[$(date '+%Y-%m-%d %H:%M:%S')] Checking $UNIT" | ${pkgs.coreutils}/bin/tee -a "$LOG_FILE"
          if /run/current-system/sw/bin/systemctl --user --machine=${username}@.host list-unit-files "$UNIT" &>/dev/null; then
            if /run/current-system/sw/bin/systemctl --user --machine=${username}@.host is-active "$UNIT" &>/dev/null; then
              echo "[$(date '+%Y-%m-%d %H:%M:%S')] Stopping $UNIT" | ${pkgs.coreutils}/bin/tee -a "$LOG_FILE"
              /run/current-system/sw/bin/systemctl --user --machine=${username}@.host stop "$UNIT"
            else
              echo "[$(date '+%Y-%m-%d %H:%M:%S')] $UNIT is not running" | ${pkgs.coreutils}/bin/tee -a "$LOG_FILE"
            fi
          else
            echo "[$(date '+%Y-%m-%d %H:%M:%S')] $UNIT not found" | ${pkgs.coreutils}/bin/tee -a "$LOG_FILE"
          fi
        done
      '')
      (pkgs.writeTextFile {
        name = "hyprland-session-desktop";
        destination = "/share/wayland-sessions/Hyprshim.desktop";
        text = ''
          [Desktop Entry]
          Name=Hyprland
          Comment=An intelligent dynamic tiling Wayland compositor
          Exec=Hyprshim
          Type=Application
          DesktopNames=Hyprland
          Keywords=tiling;wayland;compositor;
        '';
      })
    ];
    # Add passthru metadata to specify session names
    passthru.providedSessions = ["Hyprshim"];
  };
in {
  imports = [../greeters];
  environment = {
    # Enable HEIC image previews in Nautilus
    pathsToLink = ["/share" "share/thumbnailers"];
    sessionVariables = {
      # Workaround GTK4 bug:
      # - https://gitlab.gnome.org/GNOME/gtk/-/issues/7022
      # - https://github.com/hyprwm/Hyprland/issues/7854
      GDK_DISABLE = "vulkan";
      QT_WAYLAND_DISABLE_WINDOWDECORATION = 1;
      # The the desktop sessions provide by the Hyprland package
      XDG_DATA_DIRS = [
        "${mkHiddenWaylandSession "hyprland"}/share"
        "${mkHiddenWaylandSession "hyprland-systemd"}/share"
      ];
    };
    systemPackages = with pkgs;
      lib.optionals isInstall [
        hyprlandSession
        hyprcursor
        hyprshade
        pyprland
        brightnessctl
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
        wl-clipboard
        wtype
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
            document-font-name = "${fonts.mono} 12";
            font-name = "${fonts.mono} 12";
            gtk-theme = "Everforest-Dark";
            gtk-enable-primary-paste = true;
            icon-theme = "Papirus-Light";
            monospace-font-name = "${fonts.mono} 13";
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
      systemd.setPath.enable = true;
    };
    iio-hyprland = {
      enable = true;
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
    displayManager = {
      sessionPackages = [hyprlandSession];
    };
    gnome = {
      gnome-keyring.enable = isInstall;
      sushi.enable = isInstall;
    };
    # thunar
    gvfs.enable = true; # Mount, trash, and other functionalities
    tumbler.enable = true; # Thumbnail support for images
  };
}
