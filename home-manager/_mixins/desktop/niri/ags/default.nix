{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: {
  imports = [
    inputs.ags.homeManagerModules.default
    inputs.stylix.homeManagerModules.stylix
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
    extraPackages = with pkgs; [
      # inputs.ags.packages.${pkgs.system}.mpris
      # inputs.ags.packages.${pkgs.system}.wireplumber
      # inputs.ags.packages.${pkgs.system}.tray
      # inputs.ags.packages.${pkgs.system}.network
      # inputs.ags.packages.${pkgs.system}.battery
      # inputs.ags.packages.${pkgs.system}.apps
      # inputs.ags.packages.${pkgs.system}.auth
      # inputs.ags.packages.${pkgs.system}.bluetooth
      # inputs.ags.packages.${pkgs.system}.notifd
      # inputs.ags.packages.${pkgs.system}.powerprofiles
      # inputs.ags.packages.${pkgs.system}.hyprland
      libgtop
      gtksourceview
      webkitgtk
      accountsservice
    ];
  };
  xdg.configFile."ags".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/ags-dots";
}
