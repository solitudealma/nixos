{
  config,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    # waydroid-helper
    nur.repos.ataraxiasjel.waydroid-script
  ];
  systemd.services.waydroid-container = {
    restartIfChanged = false;
    restartTriggers = [
      config.environment.etc."gbinder.d/waydroid.conf".source
    ];
  };
  virtualisation.waydroid.enable = true;
}
