{
  config,
  lib,
  inputs,
  pkgs,
  ...
}:
with lib; let
  username = import ../../username.nix;
  cfg = config.modules.dev.devops;
in {
  config = mkMerge [
    (mkIf (builtins.elem "kubernetes-lite" cfg.tools) {
      environment.systemPackages = with pkgs; [
        kubectl
        argocd
      ];
    })
    (mkIf (builtins.elem "kubernetes" cfg.tools) {
      environment.systemPackages = with pkgs; [
        kubectl
        kubectl-view-secret
        stern
        kubectx
        kubernetes-helm
        kustomize
        openlens
        argocd
      ];
    })
    (mkIf (builtins.elem "direnv" cfg.tools) {
      environment.systemPackages = with pkgs; [
        direnv
      ];
    })
  ];
}
