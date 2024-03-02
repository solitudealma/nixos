{
  lib,
  config,
  ...
}:
with lib; let
in {
  imports = [
  ];

  config = mkMerge [
    {
      programs.gnupg.agent = {
        enable = true;
        enableSSHSupport = true;
      };
    }

    {
      security.pam.services.swaylock = {
        fprintAuth = false;
      };
    }
  ];
}
