{
  config,
  hostname,
  inputs,
  isLima,
  isWorkstation,
  lib,
  outputs,
  pkgs,
  username,
  stateVersion,
  ...
}: let
  inherit (config._custom.globals) homeDirectory;
  inherit (pkgs.stdenv) isDarwin isLinux;
in {
  imports =
    [
      # If you want to use modules your own flake exports (from modules/home-manager):
      # outputs.homeManagerModules.example

      # Modules exported from other flakes:
      inputs.chaotic.homeManagerModules.default
      inputs.nix-index-database.hmModules.nix-index
      inputs.sops-nix.homeManagerModules.sops
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
      "${config.xdg.configHome}/btop" = {
        source = ./_mixins/configs/btop;
        recursive = true;
      };
      "${config.xdg.configHome}/cava" = {
        source = ./_mixins/configs/cava;
        recursive = true;
      };
      "${config.xdg.configHome}/tmux" = {
        source = ./_mixins/configs/tmux;
        recursive = true;
      };
    };
    packages = with pkgs;
      [
        asciicam # Terminal webcam
        asciinema-agg # Convert asciinema to .gif
        bc # Terminal calculator
        bandwhich # Modern Unix `iftop`
        bmon # Modern Unix `iftop`
        breezy # Terminal bzr client
        chafa # Terminal image viewer
        clinfo # Terminal OpenCL info
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
        editorconfig-core-c # EditorConfig Core
        entr # Modern Unix `watch`
        fastfetch # Modern Unix system info
        fd # Modern Unix `find`
        file # Terminal file info
        glow # Terminal Markdown renderer
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
        neo-cowsay # Terminal ASCII cows
        netdiscover # Modern Unix `arp`
        nixfmt-rfc-style # Nix code formatter
        nixpkgs-review # Nix code review
        nix-prefetch-scripts # Nix code fetcher
        nurl # Nix URL fetcher
        nyancat # Terminal rainbow spewing feline
        onefetch # Terminal git project info
        optipng # Terminal PNG optimizer
        procs # Modern Unix `ps`
        quilt # Terminal patch manager
        rclone # Modern Unix `rsync`
        rsync # Traditional `rsync`
        sd # Modern Unix `sed`
        shellcheck
        speedtest-go # Terminal speedtest.net
        terminal-parrot # Terminal ASCII parrot
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
        nix-alien # Run unpatched binaries on Nix/NixOS
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
        nur.repos.xyenon.anime4k
        BaiduPCS-Go
        calcurse # Calendar and scheduling application for the command line
        desmume # NS emulator
        drawio # Desktop application for creating diagrams
        inputs.fastanime.packages.${pkgs.system}.default
        fluent-reader # Rss reader
        # nur.repos.guoard.hiddify # proxy client
        # nur.repos.nagy.hackernews-tui
        # nur.repos.j4ger.lceda-pro # A high-efficiency PCB design suite
        jpegoptim # Optimize JPEG files
        kazumi
        nur.repos.xddxdd.kikoplay
        # nur.repos.colinsane.koreader-from-src
        localsend # Open source cross-platform alternative to AirDrop
        lxterminal # The standard terminal emulator of LXDE
        # maa-debugger
        maaframework
        # nur.repos.nagy.nsxivBigThumbs # image viewer
        pcsx2 # ps2 emulator
        rpcs3 # ps3 emulator
        ryujinx # NS emulator
        # torzu_git # NS emulator
        nur.repos.ocfox.showmethekey # Screencast tool to display your keys inspired by Screenflick
        tigervnc # Vnc client
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

  nix = {
    package = pkgs.nixVersions.latest;
    settings = {
      experimental-features = "flakes nix-command";
      trusted-users = [
        "root"
        "${username}"
      ];
    };
  };

  nixpkgs = {
    config = {
      allowUnfree = true;
      permittedInsecurePackages = [
        "electron-30.5.1"
        "dotnet-sdk-6.0.428"
      ];
    };
    overlays = [
      # Add overlays exported from other flakes:
      inputs.nix-alien.overlays.default
      inputs.niri.overlays.niri
      inputs.nur.overlays.default
      inputs.nur-xddxdd.overlays.inSubTree-pinnedNixpkgs

      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages
    ];
  };

  programs = {
    atuin = {
      enable = true;
      enableZshIntegration = true;
      flags = ["--disable-up-arrow"];
      package = pkgs.atuin;
      settings = {
        auto_sync = true;
        dialect = "us";
        #key_path = config.sops.secrets.atuin_key.path;
        show_preview = true;
        style = "compact";
        sync_frequency = "1h";
        sync_address = "https://api.atuin.sh";
        update_check = false;
      };
    };
    bat = {
      enable = true;
      extraPackages = with pkgs.bat-extras; [
        batgrep
        batpipe
        batwatch
        prettybat
      ];
      config = {
        pager = "less -FR";
        style = "plain";
        theme = "gruvbox-dark";
      };
    };
    btop = {
      enable = true;
    };
    cava = {
      enable = isLinux;
    };
    dircolors = {
      enable = true;
      enableZshIntegration = true;
    };
    direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv = {
        enable = true;
      };
    };
    eza = {
      enable = true;
      enableZshIntegration = true;
      extraOptions = [
        "--group-directories-first"
        "--header"
      ];
      git = true;
      icons = "auto";
    };
    fzf = {
      changeDirWidgetCommand = "fd --type=d --hidden --strip-cwd-prefix --exclude .git";
      changeDirWidgetOptions = ["--preview 'eza --tree --color=always {} | head -200'"];
      defaultCommand = "fd --hidden --strip-cwd-prefix --exclude .git";
      ## Theme
      defaultOptions = [
        "--color=fg:-1,fg+:#FBF1C7,bg:-1,bg+:#282828"
        "--color=hl:#98971A,hl+:#B8BB26,info:#928374,marker:#D65D0E"
        "--color=prompt:#CC241D,spinner:#689D6A,pointer:#D65D0E,header:#458588"
        "--color=border:#665C54,label:#aeaeae,query:#FBF1C7"
        "--border='rounded' --border-label='' --preview-window='border-rounded' --prompt='> '"
        "--marker='>' --pointer='>' --separator='─' --scrollbar='│'"
        "--info='right'"
      ];
      enable = true;
      enableZshIntegration = true;
      fileWidgetOptions = ["--preview 'if [ -d {} ]; then eza --tree --color=always {} | head -200; else bat -n --color=always --line-range :500 {}; fi'"];
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
    ripgrep = {
      arguments = [
        "--colors=line:style:bold"
        "--max-columns-preview"
        "--smart-case"
      ];
      enable = true;
    };
    tmate.enable = true;
    yt-dlp = {
      enable = true;
      package = pkgs.yt-dlp_git;
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
    zoxide = {
      enable = true;
      enableBashIntegration = true;

      enableZshIntegration = true;
      # Replace cd with z and add cdi to access zi
      options = ["--cmd cd"];
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

  sops = {
    age = {
      keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
      generateKey = false;
    };
    defaultSopsFile = ../secrets/secrets.yaml;
    # sops-nix options: https://dl.thalheim.io/
    secrets = {
      atuin_key.path = "${config.home.homeDirectory}/.local/share/atuin/key";
      gh_token = {};
      gpg_private = {};
      gpg_public = {};
      gpg_ownertrust = {};
      obs_secrets = {};
      ssh_config.path = "${config.home.homeDirectory}/.ssh/config";
      ssh_key.path = "${config.home.homeDirectory}/.ssh/id_ed25519";
      ssh_pub.path = "${config.home.homeDirectory}/.ssh/id_ed25519.pub";
    };
  };

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
