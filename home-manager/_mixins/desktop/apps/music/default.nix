{
  lib,
  pkgs,
  username,
  ...
}: let
  # installFor = ["solitudealma"];
  inherit (pkgs.stdenv) isDarwin isLinux;
in {
  imports = [
    ./spotify.nix
  ];
  home = {
    packages = with pkgs;
      [
        audacity # Sound editor with graphical UI
        easytag # Audio tag editor
        ncmpcpp
        kew
        youtube-music
      ]
      ++ lib.optionals isLinux [
        # cider
      ];
  };

  xdg.configFile."ncmpcpp" = {
    source = ../../../configs/ncmpcpp;
    recursive = true;
  };
}
