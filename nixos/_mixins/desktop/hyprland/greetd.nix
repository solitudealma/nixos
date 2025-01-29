{
  hostname,
  lib,
  pkgs,
  username,
  ...
}: let
  sithLord =
    (lib.strings.toUpper (builtins.substring 0 1 hostname))
    + (builtins.substring 1 (builtins.stringLength hostname) hostname);
  hyprLaunch = pkgs.writeShellScriptBin "hypr-launch" ''
    ${pkgs.hyprland}/bin/Hyprland $@ &>/dev/null
    # Correctly clean up the session
    ${pkgs.hyprland}/bin/hyprctl dispatch exit
    systemctl --user --machine=${username}@.host stop dbus-broker
    systemctl --user --machine=${username}@.host stop hyprland-session.target
  '';
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
    KANSHI_REGREET="$(${pkgs.coreutils-full}/bin/head --lines 1 --quiet /etc/kanshi/regreet 2>/dev/null | ${pkgs.gnused}/bin/sed 's/ //g')"
    if [ -n "$KANSHI_REGREET" ]; then
      ${pkgs.cage}/bin/cage -m last -s -- sh -c \
        '${pkgs.kanshi}/bin/kanshi --config /etc/kanshi/regreet & \
          ${pkgs.greetd.regreet}/bin/regreet'
    else
      ${pkgs.cage}/bin/cage -m last -s ${pkgs.greetd.regreet}/bin/regreet
    fi
    # TODO: Make this an attribute set
  '';

  # TODO: Make this an attribute set
  wallpaperResolution =
    if hostname == "laptop"
    then "1920x1080"
    else if hostname == "phasma"
    then "3440x1440"
    else if hostname == "tanis"
    then "1920x1200"
    else "1920x1080";
in {
  # Use a minimal Sway to run regreet
  environment = {
    etc = {
      # Kanshi profiles just for regreet that just enables the primary display
      # - Order is important
      # - The last output to be enabled is what cage will use via `-m last`
      "kanshi/regreet".text =
        if hostname == "laptop"
        then ''
          profile {
            output DP-2 disable
            output HDMI-A-1 disable
            output DP-1 enable mode 1920*1080@144Hz position 0,0 scale 1
          }
        ''
        else "";
    };
    systemPackages = [
      hyprLaunch
      regreetCage
    ];
  };
  programs = {
    regreet = {
      enable = true;
      cursorTheme = {
        name = "Bibata-Modern-Ice";
        package = pkgs.bibata-cursors;
      };
      font = {
        name = "Maple Mono NF CN";
        package = pkgs.maple-mono-NF-CN;
        size = 16;
      };
      iconTheme = {
        name = "Papirus-Light";
        package = pkgs.papirus-icon-theme;
      };
      theme = {
        name = "Everforest-Dark";
        package = pkgs.everforest-gtk-theme;
      };
      settings = {
        appearance = {
          greeting_msg = "May ${sithLord} serve you well";
        };
        application_prefer_dark_theme = true;
        # https://docs.gtk.org/gtk4/enum.ContentFit.html
        background = {
          path = "/etc/backgrounds/4.png";
          fit = "Cover";
        };
        commands = {
          reboot = ["${pkgs.systemd}/bin/systemctl" "reboot"];
          poweroff = ["${pkgs.systemd}/bin/systemctl" "poweroff"];
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
