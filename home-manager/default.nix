{
  config,
  hostname,
  inputs,
  isLima,
  isWorkstation,
  lib,
  pkgs,
  username,
  stateVersion,
  ...
}: let
  inherit (config._custom.globals) homeDirectory configDirectory;
  inherit (pkgs.stdenv) isDarwin isLinux;
in {
  imports =
    [
      # If you want to use modules your own flake exports (from modules/home-manager):
      # outputs.homeManagerModules.example

      # Modules exported from other flakes:
      inputs.chaotic.homeManagerModules.default
      inputs.nix-index-database.hmModules.nix-index
      # inputs.sops-nix.homeManagerModules.sops
      inputs.stylix.homeManagerModules.stylix
      ../nixos/${hostname}/variables.nix
      ./_mixins/features
      ./_mixins/scripts
      ./_mixins/services
      ./_mixins/users
    ]
    ++ lib.optional isWorkstation ./_mixins/desktop;

  _custom.globals._git = {
    userName = username;
    email = "2241141629yt@gmail.com";
  };

  home = {
    inherit username homeDirectory stateVersion;
    file = {
      "${config.xdg.configHome}/btop".source = config.lib.file.mkOutOfStoreSymlink "${configDirectory}/home-manager/_mixins/configs/btop";
      "${config.xdg.configHome}/cava".source = config.lib.file.mkOutOfStoreSymlink "${configDirectory}/home-manager/_mixins/configs/cava";
      "${config.xdg.configHome}/tmux".source = config.lib.file.mkOutOfStoreSymlink "${configDirectory}/home-manager/_mixins/configs/tmux";
    };
    packages = with pkgs;
      [
        asciicam # Terminal webcam
        bc # Terminal calculator
        bandwhich # Modern Unix `iftop`
        bmon # Modern Unix `iftop`
        breezy # Terminal bzr client
        chafa # Terminal image viewer
        cpufetch # Terminal CPU info
        croc # Terminal file transfer
        curlie # Terminal HTTP client
        cyme # Modern Unix `lsusb`
        dconf2nix # Nix code from Dconf files
        difftastic # Modern Unix `diff`
        dogdns # Modern Unix `dig`
        dotacat # Modern Unix lolcat
        dua # Modern Unix `du`
        duf # Modern Unix `df`
        du-dust # Modern Unix `du`
        entr # Modern Unix `watch`
        fastfetch # Modern Unix system info
        fd # Modern Unix `find`
        file # Terminal file info
        girouette # Modern Unix weather
        gocryptfs # Terminal encrypted filesystem
        gping # Modern Unix `ping`
        git-igitt # Modern Unix git log/graph
        h # Modern Unix autojump for git projects
        hexyl # Modern Unix `hexedit`
        hr # Terminal horizontal rule
        httpie # Terminal HTTP client
        hueadm # Terminal Philips Hue client
        hyperfine # Terminal benchmarking
        iperf3 # Terminal network benchmarking
        ipfetch # Terminal IP info
        jpegoptim # Terminal JPEG optimizer
        jiq # Modern Unix `jq`
        lastpass-cli # Terminal LastPass client
        lima-bin # Terminal VM manager
        marp-cli # Terminal Markdown presenter
        mtr # Modern Unix `traceroute`
        netdiscover # Modern Unix `arp`
        nixfmt-rfc-style # Nix code formatter
        nixpkgs-review # Nix code review
        nix-prefetch-scripts # Nix code fetcher
        nix-tree
        nurl # Nix URL fetcher
        onefetch # Terminal git project info
        optipng # Terminal PNG optimizer
        procs # Modern Unix `ps`
        quilt # Terminal patch manager
        rclone # Modern Unix `rsync`
        rsync # Traditional `rsync`
        rustmission # Modern Unix Transmission client
        sd # Modern Unix `sed`
        shellcheck
        speedtest-go # Terminal speedtest.net
        timer # Terminal timer
        tldr # Modern Unix `man`
        tokei # Modern Unix `wc` for code
        ueberzugpp # Terminal image viewer integration
        unzip # Terminal ZIP extractor
        upterm # Terminal sharing
        vhs
        wget # Terminal HTTP client
        wget2 # Terminal HTTP client
        wormhole-william # Terminal file transfer
        yq-go # Terminal `jq` for YAML
      ]
      ++ lib.optionals isLinux [
        figlet # Terminal ASCII banners
        iw # Terminal WiFi info
        lurk # Modern Unix `strace`
        pciutils # Terminal PCI info
        psmisc # Traditional `ps`
        ramfetch # Terminal system info
        s-tui # Terminal CPU stress test
        stress-ng # Terminal CPU stress test
        usbutils # Terminal USB info
        wavemon # Terminal WiFi monitor
        writedisk # Modern Unix `dd`
        zsync # Terminal file sync; FTBFS on aarch64-darwin
      ]
      ++ lib.optionals isDarwin [
        m-cli # Terminal Swiss Army Knife for macOS
        nh
        coreutils
      ]
      ++ lib.optionals isWorkstation [
        # nur.repos.xyenon.anime4k
        BaiduPCS-Go
        calcurse # Calendar and scheduling application for the command line
        # desmume # NS emulator
        # drawio # Desktop application for creating diagrams
        # inputs.fastanime.packages.${pkgs.system}.default
        # fluent-reader # Rss reader
        # nur.repos.guoard.hiddify # proxy client
        # nur.repos.nagy.hackernews-tui
        # nur.repos.j4ger.lceda-pro # A high-efficiency PCB design suite
        # jpegoptim # Optimize JPEG files
        # kazumi
        # nur.repos.xddxdd.kikoplay
        # nur.repos.colinsane.koreader-from-src
        # maa-debugger
        # maaframework
        # nur.repos.nagy.nsxivBigThumbs # image viewer
        # pcsx2 # ps2 emulator
        # retroarch
        # rpcs3 # ps3 emulator
        # ryujinx # NS emulator
        # torzu_git # NS emulator
        # tigervnc # Vnc client
        nur.repos.linyinfeng.wemeet # wemeet
        wpsoffice
        # nur.repos.iopq.xraya
      ];

    sessionVariables = {
      EDITOR = "nvim";
      MANPAGER = "sh -c 'col --no-backspaces --spaces | bat --language man'";
      MANROFFOPT = "-c";
      PAGER = "bat";
      SYSTEMD_EDITOR = "nvim";
      VISUAL = "nvim";
      XCURSOR_PATH = "$(echo $XDG_DATA_DIRS | sed -E 's,(:|$),/icons&,g')";
      XCURSOR_THEME = "Bibata-Modern-Ice";
      XCURSOR_SIZE = 20;
    };
  };

  fonts.fontconfig.enable = true;

  # Workaround home-manager bug with flakes
  # - https://github.com/nix-community/home-manager/issues/2033
  news.display = "silent";

  programs = {
    btop = {
      enable = true;
      package = pkgs.btop.override {
        cudaSupport = true;
        rocmSupport = true;
      };
    };
    cava = {
      enable = isLinux;
    };
    gh = {
      enable = true;
      extensions = with pkgs; [
        gh-dash
        gh-markdown-preview
      ];
      settings = {
        editor = "nvim";
        git_protocol = "ssh";
        prompt = "enabled";
      };
    };
    git = {
      enable = true;
      difftastic = {
        display = "side-by-side-show-both";
        enable = true;
      };
      extraConfig = {
        advice = {
          statusHints = false;
        };
        color = {
          branch = false;
          diff = false;
          interactive = true;
          log = false;
          status = true;
          ui = false;
        };
        core = {
          pager = "bat";
        };
        push = {
          default = "matching";
        };
        pull = {
          rebase = false;
        };
        init = {
          defaultBranch = "master";
        };
      };
      ignores = [
        "*.log"
        "*.out"
        ".DS_Store"
        "bin/"
        "dist/"
        "result"
      ];
    };
    gpg.enable = true;
    home-manager.enable = true;
    info.enable = true;
    jq.enable = true;
    nix-index.enable = true;
    tmate.enable = true;
    yt-dlp = {
      enable = true;
      settings = {
        add-metadata = true;
        audio-multistreams = true;
        audio-format = "aac>m4a/flac/m4a";
        concurrent-fragments = 8;
        continue = true;
        embed-metadata = true;
        embed-thumbnai = true;
        force-ipv4 = true;
        format = "bv[ext=mp4][height<=?1080]+ba[ext=m4a]/best[ext=mp4]/bv*+ba/b";
        ignore-errors = true;
        output = "~/Videos/yt-dlp/%(title)s.%(ext)s";
        part = true;
        retries = 10;
        throttled-rate = "200k";
        video-multistreams = true;
        remux-video = "aac>m4a/mov>mp4/mkv";
        write-subs = true;
        write-thumbnail = true;
      };
    };
  };

  services = {
    gpg-agent = lib.mkIf isLinux {
      enable = isLinux;
      enableSshSupport = true;
      pinentryPackage = pkgs.pinentry-curses;
    };
    pueue = {
      enable = isLinux;
      # https://github.com/Nukesor/pueue/wiki/Configuration
      settings = {
        daemon = {
          default_parallel_tasks = 1;
          callback = "${pkgs.notify-desktop}/bin/notify-desktop \"Task {{ id }}\nCommand: {{ command }}\nPath: {{ path }}\nFinished with status '{{ result }}'\nTook: $(bc <<< \"{{end}} - {{start}}\") seconds\" --app-name=pueue";
        };
      };
    };
  };

  # sops = {
  #   age = {
  #     keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
  #     generateKey = false;
  #   };
  #   defaultSopsFile = ../secrets/secrets.yaml;
  #   # sops-nix options: https://dl.thalheim.io/
  #   secrets = {
  #     atuin_key.path = "${config.home.homeDirectory}/.local/share/atuin/key";
  #     gh_token = {};
  #     gpg_private = {};
  #     gpg_public = {};
  #     gpg_ownertrust = {};
  #     obs_secrets = {};
  #     ssh_config.path = "${config.home.homeDirectory}/.ssh/config";
  #     ssh_key.path = "${config.home.homeDirectory}/.ssh/id_ed25519";
  #     ssh_pub.path = "${config.home.homeDirectory}/.ssh/id_ed25519.pub";
  #   };
  # };

  # Nicely reload system units when changing configs
  systemd.user.startServices = lib.mkIf isLinux "sd-switch";
  # Create age keys directory for SOPS
  systemd.user.tmpfiles = lib.mkIf isLinux {
    rules = [
      "d ${config.home.homeDirectory}/.config/sops/age 0755 ${username} users - -"
    ];
  };

  xdg = {
    enable = isLinux;
    userDirs = {
      # Do not create XDG directories for LIMA; it is confusing
      enable = isLinux && !isLima;
      createDirectories = true;
      extraConfig = {
        XDG_SCREENSHOTS_DIR = "${config.home.homeDirectory}/Pictures/Screenshots";
      };
    };
  };
}
