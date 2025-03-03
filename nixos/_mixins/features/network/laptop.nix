{
  config,
  lib,
  ...
}: {
  networking.networkmanager = lib.mkIf config.networking.networkmanager.enable {
    # Disable WiFi power saving
    wifi.powersave = true;
  };
}
