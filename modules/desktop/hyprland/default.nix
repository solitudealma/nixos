{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
with lib; let
  username = import ../../../username.nix;
  cfg = config.modules.desktop;
in {
  imports = [
    ./config.nix
    ./hyprpaper.nix
    ./nwg-panel.nix
    ./hyprland-monitor-attached.nix
    ./nvidia.nix
  ];
  config = mkMerge [
    (
      mkIf (cfg.desktop == "hyprland") {
        programs = {
          hyprland = {
            enable = true;
            package = inputs.hyprland.packages.${pkgs.system}.hyprland;
          };
        };
        fonts.fontconfig.enable = true;
        environment.systemPackages = with pkgs; [
          inputs.hyprland-contrib.packages.${pkgs.system}.grimblast

          wl-clipboard
        ];
        xdg.portal.extraPortals = with pkgs; [xdg-desktop-portal-gtk];

        home-manager.users.${username} = {
          home.packages = with pkgs; [
            libsForQt5.dolphin
            killall
            unzip
            zip
            diskonaut
            krita
            trashy
            ffmpeg
            flameshot
            imv # simple image viewer
            nvtop

            # video/audio tools
            cava # for visualizing audio
            # libva-utils
            # vdpauinfo
            # vulkan-tools
            # glxinfo

            obs-studio
            wf-recorder
            steam
            steamcmd
            #grimblast
            slurp
            swappy
            cliphist
            wlogout
            swww
            swaylock-effects
            swayidle
            catppuccin-papirus-folders
            brightnessctl
            light
            avizo
            swaynotificationcenter

            # audio
            alsa-utils # provides amixer/alsamixer/...
            mpd # for playing system sounds
            mpc-cli # command-line mpd client
            ncmpcpp # a mpd client with a UI
            networkmanagerapplet # provide GUI app: nm-connection-editor

            btop
            nwg-look
            qt5ct
            xdg-utils
            xorg.xrdb
            xorg.xprop
            wlprop
          ];
        };
      }
    )
  ];
}
