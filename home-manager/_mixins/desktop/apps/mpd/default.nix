{pkgs, ...}: {
  home.packages = with pkgs; [
    mpc-cli
  ];
  xdg.configFile."mpd" = {
    source = ../../../configs/mpd;
    recursive = true; # 递归整个文件夹
  };
  services.mpd = {
    enable = true;
  };
}
