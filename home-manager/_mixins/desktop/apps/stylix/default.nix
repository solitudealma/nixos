{pkgs, ...}: let
  colorScheme = ./themes/gruvbox/gruvbox.yaml;
in {
  stylix.image = pkgs.fetchurl {
    url = "https://browsecat.art/sites/default/files/minimal-solar-system-wallpapers-52665-196251-5747315.png";
    sha256 = "1picl90amxs3vlpkj1ricjaf2yhgd09lny3jhxv5mf6q5pi2q56i";
  };
  stylix = {
    autoEnable = false;
    base16Scheme = colorScheme;
  };
}
