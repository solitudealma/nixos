{
  inputs,
  pkgs,
  ...
}: {
  services = {
    # thunar
    gvfs.enable = true; # Mount, trash, and other functionalities
    tumbler.enable = true; # Thumbnail support for images
    xserver = {
      displayManager = {
        # startx.enable = true;
        lightdm.enable = true;
      };
      enable = true;
      windowManager.dwm = {
        enable = true;
        package = inputs.dwm.packages.${pkgs.system}.dwm;
      };
    };
  };
}
