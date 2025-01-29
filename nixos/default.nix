{
  config,
  hostname,
  inputs,
  isInstall,
  isWorkstation,
  lib,
  modulesPath,
  outputs,
  platform,
  pkgs,
  stateVersion,
  username,
  ...
}: {
  imports =
    [
      inputs.chaotic.nixosModules.default
      inputs.determinate.nixosModules.default
      inputs.disko.nixosModules.disko
      inputs.nix-flatpak.nixosModules.nix-flatpak
      inputs.nix-index-database.nixosModules.nix-index
      inputs.sops-nix.nixosModules.sops
      (modulesPath + "/installer/scan/not-detected.nix")
      ./${hostname}
      ./_mixins/desktop
      ./_mixins/features
      ./_mixins/scripts
      ./_mixins/services
      ./_mixins/users
    ]
    ++ lib.optional isWorkstation ./_mixins/desktop;

  boot = {
    consoleLogLevel = lib.mkDefault 0;
    initrd.verbose = false;
    kernelModules = ["vhost_vsock"];
    kernelPackages = lib.mkDefault pkgs.linuxPackages_zen;
    # Only enable the systemd-boot on installs, not live media (.ISO images)
    loader = lib.mkIf isInstall {
      systemd-boot.enable = lib.mkForce false;
      efi = {
        canTouchEfiVariables = true;
      };
      grub = {
        devices = ["nodev"];
        efiSupport = true;
        enable = true;
        theme = lib.mkIf isWorkstation (pkgs.stdenv.mkDerivation {
          pname = "Grub-Themes-Arknights_Theresa";
          version = "0.1";
          src = pkgs.fetchFromGitHub {
            owner = "Shelton786";
            repo = "Grub-Themes-Arknights_Theresa";
            rev = "467eb5222b7a2136548fe018637ff2d4162446a4";
            hash = "sha256-z1a2y4mPpMJTazR6Gq8g5iRDAEk7eepAWDloT4/+FJI=";
          };
          installPhase = "cp -r Arknights_Theresa $out";
        });
        # gfxmodeEfi = "1024x768"; # <- 引导界面分辨率
        useOSProber = true;
      };
      timeout = 3;
    };
  };

  # Only install the docs I use
  documentation.enable = true;
  documentation.nixos.enable = false;
  documentation.man.enable = true;
  documentation.info.enable = false;
  documentation.doc.enable = false;

  environment = {
    defaultPackages = with pkgs;
      lib.mkForce [
        coreutils-full
        unstable.neovim-unwrapped
      ];
    systemPackages = with pkgs;
      [
        git
        nix-output-monitor
      ]
      ++ lib.optionals isInstall [
        inputs.fh.packages.${platform}.default
        inputs.nixos-needsreboot.packages.${platform}.default
        nvd
        nvme-cli
        rsync
        smartmontools
        sops
      ];

    variables = {
      EDITOR = "nvim";
      SYSTEMD_EDITOR = "nvim";
      VISUAL = "nvim";
      MOZ_USE_XINPUT2 = "1";
    };
  };

  nix = let
    flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
  in {
    # Opinionated: disable channels
    channel.enable = false;
    settings = {
      auto-optimise-store = true;
      builders-use-substitutes = true;
      experimental-features = ["flakes" "nix-command"];
      # Disable global registry
      flake-registry = "";
      keep-outputs = true;
      keep-derivations = true;
      # Workaround for https://github.com/NixOS/nix/issues/9574
      nix-path = config.nix.nixPath;
      substituters =
        (map (n: "https://${n}.cachix.org") [
          "chaotic-nyx"
          "hyprland"
          "niri"
          "nix-community"
          "nur-pkgs"
        ])
        ++ [
          "https://mirror.sjtu.edu.cn/nix-channels/store" # SJTU - 上海交通大学 Mirror
          "https://mirrors.ustc.edu.cn/nix-channels/store" # USTC - 中国科学技术大学 Mirror
          "https://cache.nixos.org"
          "https://cache.garnix.io"
        ];
      extra-substituters = [];
      extra-trusted-public-keys = [
        "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "chaotic-nyx.cachix.org-1:HfnXSw4pj95iI/n17rIDy40agHj12WfF+Gqk6SonIT8="
        "niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964="
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "nur-pkgs.cachix.org-1:PAvPHVwmEBklQPwyNZfy4VQqQjzVIaFOkYYnmnKco78="
      ];
      trusted-users = [
        "root"
        "${username}"
      ];
      warn-dirty = false;
    };
    # Make flake registry and nix path match flake inputs
    registry = lib.mapAttrs (_: flake: {inherit flake;}) flakeInputs;
    nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
  };

  nixpkgs = {
    config = {
      allowUnfree = true;
      permittedInsecurePackages = [
        "electron-30.5.1"
      ];
    };
    overlays = [
      # Add overlays exported from other flakes:
      inputs.nix-alien.overlays.default
      inputs.niri.overlays.niri
      inputs.nur.overlays.default

      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages
    ];
    hostPlatform = lib.mkDefault "${platform}";
  };

  programs = {
    command-not-found.enable = false;
    nano.enable = lib.mkDefault false;
    nh = {
      clean = {
        enable = true;
        extraArgs = "--keep-since 15d --keep 10";
      };
      enable = true;
      flake = "/home/${username}/Zero/nix-config";
    };
    nix-index-database.comma.enable = isInstall;
    nix-ld = {
      enable = true;
      libraries = with pkgs; [
        # Add any missing dynamic libraries for unpackaged
        # programs here, NOT in environment.systemPackages
      ];
    };
    thunar = lib.optionals isWorkstation {
      enable = true;
      plugins = with pkgs; [
        evince
        ffmpegthumbnailer
        freetype
        totem
        libgsf
        poppler
        nufraw-thumbnailer
        xfce.thunar-archive-plugin
        xfce.thunar-volman
        webp-pixbuf-loader
      ];
    };
    zsh = {
      enable = true;
      shellAliases = {
        nano = "nvim";
      };
    };
  };

  services = {
    fwupd.enable = isInstall;
    hardware.bolt.enable = true;
    libinput = {
      enable = true;
      touchpad.naturalScrolling = true;
      touchpad.tapping = true;
    };
    nfs.server.enable = true;
    # smartd.enable = isInstall; conflicting with earlyoom
  };

  sops = lib.mkIf isInstall {
    age = {
      keyFile = "/home/${username}/.config/sops/age/keys.txt";
      generateKey = false;
    };
    defaultSopsFile = ../secrets/secrets.yaml;
    # sops-nix options: https://dl.thalheim.io/
    secrets = {
      test-key = {};
    };
  };

  # Create symlink to /bin/bash
  # - https://github.com/lima-vm/lima/issues/2110
  systemd = {
    extraConfig = "DefaultTimeoutStopSec=10s";
    tmpfiles.rules = [
      "L+ /bin/bash - - - - ${pkgs.bash}/bin/bash"
      "d /nix/var/nix/profiles/per-user/${username} 0755 ${username} root"
      "d /var/lib/private/sops/age 0755 root root"
    ];
  };

  system = {
    activationScripts = {
      nixos-needsreboot = lib.mkIf isInstall {
        supportsDryActivation = true;
        text = "${lib.getExe inputs.nixos-needsreboot.packages.${pkgs.system}.default} \"$systemConfig\" || true";
      };
    };
    nixos.label = lib.mkIf isInstall "-";
    inherit stateVersion;
  };
}
