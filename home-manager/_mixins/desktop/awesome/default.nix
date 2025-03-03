{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./picom
  ];
  home.packages = with pkgs; [
    feh
    xclip
    material-icons
    flameshot
    playerctl
    pulsemixer
    pamixer
    xdg-utils
    xclip
    sct
    imagemagick
    neofetch
    brightnessctl
    inotify-tools
    procps # uptime
    brillo
    networkmanager
    bluez-experimental
    redshift
    wezterm
  ];
  xdg.configFile."awesome".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/awesome";
}
