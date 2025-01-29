{...}: {
  xdg.configFile."zathura" = {
    source = ../../../configs/zathura;
    recursive = true; # 递归整个文件夹
  };
  programs.zathura = {
    enable = true;
  };
}
