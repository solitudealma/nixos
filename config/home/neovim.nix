{
  config,
  pkgs,
  ...
}: let
  plugins = pkgs.vimPlugins;
  theme = config.colorScheme.palette;
in {
  # programs.nix-ld.enable = true;
  programs.neovim = {
    enable = true;
    nvimdots = {
      enable = true;
      setBuildEnv = true; # Only needed for NixOS
      withBuildTools = true; # Only needed for NixOS

      withHaskell = true; # If you want to use Haskell.
      extraHaskellPackages = hsPkgs: []; # Configure packages for Haskell (nixpkgs.haskellPackages).
      extraDependentPackages = with pkgs; []; # Properly setup the directory hierarchy (`lib`, `include`, and `pkgconfig`).
    };
  };
}
