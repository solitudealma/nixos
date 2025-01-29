{
  config,
  hostname,
  lib,
  pkgs,
  ...
}: let
  wlogoutMargins =
    if hostname == "vader"
    then "--margin-top 960 --margin-bottom 960"
    else if hostname == "phasma"
    then "--margin-left 540 --margin-right 540"
    else "";
  outputDisplay =
    if (hostname == "vader" || hostname == "phasma")
    then "DP-1"
    else "eDP-1";
  bluetoothToggle = pkgs.writeShellApplication {
    name = "bluetooth-toggle";
    runtimeInputs = with pkgs; [
      bluez
      gawk
      gnugrep
    ];
    text = ''
      HOSTNAME=$(hostname -s)
      state=$(bluetoothctl show | grep 'Powered:' | awk '{ print $2 }')
      if [[ $state == 'yes' ]]; then
        bluetoothctl discoverable off
        bluetoothctl power off
      else
        bluetoothctl power on
        bluetoothctl discoverable on
        if [ "$HOSTNAME" == "phasma" ]; then
            bluetoothctl connect E4:50:EB:7D:86:22
        fi
      fi
    '';
  };
  eyecandyCheck = pkgs.writeShellApplication {
    name = "eyecandy-check";
    runtimeInputs = with pkgs; [
      findutils
      gawk
      jq
    ];
    text = ''
      HYPR_ANIMATIONS=$(hyprctl getoption animations:enabled | awk 'NR==1{print $2}')
      if [ "$HYPR_ANIMATIONS" -eq 1 ] ; then
        echo -en "󱥰\n󱥰  Hyprland eye-candy is enabled\nactive"
      else
        echo -en "󱥱\n󱥱  Hyprland eye-candy is disabled\ninactive"
        # Disable opacity on all clients every 4 seconds
        if [ $(( $(date +%S) % 4 )) -eq 0 ]; then
          hyprctl clients -j | jq -r ".[].address" | xargs -I {} hyprctl setprop address:{} forceopaque 1 lock
        fi
      fi
    '';
  };
  eyecandyToggle = pkgs.writeShellApplication {
    name = "eyecandy-toggle";
    runtimeInputs = with pkgs; [
      findutils
      gawk
      jq
      notify-desktop
    ];
    # https://github.com/hyprwm/Hyprland/issues/3655#issuecomment-1784217814
    text = ''
      HYPR_ANIMATIONS=$(hyprctl getoption animations:enabled | awk 'NR==1{print $2}')
      if [ "$HYPR_ANIMATIONS" -eq 1 ] ; then
        hyprctl --batch "\
          keyword animations:enabled 0;\
          keyword decoration:drop_shadow 0;\
          keyword decoration:blur:enabled 0;\
          keyword layerrule:blur:enabled 0"
          # Disable opacity on all clients
          hyprctl clients -j | jq -r ".[].address" | xargs -I {} hyprctl setprop address:{} forceopaque 1 lock
        notify-desktop "🍬🛑 Eye candy disabled" "Hyprland animations, shadows and blur effects have been disabled." --urgency=low --app-name="Hypr Candy"
      else
        hyprctl reload
        notify-desktop "🍬👀 Eye candy enabled" "Hyprland animations, shadows and blur effects have been restored." --urgency=low --app-name="Hypr Candy"
      fi
    '';
  };
  rofiAppGrid = pkgs.writeShellApplication {
    name = "rofi-appgrid";
    runtimeInputs = with pkgs; [
      rofi-wayland
    ];
    text = ''
      rofi \
        -show drun \
        -theme "${config.xdg.configHome}/rofi/launchers/rofi-appgrid/style.rasi"
    '';
  };
  icons = rec {
    calendar = "󰃭 ";
    clock = " ";
    battery.charging = "󱐋";
    battery.horizontal = [" " " " " " " " " "];
    battery.vertical = ["󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹"];
    battery.levels = battery.vertical;
    network.disconnected = "󰤮 ";
    network.ethernet = "󰈀 ";
    network.strength = ["󰤟 " "󰤢 " "󰤥 " "󰤨 "];
    bluetooth.on = "󰂯";
    bluetooth.off = "󰂲";
    bluetooth.battery = "󰥉";
    volume.source = "󱄠";
    volume.muted = "󰝟";
    volume.levels = ["󰕿" "󰖀" "󰕾"];
    idle.on = "󰈈 ";
    idle.off = "󰈉 ";
  };
