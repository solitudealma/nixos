{
  lib,
  username,
  ...
}: let
  installFor = ["solitudealma"];
in
  lib.mkIf (lib.elem username installFor) {
    # https://wiki.nixos.org/w/index.php?title=Appimage
    # https://nixos.org/manual/nixpkgs/stable/#sec-pkgs-appimageTools
    programs.appimage = {
      enable = true;
      binfmt = true;
    };
  }
