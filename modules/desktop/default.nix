{lib, ...}:
with lib; {
  imports = [
    ./hyprland
    ./rofi
    ./theme
    ./waybar
    ./options.nix
    ./fonts
    ./fcitx5
    ./xdg.nix
  ];
}