in {
  home = {
    file."${config.xdg.configHome}/rofi/launchers/rofi-appgrid/style.rasi".source = ./style.rasi;
  };
  programs = {
    waybar = {
      enable = true;
      package = pkgs.unstable.waybar;
      style = ''
        @define-color base      #1e2326;
        @define-color crust     #272e33;

        @define-color color0    #dbbc7f;
        @define-color color1    #e69875;
        @define-color color2    #a7c080;
        @define-color color3    @color0;
        @define-color color4    #e67e80;
        @define-color color5    #83c092;
        @define-color color6    @color4;
        @define-color color7    @color2;
        @define-color color8    @crust;
        @define-color color9    #495156;

        * {
          font-family: Maple Mono NF CN;
          font-size: 14px;
          font-weight: 500;
          min-height: 0;
          border-color: @bg1;
        }

        window#waybar {
          background: @base;
          color: @color8;
        }

        tooltip {
          background: @base;
          border-color: @crust;
          border-radius: 10px;
          border-style: solid;
          border-width: 2px;
        }

        #backlight,
        #bluetooth,
        #battery,
        #cpu,
        #custom-swaync,
        #memory,
        #network,
        #pulseaudio,
        #temperature,
        #clock,
        #window,
        #mpris,
        #workspaces {
          background: @crust;
          border-radius: 8px;
          border: 1px solid @crust;
          font-weight: 600;
          margin: 6px 0 6px 0;
          padding: 3.5px 16px;
        }

        #tray {
          background: @crust;
          border-radius: 8px;
          border: 1px solid @crust;
          font-weight: 600;
          margin-right: 10px;
          padding: 3.5px 16px;
          padding-left: 10px;
          padding-right: 10px;
        }

        #workspaces {
          font-weight: Bold;
          margin-left: 10px;
          margin-right: 10px;
          padding-left: 3.5px;
          padding-right: 3.5px;
        }

        #workspaces :nth-child(5) {
          margin-right: 0px;
        }

        #workspaces button {
          border-radius: 6px;
          color: @color9;
          padding: 6px;
          margin-right: 5px;
        }

        #workspaces button.active {
          background: @color2;
          color: @color8;
        }

        #workspaces button.focused {
          background: @color7;
          color: @color8;
        }

        #workspaces button.urgent {
          background: @color4;
          color: @color8;
        }

        #workspaces button:hover {
          background: @crust;
          color: @color7;
        }

        #window {
          background: transparent;
          border-radius: 10px;
          margin-left: 60px;
          margin-right: 60px;
        }

        #cpu,
        #memory {
          color: @color1;
        }

        #cpu {
          border-top-right-radius: 0;
          border-bottom-right-radius: 0;
          padding-right: 0;
        }

        #memory {
          border-top-left-radius: 0;
          border-bottom-left-radius: 0;
        }

        #mpris {
          color: @color7;
          margin-left: 10px;
        }

        #clock {
          border-right: 0px;
          color: @color6;
          font-weight: 600;
          margin-right: 10px;
        }

        #custom-swaync {
          color: @color1;
          margin-right: 10px;
          margin-right: 10px;
          padding-right: 18px;
        }

        #network {
          color: @color3;
          margin-right: 10px;
        }

        #pulseaudio {
          border-left: 0px;
          border-right: 0px;
          color: @color5;
          margin-right: 10px;
        }
      '';
      settings = [
        {
          exclusive = true;
          output = outputDisplay;
          layer = "top";
          position = "top";
          mod = "dock";
          height = 0;
          passtrough = false;
          gtk-layer-shell = true;
          modules-left = [
            "niri/workspaces"
            "niri/window"
          ];
          # modules-center = [
          # ];
          modules-right = [
            "tray"
            "cpu"
            "temperature"
            "memory"
            "battery"
            "network"
            "bluetooth"
            "pulseaudio"
            "clock"
          ];
          "niri/window" = {
            "format" = "{title}";
            "icon" = true;
            "max-length" = 20;
            "icon-size" = 20;
            "rewrite" = {
              "(.*) - Mozilla Firefox" = "$1";
              "(.*) - Visual Studio Code" = "$1";
              "(.*) - Inertia" = "🚀 #$1";
              "^\\s*$" = "Dialog";
            };
            # rewrite = {"" = " 🙈 No Windows? ";};
          };
          "niri/workspaces" = {
            active-only = false;
            all-outputs = true;
            format = "{icon}";
            format-icons = {
              "1" = "";
              "2" = "";
              "3" = "";
              "4" = "";
              "5" = "󰈹";
              "6" = "󰎄";
              "7" = "󰘅";
              "8" = "";
              "9" = "";
              "10" = "󰊓";
              default = "";
            };
            on-click = "niri msg action focus-workspace-up";
            on-click-right = "niri msg action focus-workspace-down";
            on-scroll-up = "niri msg action focus-column-left";
            on-scroll-down = "niri msg action focus-column-right";
          };
          cpu = {
            format = "<span color='#b2ccd6'>󰍛</span> {usage}%";
            interval = 2;
            on-click = "st btop";
          };
          memory = {
            format = "<span color='#c792ea'>󰘚</span> {used:.2g}GB";
            interval = 2;
            on-click = "st btop";
          };
          clock = {
            timezone = "Asia/Shanghai";
            format = "${icons.clock} {:%H:%M:%S} paggles";
            tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
          };
          #https://haseebmajid.dev/posts/2024-03-15-til-how-to-get-swaync-to-play-nice-with-waybar/
          "custom/swaync" = {
            format = "<big>{icon}</big>";
            format-icons = {
              none = "";
              notification = "<span foreground='#f5c2e7'>󱅫</span>";
              dnd-none = "󰂠";
              dnd-notification = "󰂞";
              inhibited-none = "";
              inhibited-notification = "<span foreground='#f5c2e7'>󰅸</span>";
              dnd-inhibited-none = "󰪓";
              dnd-inhibited-notification = "󰂟";
            };
            max-length = 3;
            return-type = "json";
            escape = true;
            exec-if = "which ${pkgs.swaynotificationcenter}/bin/swaync-client";
            exec = "${pkgs.swaynotificationcenter}/bin/swaync-client --subscribe-waybar";
            on-click = "${pkgs.swaynotificationcenter}/bin/swaync-client --toggle-panel --skip-wait";
            on-click-middle = "${pkgs.swaynotificationcenter}/bin/swaync-client --toggle-dnd --skip-wait";
            tooltip-format = "󰵚  {} notification(s)";
          };
          tray = {
            icon-size = 15;
            spacing = 8;
          };
          pulseaudio = {
            format = "<span color='#f78c6c'>{icon}</span> {volume}%";
            format-muted = "<span color='#f78c6c'>󰖁</span> {volume}%";
            format-bluetooth = "<span color='#f78c6c'>{icon}</span> {volume}%";
            format-bluetooth-muted = "<span color='#f78c6c'>󰖁</span> {volume}%";
            format-icons = {
              headphone = "󰋋";
              phone = "󰏲";
              portable = "󰏲";
              default = ["󰕿" "󰖀" "󰕾"];
            };
            on-click = "pavucontrol";
          };
          network = {
            format-ethernet = icons.network.ethernet;
            format-wifi = "{icon} {essid}";
            format-disconnected = icons.network.disconnected;
            format-icons = icons.network.strength;
            interval = 2;
            tooltip-format = "{essid}";
            on-click = "nm-applet";
            on-click-right = "killall nm-applet";
          };
          bluetooth = {
            format = "{icon}";
            format-icons = {
              inherit (icons.bluetooth) on off;
              connected = icons.bluetooth.on;
            };
            format-disabled = "";
            format-connected = "{icon} {device_alias}";
            format-connected-battery = "${icons.bluetooth.battery} {device_battery_percentage}%";
            tooltip-format = "{device_alias} {status}";
            on-click = "blueman-applet";
            on-click-right = "killall blueman-applet";
          };
          backlight = {
            device = "thinkpad_acpi";
            format = "<big>{icon}</big>";
            format-alt = "<big>{icon}</big> <small>{percent}󰏰</small>";
            format-icons = [
              ""
              ""
              ""
              ""
              ""
              ""
              ""
              ""
              ""
            ];
            on-click-middle = "${pkgs.avizo}/bin/lightctl set 50";
            on-scroll-up = "${pkgs.avizo}/bin/lightctl up 2";
            on-scroll-down = "${pkgs.avizo}/bin/lightctl down 2";
            tooltip-format = "󰃠  {percent}󰏰";
          };
          temperature = {
            "format" = "<span color='#f07178'></span> {temperatureC}󰔄";
            "interval" = 2;
            "on-click" = "st btop";
          };
          battery = {
            interval = 5;
            states = {
              good = 95;
              warning = 30;
              critical = 15;
            };
            format = "{icon}  {capacity}%";
            format-charging = "{icon}  {capacity}% ${icons.battery.charging}";
            format-plugged = "<span color='#c3e88d'></span> {capacity}%";
            tooltip-format = "{time} left";
            format-icons = icons.battery.levels;
          };
          "custom/session" = {
            format = "<big>󰐥</big>";
            on-click = "${lib.getExe pkgs.wlogout} --buttons-per-row 5 ${wlogoutMargins}";
            tooltip-format = "󰐥  Session Menu";
          };
        }
      ];
      # systemd = {
      #   enable = true;
      #   target = "graphical-session.target";
      # };
    };
  };
}
