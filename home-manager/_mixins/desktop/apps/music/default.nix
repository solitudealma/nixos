{
  inputs,
  lib,
  pkgs,
  username,
  ...
}: let
  # installFor = ["solitudealma"];
  inherit (pkgs.stdenv) isDarwin isLinux;
in {
  imports = [
    ./ncmpcpp.nix
    # ./spotify.nix
  ];
  home = {
    packages = with pkgs;
      [
        amberol
        audacity # Sound editor with graphical UI
        easytag # Audio tag editor
        kew
        youtube-music
      ]
      ++ lib.optionals isLinux [
        # cider
      ];
  };
}
