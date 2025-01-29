{lib,pkgs, ...}: {
   programs.river = {
    enable = true;
    extraPackages = with pkgs; [
      swaylock-effects # lockscreen
      pavucontrol
      swayidle
      xwayland
	
      brightnessctl 
      playerctl 
      polkit_gnome 
      foot 
  
      waybar 

      blueman 
      lswt 
      wlr-randr 
      
      wlprop
      wf-recorder
      rofi-wayland
      rofi-rbw
      eog
      libnotify
      dunst # notification daemon
      kanshi # auto-configure display outputs
      wdisplays
      wl-clipboard
			cliphist
			wl-clip-persist
			wezterm
			grim
			slurp
			swappy
			satty
			swww
      blueberry
      sway-contrib.grimshot # screenshots
      wtype

      pavucontrol
      evince
      libnotify
      pamixer
      networkmanagerapplet
      file-roller
      nautilus

      # Somehow xdg.portal services do not really work for me.
      # Instead I re-start xdg-desktop-portal and xdg-desktop-portal wlr from sway itself
      xdg-desktop-portal
      xdg-desktop-portal-wlr
    ];
  };
  services.greetd = {
	enable = true;
		settings = {
			default_session = {
				command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd river";
				user = "solitudealma";
			};
		};
	};
  # thunar
  services.gvfs.enable = true; # Mount, trash, and other functionalities
  services.tumbler.enable = true; # Thumbnail support for images
}
