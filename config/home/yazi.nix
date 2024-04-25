{
  pkgs,
  config,
  username,
  lib,
  host,
  ...
}: {
  xdg.configFile."yazi" = {
    source = ./files/yazi;
    recursive = true;
  };
  programs.yazi = {
    enable = true;
    # package = pkgs-unstable.yazi;
    # Changing working directory when exiting Yazi
    enableBashIntegration = true;
    enableZshIntegration = true;
    # TODO: nushellIntegration is broken on release-23.11, wait for master's fix to be released
    enableNushellIntegration = false;
  };
}
