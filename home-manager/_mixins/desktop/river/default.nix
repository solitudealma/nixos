{config, ...}: let
  riverPath = "${config._custom.globals.configDirectory}/home-manager/_mixins/configs/river";
in {
  wayland.windowManager.river = {
    enable = true;
    systemd.enable = true;
    xwayland.enable = true;
  };

  xdg.configFile."river".source = config.lib.file.mkOutOfStoreSymlink riverPath;
}
