{
  pkgs,
  # pkgs-unstable,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.modules.social;
  username = import ../../username.nix;
  inherit (config.modules) graphics;
in {
  imports = [
    ./options.nix
  ];
  config = mkMerge [
    (mkIf (cfg.discord && (graphics.type != null)) {
      users.users.${username} = {
        packages = with pkgs; [
          (discord.override {
            withOpenASAR = true;
            withVencord = true;
          })
          vesktop
        ];
      };
    })
    (mkIf (cfg.qq && (graphics.type != null)) {
      users.users.${username} = {
        packages = with pkgs; [
          # pkgs-unstable.qq # https://github.com/NixOS/nixpkgs/tree/master/pkgs/applications/networking/instant-messengers/qq
          qq
        ];
      };
    })
    (mkIf (cfg.telegram && (graphics.type != null)) {
      users.users.${username} = {
        packages = with pkgs; [
          telegram-desktop
        ];
      };
    })
  ];
}
