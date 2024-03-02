{
  lib,
  config,
  inputs,
  pkgs,
  ...
}:
with lib; let
  username = import ../../../username.nix;
  cfg = config.modules.desktop;
  inherit (config.modules) graphics;
in {
  config = mkMerge [
    (
      mkIf (cfg.desktop == "hyprland") {
        home-manager.users.${username} = {
          xdg.configFile."hypr" = {
            source = ./hypr;
            recursive = true; # 递归整个文件夹
            executable = true; # 将其中所有文件添加「执行」权限
          };
          wayland.windowManager.hyprland.settings = mkMerge [
            (mkIf (cfg.panel == "nwg-panel") {
              exec = [
                "nwg-panel"
              ];
            })
          ];
        };
      }
    )
  ];
}
