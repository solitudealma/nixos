{pkgs, ...}: {
  imports = [
  
  ];
  home = {
    packages = with pkgs; [
      xdg-desktop-portal-wlr 
      brightnessctl 
      playerctl 
      polkit_gnome 
      foot 
      dunst
      waybar 
      swayidle 
      blueman 
      lswt 
      wlr-randr 
      swaylock-effects 
      wlprop
      wf-recorder
    ];
  };

  wayland.windowManager.river = {
    enable = true;
    package = pkgs.river_git;
    xwayland.enable = true;
  };

   xdg.configFile."river" = {
    executable = true;
    recursive = true;
    source = ../../configs/river;
  };
}
