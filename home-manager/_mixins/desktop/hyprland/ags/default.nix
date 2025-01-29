{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: {
  imports = [
    inputs.ags.homeManagerModules.default
  ];

  home = {
    packages = with pkgs; [
      bun
      inotify-tools
      hyprpicker
      hyprshade
      sassc
      zenity
    ];
  };

  programs.ags = {
    configDir = null; # if ags dir is managed by home-manager, it'll end up being read-only. not too cool.

    enable = true;
    extraPackages = with pkgs.unstable; [
      libgtop
      gtksourceview
      webkitgtk
      accountsservice
    ];
  };

  xdg.configFile."ags".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/ags-dots";
}
