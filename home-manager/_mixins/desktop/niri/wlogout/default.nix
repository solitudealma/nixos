{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  inherit (config._custom.globals) fonts;
  pngFiles = builtins.filter (file: builtins.match ".*\\.png" file != null) (
    builtins.attrNames (builtins.readDir ./icons)
  );
in {
  # Copy .png files in the current directory to the wlogout configuration directory
  home.file = builtins.listToAttrs (
    builtins.map (pngFile: {
      name = "${config.xdg.configHome}/wlogout/icons/${pngFile}";
      value = {
        source = ./icons/${pngFile};
      };
    })
    pngFiles
  );

  programs = {
    wlogout = {
      enable = true;
      layout = [
        {
          label = "shutdown";
          action = "shutdown";
          text = "Shutdown";
          keybind = "s";
        }
        {
          label = "reboot";
          action = "reboot";
          text = "Reboot";
          keybind = "r";
        }
        {
          label = "logout";
          action = "${lib.getExe pkgs.niri-unstable} msg action quit";
          text = "Logout";
          keybind = "e";
        }
        {
          label = "suspend";
          action = "systemctl suspend";
          text = "Suspend";
          keybind = "u";
        }
        {
          label = "lock";
          action = "hyprlock";
          text = "Lock";
          keybind = "l";
        }
      ];
      style = ''
        window {
        	font-family: "${fonts.mono}";
        	font-size: 16pt;
        	color: #fff;
        	background-color: rgba(24, 27, 32, 0.2);
        }

        button {
        	background-repeat: no-repeat;
        	background-position: center;
        	background-size: 20%;
        	background-color: transparent;
        	animation: gradient_f 20s ease-in infinite;
        	transition: all 0.3s ease-in;
        	box-shadow: 0 0 10px 2px transparent;
        	border-radius: 36px;
        	margin: 10px;
        }

        button:focus {
        	box-shadow: none;
        	background-size: 20%;
        }

        button:hover {
        	background-size: 50%;
        	box-shadow: 0 0 10px 3px rgba(0, 0, 0, 0.4);
        	background-color: #163d63;
        	color: transparent;
        	transition: all 0.4s cubic-bezier(0.55, 0, 0.28, 1.682), box-shadow 1s ease-in;
        }

        #shutdown {
        	background-image: image(url("./icons/power.png"));
        }
        #shutdown:hover {
        	background-image: image(url("./icons/power-hover.png"));
        }

        #logout {
        	background-image: image(url("./icons/logout.png"));
        }
        #logout:hover {
        	background-image: image(url("./icons/logout-hover.png"));
        }

        #reboot {
        	background-image: image(url("./icons/restart.png"));
        }
        #reboot:hover {
        	background-image: image(url("./icons/restart-hover.png"));
        }

        #lock {
        	background-image: image(url("./icons/lock.png"));
        }
        #lock:hover {
        	background-image: image(url("./icons/lock-hover.png"));
        }

        #suspend {
        	background-image: image(url("./icons/sleep.png"));
        }
        #suspend:hover {
        	background-image: image(url("./icons/sleep-hover.png"));
        }

        /*#hibernate {
          background-image: image(url("./icons/hibernate.png"));
        }
        #hibernate:hover {
          background-image: image(url("./icons/hibernate-hover.png"));
        }*/
      '';
    };
  };
}
