{pkgs, ...}: {
  environment.variables = {
    QT_QPA_PLATFORM = "wayland";
  };
  programs = {
    niri = {
      enable = true;
      package = pkgs.niri-unstable;
    };
    xwayland = {
      enable = true;
      package = pkgs.xwayland-satellite;
    };
  };
  security = {
    pam.services = {
      greetd.enableGnomeKeyring = true;
      hyprlock = {};
    };
    polkit = {
      enable = true;
    };
  };

  services = {
    xserver = {
      enable = true;
      displayManager.gdm = {
        enable = true;
        wayland = true;
      };
    };
    # thunar
    gvfs.enable = true; # Mount, trash, and other functionalities
    tumbler.enable = true; # Thumbnail support for images
  };
}
