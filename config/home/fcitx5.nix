{
  pkgs,
  config,
  lib,
  host,
  ...
}: {
  home.sessionVariables = {
    GTK_IM_MODULE = "fcitx5";
    QT_IM_MODULE = "fcitx5";
    XMODIFIERS = "\@im=fcitx5";
    SDL_IM_MODULE = "fcitx";
    GLFW_IM_MODULE = "ibus";
    INPUT_METHOD = "fcitx5";
  };
  xdg.configFile."fcitx5" = {
    recursive = true;
    source = ./files/fcitx5;
    force = true;
  };
}
