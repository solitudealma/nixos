{
  pkgs,
  config,
  ...
}: {
  imports = [
    # Enable &/ Configure Programs
    ./alacritty.nix
    ./bash.nix
    ./dev.nix
    ./firefox.nix
    ./fcitx5.nix
    ./gtk-qt.nix
    ./hyprland.nix
    ./kdenlive.nix
    ./kitty.nix
    ./mpd.nix
    ./mpv.nix
    ./neofetch.nix
    ./neovim.nix
    ./ncmpcpp.nix
    ./obs.nix
    ./packages.nix
    ./rofi.nix
    ./swappy.nix
    ./swaylock.nix
    ./swaync.nix
    ./vscode.nix
    ./waybar.nix
    ./wezterm.nix
    ./wlogout.nix
    ./xdg.nix
    ./yazi.nix
    ./zeroad.nix
    ./zsh.nix

    # Place Home Files Like Pictures
    ./files.nix
  ];
}
