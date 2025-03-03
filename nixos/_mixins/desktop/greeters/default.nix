{
  config,
  desktop,
  hostname,
  lib,
  pkgs,
  ...
}: let
  inherit (config._custom.globals) fonts;
  sithLord =
    (lib.strings.toUpper (builtins.substring 0 1 hostname))
    + (builtins.substring 1 (builtins.stringLength hostname) hostname);
  # Reference for setting display configuration for cage
  # - https://github.com/cage-kiosk/cage/issues/304
  # - https://github.com/cage-kiosk/cage/issues/257
  regreetCage = pkgs.writeShellScriptBin "regreet-cage" ''
    # Start regreet in a Wayland kiosk using Cage
    function cleanup() {
      ${pkgs.procps}/bin/pkill kanshi || true
    }
    trap cleanup EXIT

    # If there is a kanshi profile for regreet, use it.
    KANSHI_REGREET="$(${pkgs.coreutils}/bin/head --lines 1 --quiet /etc/kanshi/regreet 2>/dev/null | ${pkgs.gnused}/bin/sed 's/ //g')"
    if [ -n "$KANSHI_REGREET" ]; then
      ${pkgs.cage}/bin/cage -m last -s -- sh -c \
        '${pkgs.kanshi}/bin/kanshi --config /etc/kanshi/regreet & \
         ${pkgs.greetd.regreet}/bin/regreet'
    else
      ${pkgs.cage}/bin/cage -m last -s ${pkgs.greetd.regreet}/bin/regreet
    fi
  '';
  wallpaperResolutions = {
    vader = "2560x2880";
    phasma = "3440x1440";
    tanis = "1920x1200";
    default = "1920x1080";
  };
  wallpaperResolution = wallpaperResolutions.${hostname} or wallpaperResolutions.default;
  # Kanshi profiles for regreet that just enable the primary display:
  # - Order is important
  # - The last enabled output is what cage will use via `-m last`
  kanshiProfiles = {
    laptop = ''
      profile {
        output DP-2 disable
        output HDMI-A-1 disable
        output DP-1 enable mode 1920x1080@144Hz position 0,0 scale 1
      }
    '';
    default = "";
  };
in {
  # Use Cage to run regreet
  environment = {
    etc = {
      "kanshi/regreet".text = kanshiProfiles.${hostname} or kanshiProfiles.default;
    };
    systemPackages = [
      regreetCage
    ];
  };
  programs = {
    regreet = {
      enable = true;
      settings = {
        appearance = {
          greeting_msg = "May ${sithLord} serve you well";
        };
        # https://docs.gtk.org/gtk4/enum.ContentFit.html
        background = {
          path = "/etc/backgrounds/4.png";
          fit = "Cover";
        };
        commands = {
          reboot = ["/run/current-system/sw/bin/systemctl" "reboot"];
          poweroff = ["/run/current-system/sw/bin/systemctl" "poweroff"];
        };
        GTK = lib.mkForce {
          application_prefer_dark_theme = true;
          cursor_theme_name = "Bibata-Modern-Ice";
          font_name = "${fonts.mono} 16";
          icon_theme_name = "Papirus-Light";
          theme_name = "Everforest-Dark";
        };
      };
    };
  };
  security.pam.services.greetd.enableGnomeKeyring = true;
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "regreet-cage";
        user = "greeter";
      };
    };
    vt = 1;
  };
}
