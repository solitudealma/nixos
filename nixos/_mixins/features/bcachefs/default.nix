{
  hostname,
  isISO,
  lib,
  pkgs,
  ...
}: let
  installOn = [
    "laptop"
  ];
in
  lib.mkIf (lib.elem hostname installOn || isISO) {
    # Bootable ISO images include bcachefs tools
    # - https://wiki.nixos.org/wiki/Bcachefs
    environment.systemPackages = with pkgs; [
      bcachefs-tools
      keyutils
    ];
  }
