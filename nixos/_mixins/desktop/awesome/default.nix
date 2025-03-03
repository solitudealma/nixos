{pkgs, ...}: {
  services = {
    # thunar
    gvfs.enable = true; # Mount, trash, and other functionalities
    tumbler.enable = true; # Thumbnail support for images

    displayManager.defaultSession = "none+awesome";
    xserver = {
      displayManager = {
        defaultSession = "none+awesome";
        startx.enable = true;
      };
      enable = true;
      windowManager.awesome = {
        enable = true;
        luaModules = with pkgs.lua53Packages; [
          lgi
          ldbus
          luaposix
          luarocks # is the package manager for Lua modules
          luadbi-mysql # Database abstraction layer
          dkjson
        ];
      };
    };
  };
}
