{
  lib,
  pkgs,
  ...
}: {
  # hyprpicker is a color picker for Hyprland
  home = {
    packages = with pkgs; [
      hyprpicker
    ];
  };
  wayland.windowManager.hyprland = {
    settings = {
      bind = [
        "$MAIN_MOD, P, exec, ${lib.getExe pkgs.hyprpicker} --autocopy"
      ];
    };
  };
}
