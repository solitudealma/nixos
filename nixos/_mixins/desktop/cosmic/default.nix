{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    inputs.nixos-cosmic.nixosModules.default
    ../niri
    ./start-cosmic-ext.nix
  ];
  environment = {
    # variables.NIXOS_OZONE_WL = "1";
    cosmic.excludePackages = with pkgs; [
      # adwaita-icon-theme
      # cosmic-edit
      # cosmic-files
      # cosmic-launcher
      # cosmic-term
      # hicolor-icon-theme
      # pop-icon-theme
      # pop-launcher

      # cosmic-bg
      # cosmic-store
      # cosmic-applets
      # cosmic-wallpapers
      # cosmic-screenshot
      # xdg-desktop-portal-cosmic
    ];
    sessionVariables = {
      COSMIC_DATA_CONTROL_ENABLED = 1;
    };
  };
  services = {
    desktopManager = {
      cosmic = {
        enable = true;
      };
    };
    displayManager = {
      cosmic-greeter.enable = true;
    };
  };
}
