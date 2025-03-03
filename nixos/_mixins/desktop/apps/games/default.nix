{
  isInstall,
  isWorkstation,
  lib,
  username,
  ...
}: let
  installFor = ["solitudealma"];
in
  lib.mkIf (lib.elem username installFor && isInstall && isWorkstation) {
    # Runtime parameters of the Linux kernel as set by sysctl(8); Here, to future-proof for heavier games.
    boot.kernel.sysctl = {"vm.max_map_count" = 2147483642;};

    # Remove certain resource limits for programs that needs them gone, mostly for heavier emulators.
    security.pam.loginLimits = [
      {
        domain = "*";
        type = "hard";
        item = "memlock";
        value = "unlimited";
      }
      {
        domain = "*";
        type = "soft";
        item = "memlock";
        value = "unlimited";
      }
    ];

    environment = {
      systemPackages = [
      ];
    };
  }
