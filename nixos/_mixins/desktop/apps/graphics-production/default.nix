{
  lib,
  pkgs,
  username,
  ...
}: let
  installFor = ["solitudealma"];
in
  lib.mkIf (lib.elem username installFor) {
    environment.systemPackages = with pkgs; [
      aseprite # pixel art paint tool
      gimp
      inkscape
    ];
  }
