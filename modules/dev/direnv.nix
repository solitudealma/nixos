{...}: {
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;

    enableFishIntegration = true;
    enableBashIntegration = true;
    enableNushellIntegration = true;
  };
}
