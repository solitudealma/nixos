{
  config,
  pkgs,
  ...
}: let
  inherit (config._custom.globals) configDirectory;
in {
  home.packages = with pkgs; [
    picom
  ];
  xdg.configFile."picom".source = config.lib.file.mkOutOfStoreSymlink "${configDirectory}/home-manager/_mixins/configs/picom";
}
