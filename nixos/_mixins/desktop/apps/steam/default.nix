{
  config,
  hostname,
  lib,
  pkgs,
  ...
}: let
  installOn = [
    "laptop"
  ];
in
  lib.mkIf (lib.elem hostname installOn) {
    # Only include mangohud if Steam is enabled
    environment.systemPackages = with pkgs;
      lib.mkIf config.programs.steam.enable [
        jstest-gtk
        mangohud
        protontricks
      ];
    # https://nixos.wiki/wiki/Steam
    hardware.steam-hardware.enable = true;
    # hardware.xone.enable = true; # support for the xbox controller USB dongle

    programs = {
      gamemode = {
        # Whether to enable GameMode to optimise system performance on demand.
        enable = true;

        # System-wide configuration for GameMode (/etc/gamemode.ini).
        settings.general = {
          softrealtime = "auto";
          renice = 15;
        };
      };
      gamescope = {
        capSysNice = true;
        # Whether to enable gamescope, the SteamOS session compositing window manager.
        enable = true;

        # The gamescope package to use.
        package = pkgs.gamescope;
      };
      steam = {
        dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
        enable = false;
        gamescopeSession.enable = true;
        localNetworkGameTransfers.openFirewall = true;
        package = pkgs.steam.override {
          extraLibraries = p:
            with p; [
              gamemode
              gamescope
              (lib.getLib networkmanager)
            ];
        };
        remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
      };
    };
  }
