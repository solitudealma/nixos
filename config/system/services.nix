{
  pkgs,
  config,
  lib,
  userHome,
  username,
  ...
}: {
  # List services that you want to enable:
  services = {
    openssh = {
      enable = true;
      settings = {
        X11Forwarding = true;
        # root user is used for remote deployment, so we need to allow it
        PermitRootLogin = "prohibit-password";
        PasswordAuthentication = false; # disable password login
      };
      openFirewall = true;
    };
    fstrim.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true; 
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
      wireplumber.enable = true;
      extraConfig.pipewire-pulse."92-low-latency" = {
        context.modules = [
          {
            name = "libpipewire-module-protocol-pulse";
            args = {
              pulse.min.req = "32/48000";
              pulse.default.req = "32/48000";
              pulse.max.req = "32/48000";
              pulse.min.quantum = "32/48000";
              pulse.max.quantum = "32/48000";
            };
          }
        ];
        stream.properties = {
          node.latency = "32/48000";
          resample.quality = 1;
        };
      };
    };
    gvfs.enable = true;
    tumbler.enable = true;
    gnome.gnome-keyring.enable = true;
    blueman.enable = true;
    dbus.enable = true;
  };
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    config = {
      common = {
        # Use xdg-desktop-portal-gtk for every portal interface...
        default = [
          "*"
        ];
        # except for the secret portal, which is handled by gnome-keyring
        "org.freedesktop.impl.portal.Secret" = [
          "gnome-keyring"
        ];
      };
    };
    # Sets environment variable NIXOS_XDG_OPEN_USE_PORTAL to 1
    # This will make xdg-open use the portal to open programs,
    # which resolves bugs involving programs opening inside FHS envs or with unexpected env vars set from wrappers.
    # xdg-open is used by almost all programs to open a unknown file/uri
    # alacritty as an example, it use xdg-open as default, but you can also custom this behavior
    # and vscode has open like `External Uri Openers`
    xdgOpenUsePortal = false;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      # xdg-desktop-portal
      pkgs.xdg-desktop-portal-wlr
    ];
    configPackages = [
    pkgs.gnome.gnome-session
    #   xdg-desktop-portal-gtk
    #   xdg-desktop-portal-hyprland
    #   xdg-desktop-portal
    #   xdg-desktop-portal-wlr
    ];
  };
  # Disable pulseaudio, it conflicts with pipewire too.
  hardware = {
    pulseaudio.enable = false;
    bluetooth = {
      enable = true; # enables support for Bluetooth
      powerOnBoot = true; # powers up the default Bluetooth controller on boot
    };
  };
  # Remove sound.enable or turn it off if you had it set previously, it seems to cause conflicts with pipewire
  sound.enable = false;
  programs.thunar.enable = true;
  security = {
    sudo = {
    enable = true;
    extraConfig = ''
      ${username} ALL=(ALL) NOPASSWD:ALL
    '';
  };
    rtkit.enable = true;
    pam.services.swaylock = {
    text = ''
      auth include login 
    '';
  };
  };
}
