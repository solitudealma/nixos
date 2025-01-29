{
  inputs,
  pkgs,
  ...
}: {
  xdg.configFile."picom" = {
    source = ../../../configs/picom;
  };
  services.picom = {
    enable = true;
    package = inputs.picom.packages.${pkgs.system}.picom;
    extraArgs = ["--experimental-backends"];
  };
}
