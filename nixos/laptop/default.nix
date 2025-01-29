{
  config,
  inputs,
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
    kernelModules = [
      # "kvm-intel"
      # "nvidia"
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
      nvidiaSettings = false;
      open = true;
      powerManagement = {
        enable = false;
        finegrained = false;
      };
      package = config.boot.kernelPackages.nvidiaPackages.stable;
      #let
      #   # Fixes framebuffer with linux 6.11
      #   fbdev_linux_611_patch = pkgs.fetchpatch {
      #     url = "https://patch-diff.githubusercontent.com/raw/NVIDIA/open-gpu-kernel-modules/pull/692.patch";
      #     hash = "sha256-OYw8TsHDpBE5DBzdZCBT45+AiznzO9SfECz5/uXN5Uc=";
      #   };
      # in
      #   config.boot.kernelPackages.nvidiaPackages.mkDriver {
      #     version = "565.57.01";
      #     sha256_64bit = "sha256-buvpTlheOF6IBPWnQVLfQUiHv4GcwhvZW3Ks0PsYLHo=";
      #     sha256_aarch64 = "sha256-aDVc3sNTG4O3y+vKW87mw+i9AqXCY29GVqEIUlsvYfE=";
      #     openSha256 = "sha256-/tM3n9huz1MTE6KKtTCBglBMBGGL/GOHi5ZSUag4zXA=";
      #     settingsSha256 = "sha256-H7uEe34LdmUFcMcS6bz7sbpYhg9zPCb/5AmZZFTx1QA=";
      #     persistencedSha256 = "sha256-hdszsACWNqkCh8G4VBNitDT85gk9gJe1BlQ8LdrYIkg=";
      #     # patches = [fbdev_linux_611_patch];
      #   };
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
