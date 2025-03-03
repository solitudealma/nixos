{
  desktop,
  isInstall,
  lib,
  pkgs,
  ...
}: {
  imports =
    [
      ./apps
      ./features
    ]
    ++ lib.optional (builtins.pathExists (./. + "/${desktop}")) ./${desktop};

  boot = {
    consoleLogLevel = 0;
    initrd.verbose = false;
    kernelParams = [
      "quiet"
      "loglevel=3"
      "vt.global_cursor_default=0"
      "mitigations=off"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
    ];
  };

  environment.etc = {
    "backgrounds/4.png".source = ../configs/backgrounds/4.png;
  };

  environment.systemPackages = with pkgs;
    lib.optionals isInstall [
      notify-desktop # Little application that lets you send desktop notifications with one command
      wmctrl # CLI tool to interact with EWMH/NetWM compatible X Window Managers.
      xdotool
      ydotool
    ];

  programs = {
    dconf.enable = true;
    wshowkeys.enable = !(lib.elem desktop ["dwm" "awesome"]);
  };
  services = {
    dbus.enable = true;
    usbmuxd.enable = true;
    xserver = {
      # Disable xterm
      desktopManager.xterm.enable = false;
      excludePackages = [pkgs.xterm];
    };
  };
}
