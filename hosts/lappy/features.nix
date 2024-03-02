{
  pkgs,
  self,
  inputs,
  ...
}: let
  username = import ../../username.nix;
in {
  imports = [
    ../../modules
    inputs.agenix.nixosModules.default
    # inputs.neovim.nixosModules.neovim
  ];
  config = {
    modules = {
      browser = {
        firefox = true;
      };
      desktop = {
        desktop = "hyprland";
        panel = "waybar";
        inputMethod = "fcitx5";
      };
      displayManager = {
        greeter = "tuigreet";
        defaultSession = "Hyprland";
      };
      dev = {
        enable = true;
        langs = ["golang"];
        devops.tools = ["kubernetes" "direnv"];
      };
      editor = {
        enable = true;
        vscode = true;
        neovim = true;
      };
      gaming.enable = false;
      graphics = {
        type = "intel";
      };
      media = {
        spotify = "spotify-tui";
        plex = true;
      };
      network = {
        enable = true;
        hostName = "lappy";
        additionalNameServers = ["192.168.16.53"];
        ssh.enable = true;
        firewall.enable = true;
        tailscale = {
          enable = true;
          permitCertUid = "2241141629yt@gmail.com";
        };
        disableIPv6 = true;
        clash-verge = true;
      };
      services = {
        pipewire = true;
        printer = true;
        bluetooth = true;
      };
      social = {
        telegram = true;
        discord = false;
        qq = true;
      };
      terminal = {
        yazi = true;
        zellij = true;
      };
      virtualisation = {
        containerVariant = "podman";
      };
    };
    age = {
      identityPaths = [
        "/etc/ssh/ssh_host_ed25519_key"
        "/home/SolitudeAlma/.ssh/id_ed25519"
      ];
    };
    fileSystems."/mnt/kube_storage" = {
      device = "10.0.0.12:/mnt/user/kube_storage";
      fsType = "nfs";
      options = [
        "x-systemd.automount" # automount nfs
        "noauto" # only automount on first access
        "x-systemd.idle-timeout=600" # disconnect if not used for 10 minutes. automount will reconnect on next access
      ];
    };
    hardware = {
      # For zsa keyboards
      keyboard.zsa.enable = true;
      # Enable cause sound don't work
      enableAllFirmware = true;
    };
  };
}
