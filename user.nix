{
  config,
  pkgs,
  ...
}: let
  username = import ./username.nix;
in {
  # Don't allow mutation of users outside the config.
  users.mutableUsers = false;

  users = {
    groups = {
      "${username}" = {};
      docker = {};
      wireshark = {};
      # for android platform tools's udev rules
      adbusers = {};
      dialout = {};
      # for openocd (embedded system development)
      plugdev = {};
      # misc
      uinput = {};
    };

    users = {
      root = {
        initialPassword = "root";
      };
      ${username} = {
        isNormalUser = true;
        extraGroups = ["users" "wheel" "audio" "video" "networkmanager" "docker" "libvirt" "adbusers"];
        initialPassword = username;
      };
    };
  };
}
