{
  config,
  hostname,
  lib,
  pkgs,
  ...
}: let
  inherit (config._custom.globals) fonts;
  passwordPrompt =
    if hostname == "tanis"
    then "󰈷"
    else "󰌋";
  monitor = "eDP-1";
in {
  # Hyprlock is a lockscreen that is a part of the hyprland suite
  programs = {
    hyprlock = {
      enable = true;
      settings = {
        background = [
          {
            path = "/etc/backgrounds/4.png";
            blur_size = 4;
            blur_passes = 3;
            noise = 0.0117;
            contrast = 1.3000;
            brightness = 0.8000;
            vibrancy = 0.2100;
            vibrancy_darkness = 0.0;
          }
        ];
        image = [
          {
            # Avatar
            monitor = monitor;
            path = "$HOME/.face";
            size = 300;
            rounding = -1;
            border_size = 4;
            border_color = "rgb(51, 204, 255)";
            rotate = 0;
            reload_time = -1;
            reload_cmd = "";

            position = "0, 200";
            halign = "center";
            valign = "center";
          }
        ];
        label = [
          {
            # Date (1 hour)
            monitor = monitor;
            text = ''cmd[update:3600000] echo -e "$(date +"%a, %d %b")"'';
            color = "rgba(205, 214, 244, 0.9)";
            font_size = 25;
            font_family = "Work Sans Bold";
            position = "0, 440";
            halign = "center";
            valign = "center";
          }
          {
            # Weather (30min)
            monitor = monitor;
            text = ''cmd[update:18000000] echo "<b> "$(date +'%A, %-d %B %Y')" </b>"'';

            font_size = 24;
            font_family = "${fonts.mono} 10";

            position = "0, -120";
            halign = "center";
            valign = "center";
          }
        ];
        # Password
        input-field = [
          {
            monitor = monitor;
            size = "250, 50";
            outline_thickness = 3;
            dots_size = 0.26;
            dots_spacing = 0.64;
            dots_center = true;
            fade_on_empty = true;
            placeholder_text = "<i>Password...</i>";
            hide_input = false;
            check_color = "rgb(40, 200, 250)";

            position = "0, 50";
            halign = "center";
            valign = "bottom";
          }
        ];
      };
    };
  };
  services = {
    hypridle = {
      enable = true;
      settings = {
        general = {
          ignore_dbus_inhibit = false;
          lock_cmd = "${lib.getExe pkgs.hyprlock}";
          before_sleep_cmd = "${lib.getExe pkgs.hyprlock}";
          after_sleep_cmd = "hyprctl dispatch dpms on";
        };
        listener = [
          {
            timeout = 600;
            on-timeout = "${lib.getExe pkgs.hyprlock}";
          }
          {
            timeout = 605;
            on-timeout = "hyprctl dispatch dpms off";
            on-resume = "hyprctl dispatch dpms on";
          }
        ];
      };
    };
  };
  systemd.user.services = {
    sway-audio-idle-inhibit = {
      Unit = {
        Description = "Prevents swayidle from sleeping while any application is outputting or receiving audio.";
        Documentation = "https://github.com/ErikReider/SwayAudioIdleInhibit";
        After = ["hypridle.service"];
        Wants = ["hypridle.service"];
      };
      Service = {
        PassEnvironment = "PATH";
        ExecStart = "${pkgs.sway-audio-idle-inhibit}/bin/sway-audio-idle-inhibit";
        Type = "simple";
      };
    };
  };
}
