{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    inputs.spicetify-nix.homeManagerModules.default
  ];
  programs.spicetify = let
    spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};
  in {
    colorScheme = "Everforest";
    enable = true;
    enabledCustomApps =
      []
      ++ (with spicePkgs.apps; [
        lyricsPlus
      ]);
    enabledExtensions =
      [
      ]
      ++ (with spicePkgs.extensions; [
        {
          name = "bfs-bundle.js";
          src =
            pkgs.fetchFromGitHub {
              owner = "Oein";
              repo = "beautifulfullscreen";
              rev = "c7aa28d67f09b9378122c4354366fa4812c189ee";
              hash = "sha256-vXV1DQA67m5Ot0SjGPK73N6VqaHpATS67LaHV5Ick/4=";
            }
            + "/marketplace";
        }
        adblockify
      ]);
    theme = spicePkgs.themes.comfy;
  };
}
