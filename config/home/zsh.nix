{
  config,
  lib,
  pkgs,
  host,
  ...
}: let
  inherit (import ../../hosts/${host}/options.nix) flakeDir theShell hostname;
in
  lib.mkIf (theShell == "zsh") {
    programs.zsh = {
      enable = true;
      syntaxHighlighting.enable = true;
      autosuggestion.enable = true;
      historySubstringSearch.enable = true;
      profileExtra = ''
        #if [ -z "$DISPLAY" ] && [ "$XDG_VNTR" = 1 ]; then
        #  exec Hyprland
        #fi
      '';
      initExtra = ''
        source ~/zaneyos/config/home/files/omz/omz.zsh

        if type nproc &>/dev/null; then
          export MAKEFLAGS="$MAKEFLAGS -j$(($(nproc)-1))"
        fi

        neofetch
        function yy() {
          local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
          yazi "$@" --cwd-file="$tmp"
          if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
            cd -- "$cwd"
          fi
          rm -f -- "$tmp"
        }
      '';
      initExtraFirst = ''
      '';
      sessionVariables = {
      };
      shellAliases = {
        flake-rebuild = "nh os switch --hostname ${hostname}";
        flake-update = "nh os switch --hostname ${hostname} --update";
        gcCleanup = "nix-collect-garbage --delete-old && sudo nix-collect-garbage -d && sudo /run/current-system/bin/switch-to-configuration boot";
        l = "eza -lh  --icons=auto"; # long list
        ls = "eza -1   --icons=auto"; # short list
        ll = "eza -lha --icons=auto --sort=name --group-directories-first"; # long list all
        ld = "eza -lhD --icons=auto"; # long list dirs
        code = "code --disable-gpu"; # gui code editor
        tmux = "tmux -u";
        scp = "~/.ssh/scp.sh";
        ssh = "~/.ssh/ssh.sh";
        neofetch = "neofetch --ascii ~/.config/ascii-neofetch";
      };
    };
  }
