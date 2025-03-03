{
  lib,
  pkgs,
  username,
  ...
}: {
  users = {
    users = {
      nixosvmtest = {
        group = "nixosvmtest";
        isSystemUser = true;
        initialPassword = "test";
      };
      root = {
        initialHashedPassword = lib.mkForce "$6$uO/ogoAQCipGpetZ$28Bh7XcfQyZlTBWTDyio2azdph.3Kky1u6rdXun6.lGK7Axp9ae3dpcF6iBKyjdilWTGEE/04U.lGglnPT3WO/";
      };

      ${username} = {
        linger = true;
        initialHashedPassword = lib.mkDefault "$6$uO/ogoAQCipGpetZ$28Bh7XcfQyZlTBWTDyio2azdph.3Kky1u6rdXun6.lGK7Axp9ae3dpcF6iBKyjdilWTGEE/04U.lGglnPT3WO/";
        # home = "/home/${user}";
        # group = user;
        isNormalUser = true;
        # isSystemUser = true;
        uid = 1000;
        extraGroups = [
          "wheel"
          "kvm"
          "adbusers"
          "docker"
          "wireshark"
          "tss"
          "podman"
        ];
        shell = pkgs.fish;
      };
      root.shell = pkgs.fish;
    };
    groups.nixosvmtest = {};
    groups.${username} = {};
  };
  security = {
    doas = {
      enable = false;
      wheelNeedsPassword = false;
    };
    sudo-rs = {
      enable = true;
      extraRules = [
        {
          users = ["${username}"];
          commands = [
            {
              command = "ALL";
              options = ["NOPASSWD"];
            }
          ];
        }
      ];
    };
  };
}
