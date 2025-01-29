{
  config,
  lib,
  ...
}: let
  inherit (config._custom.globals) defaultLocale extraLocale keyboardLayout;
in {
  console.keyMap = lib.mkIf (config.console.font != null) keyboardLayout;
  i18n = {
    defaultLocale = defaultLocale;
    extraLocaleSettings = {
      LC_ADDRESS = extraLocale;
      LC_IDENTIFICATION = extraLocale;
      LC_MEASUREMENT = extraLocale;
      LC_MONETARY = extraLocale;
      LC_NAME = extraLocale;
      LC_NUMERIC = extraLocale;
      LC_PAPER = extraLocale;
      LC_TELEPHONE = extraLocale;
      LC_TIME = extraLocale;
    };
  };

  services = {
    kmscon = lib.mkIf config.services.kmscon.enable {
      extraConfig = ''
        xkb-layout=${keyboardLayout}
      '';
    };
    xserver.xkb.layout = keyboardLayout;
  };
}
