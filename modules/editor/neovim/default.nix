{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
with lib; let
  cfg = config.modules.editor;
  username = import ../../../username.nix;
  shellAliases = {
    v = "nvim";
    vdiff = "nvim -d";
  };
in {
  config = mkMerge [
    (mkIf cfg.neovim {
      programs.neovim = {
        enable = true;
        defaultEditor = true;
        viAlias = true;
        vimAlias = true;
      };
      home-manager.users.${username} = {
        xdg.configFile.nvim = {
          source = ./nvim;
          recursive = true;
        };
      };
      programs.nushell.shellAliases = shellAliases;
    })
  ];
}
