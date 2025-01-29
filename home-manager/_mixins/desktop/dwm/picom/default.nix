{...}: {
  xdg.configFile."picom" = {
    source = ../../../configs/picom;
  };
  # services.picom = {
  #   enable = true;
  #   package = pkgs.picom;
  #   extraArgs = ["--experimental-backends"];
  #   settings = {
  #   };
  # };
}
