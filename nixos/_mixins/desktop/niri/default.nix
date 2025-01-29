{
  lib,
  pkgs,
  username,
  ...
}: {
  environment.systemPackages = [
    pkgs.greetd.tuigreet
  ];
  security.pam.services.greetd.enableGnomeKeyring = true;
  services = {
    greetd = {
      enable = true;
      settings = rec {
        initial_session = {
          command = builtins.concatStringsSep " " [
            "tuigreet"
            ''--time --time-format="%F %T"''
            "--remember"
            "--cmd niri-session"
          ];
          user = username;
        };
        default_session = initial_session;
      };
    };
    # thunar
    gvfs.enable = true; # Mount, trash, and other functionalities
    tumbler.enable = true; # Thumbnail support for images
  };
}
