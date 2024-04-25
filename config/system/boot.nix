{
  pkgs,
  config,
  ...
}: {
  # Bootloader
  boot = {
    loader.systemd-boot.enable = false;
    loader = {
      efi.canTouchEfiVariables = true;
      grub = {
        enable = true;
        device = "nodev";
        useOSProber = true;
        efiSupport = true;
      };
    };
    supportedFilesystems = ["ntfs" "btrfs"];
    kernel.sysctl = {"vm.max_map_count" = 2147483642;};
    tmp.useTmpfs = false;
    tmp.tmpfsSize = "25%";

    # This is for OBS Virtual Cam Support - v4l2loopback setup
    kernelModules = ["v4l2loopback"];
    extraModulePackages = [config.boot.kernelPackages.v4l2loopback];
  };
}
