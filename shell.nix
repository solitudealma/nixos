# Shell for bootstrapping flake-enabled nix and home-manager
# Enter it through 'nix develop' or (legacy) 'nix-shell'
{pkgs ? (import ./nixpkgs.nix) {}}: {
  default = pkgs.mkShell {
    # Enable experimental features without having to specify the argument
    NIX_CONFIG = "experimental-features = nix-command flakes";
    buildInputs = with pkgs; [
      xorg.libX11
      xorg.libXft
      xorg.libXinerama
      gcc
    ];
    nativeBuildInputs = with pkgs; [
      git
      home-manager
      nix
      nix-direnv
    ];

    packages = with pkgs; [
      python311
      python311Packages.pip
      python311Packages.pylint-venv
    ];
  };
}
