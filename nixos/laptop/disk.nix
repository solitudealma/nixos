{...}: {
  fileSystems."/" =
    { device = "/dev/disk/by-uuid/6fd656cf-0811-4fb3-9ef9-5c6403422947";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/CE62-9490";
      fsType = "vfat";
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/edcd2491-b8df-4647-9c35-59fea4dbea1a"; }
    ];

  # fileSystems."/" = {
  #   device = "/dev/disk/by-label/laptop";
  #   fsType = "btrfs";
  #   options = [
  #     "subvol=root"
  #     "compress=zstd"
  #   ];
  # };

  # fileSystems."/home" = {
  #   device = "/dev/disk/by-label/laptop";
  #   fsType = "btrfs";
  #   options = [
  #     "subvol=home"
  #     "compress=zstd"
  #   ];
  # };

  # fileSystems."/nix" = {
  #   device = "/dev/disk/by-label/laptop";
  #   fsType = "btrfs";
  #   options = [
  #     "subvol=nix"
  #     "noatime"
  #     "compress=zstd"
  #   ];
  # };

  # fileSystems."/boot" = {
  #   device = "/dev/disk/by-label/ESP";
  #   fsType = "vfat";
  # };

  # swapDevices = [{device = "/dev/disk/by-label/swap";}];
}
