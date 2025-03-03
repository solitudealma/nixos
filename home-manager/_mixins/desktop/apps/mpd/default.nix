{
  config,
  pkgs,
  ...
}: let
  inherit (config._custom.globals) configDirectory;
  mpdPath = "${configDirectory}/home-manager/_mixins/configs/mpd";
in {
  home.packages = with pkgs; [
    mpc-cli
  ];
  services = {
    mpd = {
      enable = true;
      package = pkgs.mpd;
    };
    mpd-mpris.enable = true;
  };
  xdg.configFile."mpd".source = config.lib.file.mkOutOfStoreSymlink mpdPath;
}
