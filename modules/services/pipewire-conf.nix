{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.modules.services;
in {
  config = mkMerge [
    (mkIf cfg.pipewire {
      })
  ];
}
