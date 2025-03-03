{
  config,
  hostname,
  isLaptop,
  isWorkstation,
  lib,
  pkgs,
  username,
  ...
}: let
  unmanagedInterfaces =
    lib.optionals config.virtualisation.libvirtd.enable ["virbr0"]
    ++ lib.optionals config.virtualisation.incus.enable ["incusbr0"];
  # Trust the lxd bridge interface, if lxd is enabled
  # Trust the incus bridge interface, if incus is enabled
  # Trust the tailscale interface, if tailscale is enabled
  trustedInterfaces =
    lib.optionals config.virtualisation.libvirtd.enable ["virbr0"]
    ++ lib.optionals config.virtualisation.incus.enable ["incusbr0"];

  # Per-host firewall configuration; mostly for Syncthing which is configured via Home Manager
  allowedTCPPorts = {
    nixosvmtest = [22];
    laptop = [
      22000
    ];
  };
  allowedUDPPorts = {
    laptop = [
      22000
      21027
    ];
  };
in {
  imports = lib.optional (builtins.pathExists (./. + "/${hostname}.nix")) ./${hostname}.nix;

  networking = {
    firewall = {
      enable = true;
      allowedTCPPorts =
        lib.optionals (builtins.hasAttr hostname allowedTCPPorts)
        allowedTCPPorts.${hostname};
      allowedUDPPorts =
        lib.optionals (builtins.hasAttr hostname allowedUDPPorts)
        allowedUDPPorts.${hostname};
      inherit trustedInterfaces;
    };
    hosts = {
      "185.199.109.133" = ["raw.githubusercontent.com"];
      "185.199.111.133" = ["raw.githubusercontent.com"];
      "185.199.110.133" = ["raw.githubusercontent.com"];
      "185.199.108.133" = ["raw.githubusercontent.com"];
    };
    hostName = hostname;
    networkmanager = lib.mkIf isWorkstation {
      enable = true;
      unmanaged = unmanagedInterfaces;
      # wifi.backend = "iwd";
    };
    # https://wiki.nixos.org/wiki/Incus
    nftables.enable = lib.mkIf config.virtualisation.incus.enable true;
    useDHCP = lib.mkDefault true;
  };
  services = {
    avahi = {
      enable = true;
      nssmdns4 = true;
      publish = {
        addresses = true;
        enable = true;
        workstation = isWorkstation;
      };
    };
  };

  # Belt and braces disable WiFi power saving
  systemd.services.disable-wifi-powersave =
    lib.mkIf
    (
      lib.isBool config.networking.networkmanager.wifi.powersave
      && config.networking.networkmanager.wifi.powersave
      && isLaptop
    )
    {
      wantedBy = ["multi-user.target"];
      path = [pkgs.iw];
      script = ''
        iw dev wlp0s20f3 set power_save off
      '';
    };
  # Workaround https://github.com/NixOS/nixpkgs/issues/180175
  systemd.services.NetworkManager-wait-online.enable = lib.mkIf config.networking.networkmanager.enable false;

  users.users.${username}.extraGroups = lib.optionals config.networking.networkmanager.enable [
    "networkmanager"
  ];
}
