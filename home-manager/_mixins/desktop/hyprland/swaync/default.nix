{
  lib,
  pkgs,
  ...
}: let
  pngFiles = builtins.filter (file: builtins.match ".*\\.png" file != null) (
    builtins.attrNames (builtins.readDir ./icons)
  );
in {
  # Copy .png files in the current directory to the wlogout configuration directory
  home.file = builtins.listToAttrs (
    builtins.map (pngFile: {
      name = "${config.xdg.configHome}/swaync/icons/${pngFile}";
      value = {
        source = ./icons/${pngFile};
      };
    })
    pngFiles
  );

  # swaync is a notification daemon
  services = {
    swaync = {
      enable = true;
      settings = {
        "$schema" = "${pkgs.swaynotificationcenter}/etc/xdg/swaync/configSchema.json";
        "positionX" = "right";
        "positionY" = "top";
        "cssPriority" = "user";

        "control-center-width" = 380;
        "control-center-height" = 860;
        "control-center-margin-top" = 2;
        "control-center-margin-bottom" = 2;
        "control-center-margin-right" = 1;
        "control-center-margin-left" = 0;

        "notification-window-width" = 400;
        "notification-icon-size" = 48;
        "notification-body-image-height" = 160;
        "notification-body-image-width" = 200;

        "timeout" = 4;
        "timeout-low" = 2;
        "timeout-critical" = 6;

        "fit-to-screen" = false;
        "keyboard-shortcuts" = true;
        "image-visibility" = "when-available";
        "transition-time" = 200;
        "hide-on-clear" = false;
        "hide-on-action" = false;
        "script-fail-notify" = true;
        "scripts" = {
          "example-script" = {
            "exec" = "echo 'Do something...'";
            "urgency" = "Normal";
          };
        };
        "notification-visibility" = {
          "example-name" = {
            "state" = "muted";
            "urgency" = "Low";
            "app-name" = "Spotify";
          };
        };
        "widgets" = [
          "label"
          "buttons-grid"
          "mpris"
          "title"
          "dnd"
          "notifications"
        ];
        "widget-config" = {
          "title" = {
            "text" = "Notifications";
            "clear-all-button" = true;
            "button-text" = " 󰎟 ";
          };
          "dnd" = {
            "text" = "Do not disturb";
          };
          "label" = {
            "max-lines" = 1;
            "text" = " ";
          };
          "mpris" = {
            "image-size" = 96;
            "image-radius" = 12;
          };
          "volume" = {
            "label" = "󰕾";
            "show-per-app" = true;
          };
          "buttons-grid" = {
            "actions" = [
              {
                "label" = " ";
                "command" = "amixer -q -D pulse sset Master toggle";
              }
              {
                "label" = "";
                "command" = "amixer -D pulse sset Capture toggle";
              }
              {
                "label" = " ";
                "command" = "nm-connection-editor";
              }
              {
                "label" = "󰂯";
                "command" = "blueman-manager";
              }
              {
                "label" = "";
                "command" = "swaylock";
              }
            ];
          };
        };
      };
      style = ''
        /* @import "themes/blue/notifications.css"; */
        * {
            color: #fff;

            all: unset;
            font-size: 14px;
            font-family: "JetBrainsMono NF";
            transition: 200ms;
        }

        .notification-row {
            outline: none;
            margin: 0;
            padding: 0px;
        }

        .floating-notifications.background .notification-row .notification-background {
            background: alpha(#163d63, .55);
            box-shadow: 0 0 8px 0 rgba(0,0,0,.6);
            border: 1px solid #0b2237;
            border-radius: 24px;
            margin: 16px;
            padding: 0;
        }

        .floating-notifications.background .notification-row .notification-background .notification {
            padding: 6px;
            border-radius: 12px;
        }

        .floating-notifications.background .notification-row .notification-background .notification.critical {
            border: 2px solid #185490;
        }

        .floating-notifications.background .notification-row .notification-background .notification .notification-content {
            margin: 14px;
        }

        .floating-notifications.background .notification-row .notification-background .notification > *:last-child > * {
            min-height: 3.4em;
        }

        .floating-notifications.background .notification-row .notification-background .notification > *:last-child > * .notification-action {
            border-radius: 8px;
            background-color: #123354;
            margin: 6px;
            border: 1px solid transparent;
        }

        .floating-notifications.background .notification-row .notification-background .notification > *:last-child > * .notification-action:hover {
            background-color: #7289da;
            border: 1px solid #0b2237;
        }

        .floating-notifications.background .notification-row .notification-background .notification > *:last-child > * .notification-action:active {
            background-color: #0b2237;
            color: #163d63;
        }

        .image {
            margin: 10px 20px 10px 0px;
        }

        .summary {
            font-weight: 800;
            font-size: 1rem;
        }

        .body {
            font-size: 0.8rem;
        }

        .floating-notifications.background .notification-row .notification-background .close-button {
            margin: 6px;
            padding: 2px;
            border-radius: 6px;
            background-color: transparent;
            border: 1px solid transparent;
        }

        .floating-notifications.background .notification-row .notification-background .close-button:hover {
            background-color: #0b2237;
        }

        .floating-notifications.background .notification-row .notification-background .close-button:active {
            background-color: #0b2237;
            color: #163d63;
        }

        .notification.critical progress {
            background-color: #0b2237;
        }

        .notification.low progress,
        .notification.normal progress {
            background-color: #0b2237;
        }


        /* @import "themes/blue/central_control.css"; */

        * {
        	color: #fff;

        	all: unset;
        	font-size: 14px;
        	font-family: "JetBrainsMono NF";
        	transition: 200ms;
        }

        /* Avoid 'annoying' backgroud */
        .blank-window {
        	background: transparent;
        }

        /* CONTROL CENTER ------------------------------------------------------------------------ */

        .control-center {
        	background: alpha(#163d63, 0.55);
        	border-radius: 24px;
        	border: 1px solid #0b2237;
        	box-shadow: 0 0 10px 0 rgba(0, 0, 0, 0.6);
        	margin: 18px;
        	padding: 12px;
        }

        /* Notifications  */
        .control-center .notification-row .notification-background,
        .control-center
        	.notification-row
        	.notification-background
        	.notification.critical {
        	background-color: #123354;
        	border-radius: 16px;
        	margin: 4px 0px;
        	padding: 4px;
        }

        .control-center
        	.notification-row
        	.notification-background
        	.notification.critical {
        	color: #185490;
        }

        .control-center
        	.notification-row
        	.notification-background
        	.notification
        	.notification-content {
        	margin: 6px;
        	padding: 8px 6px 2px 2px;
        }

        .control-center
        	.notification-row
        	.notification-background
        	.notification
        	> *:last-child
        	> * {
        	min-height: 3.4em;
        }

        .control-center
        	.notification-row
        	.notification-background
        	.notification
        	> *:last-child
        	> *
        	.notification-action {
        	background: alpha(#0b2237, 0.6);
        	color: #fff;
        	border-radius: 12px;
        	margin: 6px;
        }

        .control-center
        	.notification-row
        	.notification-background
        	.notification
        	> *:last-child
        	> *
        	.notification-action:hover {
        	background: #0b2237;
        }

        .control-center
        	.notification-row
        	.notification-background
        	.notification
        	> *:last-child
        	> *
        	.notification-action:active {
        	background-color: #0b2237;
        }

        /* Buttons */

        .control-center .notification-row .notification-background .close-button {
        	background: transparent;
        	border-radius: 6px;
        	color: #fff;
        	margin: 0px;
        	padding: 4px;
        }

        .control-center .notification-row .notification-background .close-button:hover {
        	background-color: #0b2237;
        }

        .control-center
        	.notification-row
        	.notification-background
        	.close-button:active {
        	background-color: #0b2237;
        }

        progressbar,
        progress,
        trough {
        	border-radius: 12px;
        }

        progressbar {
        	background-color: rgba(255, 255, 255, 0.1);
        }

        /* Notifications expanded-group */

        .notification-group {
        	margin: 2px 8px 2px 8px;
        }
        .notification-group-headers {
        	font-weight: bold;
        	font-size: 1.25rem;
        	color: #fff;
        	letter-spacing: 2px;
        }

        .notification-group-icon {
        	color: #fff;
        }

        .notification-group-collapse-button,
        .notification-group-close-all-button {
        	background: transparent;
        	color: #fff;
        	margin: 4px;
        	border-radius: 6px;
        	padding: 4px;
        }

        .notification-group-collapse-button:hover,
        .notification-group-close-all-button:hover {
        	background: #7289da;
        }

        /* WIDGETS --------------------------------------------------------------------------- */

        /* Notification clear button */
        .widget-title {
        	font-size: 1.2em;
        	margin: 6px;
        }

        .widget-title button {
        	background: #123354;
        	border-radius: 6px;
        	padding: 4px 16px;
        }

        .widget-title button:hover {
        	background-color: #7289da;
        }

        .widget-title button:active {
        	background-color: #0b2237;
        }

        /* Do not disturb */
        .widget-dnd {
        	margin: 6px;
        	font-size: 1.2rem;
        }

        .widget-dnd > switch {
        	background: #123354;
        	font-size: initial;
        	border-radius: 8px;
        	box-shadow: none;
        	padding: 2px;
        }

        .widget-dnd > switch:hover {
        	background: #7289da;
        }

        .widget-dnd > switch:checked {
        	background: #0b2237;
        }

        .widget-dnd > switch:checked:hover {
        	background: #7289da;
        }

        .widget-dnd > switch slider {
        	background: #fff;
        	border-radius: 6px;
        }

        /* Buttons menu */
        .widget-buttons-grid {
        	font-size: x-large;
        	padding: 6px 2px;
        	margin: 6px;
        	border-radius: 12px;
        	background: #123354;
        }

        .widget-buttons-grid > flowbox > flowboxchild > button {
        	margin: 4px 10px;
        	padding: 6px 12px;
        	background: transparent;
        	border-radius: 8px;
        }

        .widget-buttons-grid > flowbox > flowboxchild > button:hover {
        	background: #7289da;
        }

        /* Music player */
        .widget-mpris {
        	background: #123354;
        	border-radius: 16px;
        	color: #fff;
        	margin: 20px 6px;
        }

        /* NOTE: Background need *opacity 1* otherwise will turn into the album art blurred  */
        .widget-mpris-player {
        	background-color: #123354;
        	border-radius: 22px;
        	padding: 6px 14px;
        	margin: 6px;
        }

        .widget-mpris > box > button {
        	color: #fff;
        	border-radius: 20px;
        }

        .widget-mpris button {
        	color: alpha(#fff, 0.6);
        }

        .widget-mpris button:hover {
        	color: #fff;
        }

        .widget-mpris-album-art {
        	border-radius: 16px;
        }

        .widget-mpris-title {
        	font-weight: 700;
        	font-size: 1rem;
        }

        .widget-mpris-subtitle {
        	font-weight: 500;
        	font-size: 0.8rem;
        }

        /* Volume */
        .widget-volume {
        	background: #123354;
        	color: #163d63;
        	padding: 4px;
        	margin: 6px;
        	border-radius: 6px;
        }
      '';
    };
  };
  wayland.windowManager.hyprland = {
    settings = {
      bind = [
        "CTRL ALT, N, exec, ${pkgs.swaynotificationcenter}/bin/swaync-client --toggle-panel --skip-wait"
      ];
    };
  };
}
