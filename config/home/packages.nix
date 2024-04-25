{
  pkgs,
  config,
  username,
  host,
  ...
}: let
  inherit
    (import ../../hosts/${host}/options.nix)
    wallpaperDir
    wallpaperGit
    flakeDir
    ;
in {
  # Install Packages For The User
  home.packages = with pkgs; [
    libvirt
    gnome.file-roller
    transmission-gtk
    mpv
    gimp
    audacity
    pavucontrol
    tree
    ripgrep
    zoxide
    fd
    ffmpegthumbnailer
    protonup-qt

    # Import Scripts
    (import ./../scripts/emopicker9000.nix {inherit pkgs;})
    (import ./../scripts/task-waybar.nix {inherit pkgs;})
    (import ./../scripts/squirtle.nix {inherit pkgs;})
    (import ./../scripts/wallsetter.nix {
      inherit pkgs;
      inherit wallpaperDir;
      inherit username;
      inherit wallpaperGit;
    })
    (import ./../scripts/themechange.nix {
      inherit pkgs;
      inherit flakeDir;
      inherit host;
    })
    (import ./../scripts/theme-selector.nix {inherit pkgs;})
    (import ./../scripts/nvidia-offload.nix {inherit pkgs;})
    (import ./../scripts/web-search.nix {inherit pkgs;})
    (import ./../scripts/rofi-launcher.nix {inherit pkgs;})
    (import ./../scripts/screenshootin.nix {inherit pkgs;})
    (import ./../scripts/list-hypr-bindings.nix {
      inherit pkgs;
      inherit host;
    })
  ];

  programs.gh.enable = true;
}
