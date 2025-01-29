{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./picom
  ];
  home.packages = with pkgs; [
    xclip
    material-icons
    flameshot
    playerctl
    pamixer
    imagemagick
    ncmpcpp
    mpd
    mpdris2
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
  xdg.configFile."awesome".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/awesomewm";
}
