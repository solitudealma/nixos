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
    # for nixosvmtest
    vmVariant = {
      # following configuration is added only when building VM with build-vm
      virtualisation = {
        memorySize = 2048; # Use 2048MiB memory.
        cores = 3;
      };
    };
  };
}
