{
  pkgs,
  config,
  ...
}: {
  # Place Files Inside Home Directory
  home.file = {
    ".local/share/fcitx5/themes/summer" = {
      source = ./files/fcitx5-theme;
    };
    ".emoji".source = ./files/emoji;
    ".base16-themes".source = ./files/base16-themes;
    ".face".source = ./files/face.jpg; # For GDM
    ".face.icon".source = ./files/face.jpg; # For SDDM
    ".config/rofi/rofi.jpg".source = ./files/rofi.jpg;
    ".config/swaylock-bg.jpg".source = ./files/media/swaylock-bg.jpg;
    ".config/ascii-neofetch".source = ./files/ascii-neofetch;
    ".config/wlogout/icons" = {
      source = ./files/wlogout;
      recursive = true;
    };
    ".config/obs-studio" = {
      source = ./files/obs-studio;
      recursive = true;
    };
  };
}
