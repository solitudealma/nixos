{
  pkgs,
  config,
  lib,
  # pkgs-unstable,
  ...
}:
with lib; let
  cfg = config.modules.terminal;
  username = import ../../../username.nix;
in {
  config = mkIf cfg.yazi {
    home-manager.users.${username} = {...}: {
      # terminal file manager
      programs.yazi = {
        enable = true;
        # package = pkgs-unstable.yazi;
        # Changing working directory when exiting Yazi
        enableBashIntegration = true;
        enableFishIntegration = true;
        # TODO: nushellIntegration is broken on release-23.11, wait for master's fix to be released
        enableNushellIntegration = true;
      };

      xdg.configFile."yazi".source = ./yazi;
    };
  };
}
