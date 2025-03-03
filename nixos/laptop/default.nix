{
  config,
  desktop,
  inputs,
  lib,
  username,
  ...
}: {
  imports = [
    inputs.nixos-hardware.nixosModules.common-cpu-intel
    inputs.nixos-hardware.nixosModules.common-gpu-nvidia
    inputs.nixos-hardware.nixosModules.common-pc
    inputs.nixos-hardware.nixosModules.common-pc-ssd
    ./disk.nix
    ./variables.nix
  ];

  _custom.globals.homeDirectory = "/home/${username}";
  _custom.globals.configDirectory = "/home/${username}/Zero/nix-config";

  boot = {
    initrd = {
      availableKernelModules = [
        "xhci_pci"
        "ahci"
        "nvme"
        "usbhid"
        "usb_storage"
        "sd_mod"
        "rtsx_pci_sdmmc"
      ];
    };
    kernelModules = lib.mkIf (desktop != "dwm") [
      "kvm-intel"
      "nvidia"
    ];
    supportedFilesystems = [
      "ntfs"
      "btrfs"
    ];
    tmp = {
      cleanOnBoot = true;
      tmpfsSize = "30%";
      useTmpfs = false;
    };
  };

  hardware = {
    mwProCapture.enable = false;
    nvidia = {
      modesetting.enable = true;
      open = true;
      powerManagement = {
        enable = false;
        finegrained = false;
      };
      package = config.boot.kernelPackages.nvidiaPackages.stable;
      prime = {
        # nix shell nixpkgs#pciutils -c lspci | grep ' VGA '
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
        offload = {
          enable = true;
          enableOffloadCmd = true;
        };
        reverseSync.enable = true;
      };
    };
    xone.enable = true;
  };

  services.xserver.videoDrivers = [
    "nvidia"
  ];

  time.timeZone = "Asia/Shanghai";
}
