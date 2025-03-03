{pkgs, ...}: {
  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    plasma-browser-integration
    konsole
    elisa
  ];
  services = {
    desktopManager.plasma6.enable = true;
    displayManager = {
      # defaultSession = "plasma";
      sddm = {
        enable = true;
        # settings.General.DisplayServer = "wayland";
        wayland.enable = true;
      };
    };
    # xserver.enable = true; # optional
  };
}
