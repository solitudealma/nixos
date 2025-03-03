{
  desktop,
  lib,
  pkgs,
  ...
}: {
  home = {
    packages = with pkgs;
      []
      ++ lib.optionals (lib.elem desktop ["dwl" "hyprland" "niri"]) [
        wl-clipboard
        wl-clip-persist
        wtype
      ];
  };

  programs = {
    rofi = {
      enable = true;
      package =
        if (lib.elem desktop ["dwl" "hyprland" "niri"])
        then pkgs.rofi-wayland
        else pkgs.rofi;
      plugins = with pkgs; [rofi-calc];
    };
  };

  xdg.configFile."rofi" = {
    source = ../../../configs/rofi;
    recursive = true; # 递归整个文件夹
    executable = true; # 将其中所有文件添加「执行」权限
  };
}
