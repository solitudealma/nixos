{
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
    home = {
      packages = with pkgs; [
        (defold.override {
          uiScale = "1.25";
        })
        godot_4-mono # Free and Open Source 2D and 3D game engine with c#
        krita
        love
        # pico8
        pixelorama
      ];
    };
  }
