{
  config,
  desktop,
  isInstall,
  lib,
  pkgs,
  ...
}:
lib.mkIf isInstall {
  # Only enables auxilary printing support/packages if
  # config.services.printing.enable is true; the master control
  # - https://wiki.nixos.org/wiki/Printing
  programs.system-config-printer = lib.mkIf config.services.printing.enable {
    enable = lib.elem desktop [ "dwm" "river" "hyprland" "gnome" "niri" "dwl"];
  };
  services = {
    printing = {
      enable = true;
      drivers = with pkgs;
        lib.optionals config.services.printing.enable [
          nur.repos.nukdokplex.epson_201310w
          gutenprint
          hplip
        ];
      webInterface = false;
    };
    system-config-printer.enable = config.services.printing.enable;
  };
}
