{
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  username = import ../../username.nix;
  cfg = config.modules.terminal;
  inherit (config.modules) graphics;
in {
  imports = [
    ./options.nix
    ./nushell
    ./zellij
    ./yazi
  ];

  config = mkMerge [
    {
      users.users.${username} = {
        shell = pkgs.${cfg.defaultShell};
        packages = with pkgs; [
          neofetch
          jq
          fd
          ripgrep
          eza
          fzf
          ark
          dig
          binutils
          bottom
          inxi
          cht-sh
          openssl
        ];
      };
      programs.${cfg.defaultShell} = {
        enable = true;
      };
    }
    (mkIf (graphics.type != null) {
      users.users.${username} = {
        packages = with pkgs; [
          alacritty
        ];
      };
    })
  ];
}
