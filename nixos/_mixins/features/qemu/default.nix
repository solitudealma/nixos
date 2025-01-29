#Qemu/KVM with virt-manager
{
  config,
  lib,
  username,
  ...
}: {
  programs = {
    virt-manager.enable = true;
  };
  services = {
    qemuGuest.enable = true;
    spice-autorandr.enable = true;
    spice-vdagentd.enable = true; # enable copy and paste between host and guest
  };

  users.users."${username}".extraGroups = lib.optional config.virtualisation.libvirtd.enable "libvirtd";
  virtualisation = {
    libvirtd = {
      enable = true;
      # onBoot = "ignore";
    };
    spiceUSBRedirection.enable = true;
  };
}
