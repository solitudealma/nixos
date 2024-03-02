{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.modules.terminal;
  username = import ../../../username.nix;
  shellAliases = {
    "zj" = "zellij";
  };
in {
  config = mkIf cfg.zellij {
    home-manager.users.${username} = {...}: {
      programs.zellij = {
        enable = true;
      };
      # auto start zellij in nushell
      # programs.zsh.oh-my-zsh.extraConfig = ''
      #   # auto start zellij
      #   # except when in emacs or zellij itself
      #   if (not "ZELLIJ" in $env) and (not "INSIDE_EMACS" in $env) {
      #     if "ZELLIJ_AUTO_ATTACH" in $env and $env.ZELLIJ_AUTO_ATTACH == "true" {
      #       ^zellij attach -c
      #     } else {
      #       ^zellij
      #     }

      #     # Auto exit the shell session when zellij exit
      #     $env.ZELLIJ_AUTO_EXIT = "false" # disable auto exit
      #     if "ZELLIJ_AUTO_EXIT" in $env and $env.ZELLIJ_AUTO_EXIT == "true" {
      #       exit
      #     }
      #   }
      # '';

      # only works in nushell
      programs.nushell.shellAliases = shellAliases;

      xdg.configFile."zellij/config.kdl".source = ./config.kdl;
    };
  };
}
