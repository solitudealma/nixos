{
  config,
  lib,
  pkgs,
  username,
  ...
}: {
  config = {
    environment.systemPackages = with pkgs; [
      scrcpy
    ];
    programs.adb.enable = true;
    # if you don't want to install adb globally but do want to configure the udev rules, you can
    # services.udev.packages = [
    # pkgs.android-udev-rules
    # ];
    users.users."${username}".extraGroups = lib.optionals config.programs.adb.enable ["adbusers" "kvm"];
  };
}
