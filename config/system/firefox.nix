{
  pkgs,
  config,
  lib,
  host,
  ...
}: {
  programs.firefox = {
    enable = true;
    preferencesStatus = "default";
  };
}
