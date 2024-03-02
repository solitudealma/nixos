{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  inherit (config.modules) graphics;
  cfg = config.modules.desktop;
  username = import ../../../username.nix;
in {
  config = mkIf (cfg.inputMethod == "fcitx5" && (graphics.type != null)) {
    home-manager.users.${username} = {...}: {
      xdg.configFile = {
        "fcitx5/profile" = {
          recursive = true;
          source = ./fcitx5/profile;
          # every time fcitx5 switch input method, it will modify ~/.config/fcitx5/profile,
          # so we need to force replace it in every rebuild to avoid file conflict.
          force = true;
        };
      };
      i18n.inputMethod = {
        enabled = "fcitx5";
        fcitx5.addons = with pkgs; [
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
}
