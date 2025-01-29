{
  lib,
  pkgs,
  username,
  ...
}:
{
  xdg.configFile."fastfetch" = {
    source = ../../../configs/fastfetch;
    recursive = true;
  };
  
  programs.fastfetch = {
    enable = true;
  };
}
