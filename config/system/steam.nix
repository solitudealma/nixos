{
  pkgs,
  config,
  lib,
  ...
}: {
  # steam-with-pkgs = pkgs.steam.override {
  #   extraPkgs = pkgs:
  #     with pkgs; [
  #       xorg.libXcursor
  #       xorg.libXi
  #       xorg.libXinerama
  #       xorg.libXScrnSaver
  #       libpng
  #       libpulseaudio
  #       libvorbis
  #       stdenv.cc.cc.lib
  #       libkrb5
  #       keyutils
  #       gamescope
  #       mangohud
  #     ];
  # };
  # Steam Configuration
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };
}
