{pkgs, ...}: {
  services.swayidle = {
    enable = true;
    events = [
      {
        event = "after-resume";
        command = "hyprctl dispatch dpms on";
      }
      {
        event = "before-sleep";
        command = "${pkgs.swaylock}/bin/swaylock";
      }
      {
        event = "lock";
        command = "${pkgs.swaylock}/bin/swaylock";
      }
      # 有问题
      # {
      #   event = "unlock";
      #   command = "${pkgs.procps}/bin/pkill -SIGUSR1 ${pkgs.swaylock}/bin/swaylock";
      # }
    ];
    extraArgs = [
      "-w"
    ];
    systemdTarget = "graphical-session.target";
    timeouts = [
      {
        timeout = 600;
        command = "${pkgs.swaylock}/bin/swaylock";
        resumeCommand = ''${pkgs.libnotify}/bin/notify-send "Welcome back!!!"'';
      }
      {
        timeout = 605;
        command = "hyprctl dispatch dpms off";
        resumeCommand = "hyprctl dispatch dpms on";
      }
    ];
  };
  systemd.user.services = {
    sway-audio-idle-inhibit = {
      Unit = {
        Description = "Prevents swayidle from sleeping while any application is outputting or receiving audio.";
        Documentation = "https://github.com/ErikReider/SwayAudioIdleInhibit";
        After = ["swayidle.service"];
        Wants = ["swayidle.service"];
      };
      Service = {
        PassEnvironment = "PATH";
        ExecStart = "${pkgs.sway-audio-idle-inhibit}/bin/sway-audio-idle-inhibit";
        Type = "simple";
      };
    };
  };
}
