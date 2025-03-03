{
  inputs,
  pkgs,
  ...
}: {
  services = {
    # thunar
    gvfs.enable = true; # Mount, trash, and other functionalities
    tumbler.enable = true; # Thumbnail support for images
    upower.enable = true;
    xserver = {
      displayManager = {
        # startx.enable = true;
        lightdm.enable = true;
      };
      enable = true;
      windowManager.dwm = {
        enable = true;
      };
    };
  };
}
