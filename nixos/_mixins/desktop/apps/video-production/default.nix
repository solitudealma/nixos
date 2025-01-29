{
  hostname,
  lib,
  pkgs,
  ...
}:
let
  installOn = [
    "laptop"
  ];
in
lib.mkIf (lib.elem hostname installOn) {
  environment.systemPackages = with pkgs; [
    (davinci-resolve.override {
      studioVariant = true;
    })
    shotcut
  ];
}