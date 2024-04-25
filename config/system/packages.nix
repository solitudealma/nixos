{
  pkgs,
  config,
  inputs,
  host,
  ...
}: let
  inherit
    (import ../../hosts/${host}/options.nix)
    browser
    ;
in {
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List System Programs
  environment = {
    binsh = "${pkgs.dash}/bin/dash";
    systemPackages = with pkgs; [
      pkgs."${browser}"
      # archives
      zip
      xz
      zstd
      unzip
      p7zip

      # Text Processing
      # Docs: https://github.com/learnbyexample/Command-line-text-processing
      gnugrep # GNU grep, provides `grep`/`egrep`/`fgrep`
      gnused # GNU sed, very powerful(mainly for replacing text in files)
      gawk # GNU awk, a pattern scanning and processing language
      jq # A lightweight and flexible command-line JSON processor

      # networking tools
      mtr # A network diagnostic tool
      iperf3
      dnsutils # `dig` + `nslookup`
      ldns # replacement of `dig`, it provide the command `drill`
      wget
      curl
      aria2 # A lightweight multi-protocol & multi-source command-line download utility
      socat # replacement of openbsd-netcat
      nmap # A utility for network discovery and security auditing
      ipcalc # it is a calculator for the IPv4/v6 addresses

      # misc
      file
      findutils
      which
      tree
      gnutar
      rsync

      lolcat
      neofetch
      htop
      btop
      libvirt
      polkit_gnome
      lm_sensors

      unrar
      libnotify
      eza
      v4l-utils
      ydotool

      cowsay
      lsd
      lshw
      pkg-config
      symbola

      toybox
      virt-viewer
      ripgrep
      appimage-run

      yad
      nh
    ];
  };

  programs = {
    steam.gamescopeSession.enable = true;
    dconf.enable = true;
    seahorse.enable = true;
    hyprland = {
      enable = true;
      xwayland.enable = true;
    };
    fuse.userAllowOther = true;
    mtr.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
    virt-manager.enable = true;
  };

  virtualisation.libvirtd.enable = true;
}
