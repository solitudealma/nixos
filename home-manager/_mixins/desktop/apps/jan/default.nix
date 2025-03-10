{
  config,
  lib,
  pkgs,
  username,
  ...
}: let
  installFor = [
    "solitudealma"
  ];
  inherit (pkgs.stdenv) isLinux;
in
  lib.mkIf (lib.elem username installFor && isLinux) {
    home = {
      packages = with pkgs; [jan];
    };

    # Sync Jan application state using the Syncthing backed App directory
    systemd.user.tmpfiles.rules = lib.mkIf isLinux [
      "d ${config.home.homeDirectory}/Apps/Jan/settings 0755 ${username} users - -"
      "L+ ${config.home.homeDirectory}/.config/Jan/data/assistants/ - - - - ${config.home.homeDirectory}/Apps/Jan/assistants/"
      "L+ ${config.home.homeDirectory}/.config/Jan/data/engines/ - - - - ${config.home.homeDirectory}/Apps/Jan/engines/"
      "L+ ${config.home.homeDirectory}/.config/Jan/data/extensions/ - - - - ${config.home.homeDirectory}/Apps/Jan/extensions/"
      "L+ ${config.home.homeDirectory}/.config/Jan/data/models/ - - - - ${config.home.homeDirectory}/Apps/Jan/models/"
      "L+ ${config.home.homeDirectory}/.config/Jan/data/settings/@janhq/ - - - - ${config.home.homeDirectory}/Apps/Jan/settings/@janhq/"
      "L+ ${config.home.homeDirectory}/.config/Jan/data/threads/ - - - - ${config.home.homeDirectory}/Apps/Jan/threads/"
      "L+ ${config.home.homeDirectory}/.config/Jan/data/themes/ - - - - ${config.home.homeDirectory}/Apps/Jan/themes/"
      "L+ ${config.home.homeDirectory}/.config/Jan/data/cortex.db - - - - ${config.home.homeDirectory}/Apps/Jan/cortex.db"
    ];
  }
