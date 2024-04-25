{
  pkgs,
  hostname,
  host,
  ...
}: let
  inherit
    (import ./hosts/${host}/options.nix)
    theLocale
    theTimezone
    theLCVariables
    theKBDLayout
    flakeDir
    ;
  host_ip = "127.0.0.1";
  port = "7897";
in {
  imports = [
    ./hosts/${host}/hardware.nix
    ./config/system
    ./users/users.nix
  ];

  # Enable networking
  networking = {
    hostName = "${hostname}";
    hosts = {
      "185.199.109.133" = ["raw.githubusercontent.com"];
      "185.199.111.133" = ["raw.githubusercontent.com"];
      "185.199.110.133" = ["raw.githubusercontent.com"];
      "185.199.108.133" = ["raw.githubusercontent.com"];
    };
    networkmanager.enable = true;
    firewall = {
      enable = true;
      allowedTCPPorts = [80 443 53317]; # 53317 is for LocalSend
      allowedUDPPortRanges = [
        {
          from = 4000;
          to = 4007;
        }
        {
          from = 53315;
          to = 53318;
        }
        {
          from = 8000;
          to = 8010;
        }
      ];
    };
    proxy = {
      httpProxy = "http://${host_ip}:${port}";
      httpsProxy = "http://${host_ip}:${port}";
      allProxy = "sockes5://${host_ip}:${port}";
    };
  };
  # Set your time zone
  time.timeZone = "${theTimezone}";

  # Select internationalisation properties
  i18n = {
    defaultLocale = "${theLocale}";
    extraLocaleSettings = {
      LC_ADDRESS = "${theLCVariables}";
      LC_IDENTIFICATION = "${theLCVariables}";
      LC_MEASUREMENT = "${theLCVariables}";
      LC_MONETARY = "${theLCVariables}";
      LC_NAME = "${theLCVariables}";
      LC_NUMERIC = "${theLCVariables}";
      LC_PAPER = "${theLCVariables}";
      LC_TELEPHONE = "${theLCVariables}";
      LC_TIME = "${theLCVariables}";
    };
    supportedLocales = [
      "en_US.UTF-8/UTF-8"
      "C.UTF-8/UTF-8"
      "zh_CN.UTF-8/UTF-8"
      "zh_TW.UTF-8/UTF-8"
    ];
    inputMethod = {
      enabled = "fcitx5";
      fcitx5 = {
        addons = with pkgs; [
          # for flypy chinese input method
          fcitx5-rime
          # needed enable rime using configtool after installed
          fcitx5-configtool
          fcitx5-chinese-addons
          fcitx5-gtk # gtk im module
        ];
      };
    };
  };
  console.keyMap = "${theKBDLayout}";

  # Define a user account.
  users = {
    mutableUsers = true;
  };

  environment = {
    variables = {
      FLAKE = "${flakeDir}";
      ZANEYOS_VERSION = "1.0";
      POLKIT_BIN = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      EDITOR = "nvim";
    };

    sessionVariables = {
      XDG_CACHE_HOME = "$HOME/.cache";
      XDG_CONFIG_HOME = "$HOME/.config";
      XDG_DATA_HOME = "$HOME/.local/share";
      XDG_BIN_HOME = "$HOME/.local/bin";
      # To prevent firefox from creating ~/Desktop.
      XDG_DESKTOP_DIR = "$HOME";
      NIXOS_OZONE_WL = "1";
    };
  };

  # Optimization settings and garbage collection automation
  nix = {
    channel.enable = false; # remove nix-channel related tools & configs, we use flakes instead.
    settings = {
      auto-optimise-store = true;
      auto-allocate-uids = true;
      use-cgroups = true;
      accept-flake-config = true;
      builders-use-substitutes = true;
      keep-derivations = true;
      keep-outputs = true;
      experimental-features = ["nix-command" "flakes" "auto-allocate-uids" "cgroups"];
      substituters = [
        "https://mirror.sjtu.edu.cn/nix-channels/store"
        "https://mirrors.ustc.edu.cn/nix-channels/store"
        "https://nix-community.cachix.org"
        "https://hyprland.cachix.org"
        "https://yazi.cachix.org"
      ];
      trusted-public-keys = [
        "yazi.cachix.org-1:Dcdz63NZKfvUCbDGngQDAZq6kOroIrFoyO064uvLh8k="
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
      trusted-users = ["root" "@wheel"];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 2d";
    };
    extraOptions = ''
      keep-outputs            = true
      keep-derivations        = true
    '';
  };

  system = {
    stateVersion = "23.11";
  };
}
