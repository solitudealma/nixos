{
  config,
  pkgs,
  inputs,
  username,
  host,
  gtkThemeFromScheme,
  ...
}: let
  inherit
    (import ./../../hosts/${host}/options.nix)
    gitUsername
    gitEmail
    theme
    browser
    wallpaperDir
    wallpaperGit
    flakeDir
    waybarStyle
    ;
in {
  # Home Manager Settings
  home.username = "${username}";
  home.homeDirectory = "/home/${username}";
  home.stateVersion = "23.11";

  # Set The Colorscheme
  colorScheme = inputs.nix-colors.colorSchemes."${theme}";

  # Import Program Configurations
  imports = [
    inputs.nur.nixosModules.nur
    inputs.nix-colors.homeManagerModules.default
    inputs.nvimdots.nixosModules.nvimdots
    inputs.hyprland.homeManagerModules.default
    ./../../config/home
  ];

  # Define Settings For Xresources
  xresources.properties = {
    "Xcursor.size" = 24;
  };

  # Install & Configure Git
  programs.git = {
    enable = true;
    userName = "${gitUsername}";
    userEmail = "${gitEmail}";
  };

  # Create XDG Dirs
  xdg = {
    userDirs = {
      enable = true;
      createDirectories = true;
      extraConfig = {
        XDG_SCREENSHOTS_DIR = "/home/${username}/Pictures/Screenshots";
      };
    };
  };

  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = ["qemu:///system"];
      uris = ["qemu:///system"];
    };
  };

  programs.home-manager.enable = true;
}
