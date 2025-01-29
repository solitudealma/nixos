{
  config,
  pkgs,
  ...
}: {
  programs.mpv = {
    enable = true;
    package = pkgs.mpv-vapoursynth;
  };

  xdg.configFile."mpv".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfile/mpv";
}
