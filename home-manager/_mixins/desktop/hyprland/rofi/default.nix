{ pkgs, ... }:
{
  # Fuzzel powered app launcher, emoji picker and clipboard manager for Hyprland
  home = {
    packages = with pkgs; [
      wl-clipboard
      wtype
    ];
  };
  programs = {
    rofi = {
      package = pkgs.rofi-wayland;
      enable = true;
    };
  };
  services = {
    cliphist = {
      enable = true;
      systemdTarget = "hyprland-session.target";
    };
  };

  xdg.configFile."rofi" = {
    source = ../../../configs/rofi;
    recursive = true; # 递归整个文件夹
    executable = true; # 将其中所有文件添加「执行」权限
  };
}
