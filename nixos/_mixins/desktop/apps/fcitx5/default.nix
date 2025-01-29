{
  desktop,
  lib,
  pkgs,
  ...
}: {
  i18n.inputMethod = {
    fcitx5 = {
      waylandFrontend = lib.optionals (desktop == "gnome" || desktop == "river") true;
    };
  };
}
