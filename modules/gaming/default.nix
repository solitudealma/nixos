{
  config,
  lib,
  inputs,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.gaming;
  username = import ../../username.nix;
  inherit (config.modules) graphics;
in {
  imports = [
    inputs.nix-gaming.nixosModules.pipewireLowLatency
    inputs.nix-gaming.nixosModules.steamCompat
    ./options.nix
  ];

  config = mkMerge [
    (mkIf cfg.enable {
      services.pipewire = {
        lowLatency = {
          enable = true;
          quantum = 64;
          rate = 48000;
        };
      };
      hardware.xpadneo.enable = true;

      home-manager.users.${username} = {
        wayland.windowManager.hyprland.xwayland.enable = true;
      };
    })
    (mkIf cfg.steam {
      environment.systemPackages = with pkgs; [
        protontricks
      ];
      programs.steam = {
        # Some location that should be persistent:
        #   ~/.local/share/Steam - The default Steam install location
        #   ~/.local/share/Steam/steamapps/common - The default Game install location
        #   ~/.steam/root        - A symlink to ~/.local/share/Steam
        #   ~/.steam             - Some Symlinks & user info
        enable = true;
        remotePlay.openFirewall = true;
        dedicatedServer.openFirewall = true;
        # fix gamescope inside steam
        package = pkgs.steam.override {
          extraPkgs = pkgs:
            with pkgs; [
              keyutils
              libkrb5
              libpng
              libpulseaudio
              libvorbis
              stdenv.cc.cc.lib
              xorg.libXcursor
              xorg.libXi
              xorg.libXinerama
              xorg.libXScrnSaver
            ];
        };
        extraCompatPackages = with pkgs; [
          steamtinkerlaunch
          gamescope
          inputs.nix-gaming.packages.${pkgs.system}.proton-ge
        ];
      };
      hardware.opengl.driSupport32Bit = true;
    })
    (mkIf cfg.wine {
      environment.systemPackages = with pkgs; [
        winetricks
        wine-wayland
      ];
    })
    (mkIf cfg.lutris {
      environment.systemPackages = with pkgs; [
        lutris
      ];
      hardware.opengl.driSupport32Bit = true;
    })
  ];
}
