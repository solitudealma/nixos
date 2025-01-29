{
  hostname,
  inputs,
  lib,
  pkgs,
  username,
  ...
}: let
  envs = (import ./envs.nix {}).${hostname};
  monitors = (import ./monitors.nix {inherit username;}).${hostname};
  windowrules = (import ./windowrules.nix {}).${hostname};
  hyprActivity = pkgs.writeShellApplication {
    name = "hypr-activity";
    runtimeInputs = with pkgs; [
      coreutils-full
      gnugrep
      gnused
      obs-cmd
      procps
    ];
    text = ''
      set +e  # Disable errexit
      set +u  # Disable nounset
      HOSTNAME=$(hostname -s)

      function app_is_running() {
          local CLASS="$1"
          if hyprctl clients | grep "$CLASS" &>/dev/null; then
              return 0
          fi
          return 1
      }

      function wait_for_app() {
          local COUNT=0
          local SLEEP=1
          local LIMIT=5
          local CLASS="$1"
          echo " - Waiting for $CLASS..."
          while ! app_is_running "$CLASS"; do
              sleep "$SLEEP"
              ((COUNT++))
              if [ "$COUNT" -ge "$LIMIT" ]; then
                  echo " - Failed to find $CLASS"
                  break
              fi
          done
      }

      function start_app() {
          local APP="$1"
          local WORKSPACE="$2"
          local CLASS="$3"
          if ! app_is_running "$CLASS"; then
              echo -n " - Starting $APP on workspace $WORKSPACE: "
              hyprctl dispatch exec "[workspace $WORKSPACE silent]" "$APP"
              if [ "$APP" == "audacity" ]; then
                  sleep 5
              fi
              wait_for_app "$CLASS"
          else
              echo " - $APP is already running"
          fi
          echo -n " - Moving $CLASS to $WORKSPACE: "
          hyprctl dispatch movetoworkspacesilent "$WORKSPACE,$CLASS"
          hyprctl dispatch movetoworkspacesilent "$WORKSPACE,$APP" &>/dev/null
          if [ "$APP" == "gitkraken" ]; then
              hyprctl dispatch movetoworkspacesilent "$WORKSPACE,GitKraken" &>/dev/null
          fi
      }

      function activity_gsd() {
          start_app brave 1 "class: brave-browser"
          start_app wavebox 2 "class: wavebox"
          start_app discord 2 " - Discord"
          start_app telegram-desktop 3 "initialTitle: Telegram"
          start_app fractal 3 "class: org.gnome.Fractal"
          start_app halloy 3 "class: org.squidowl.halloy"
          start_app code 4 "initialTitle: Visual Studio Code"
          start_app "gitkraken --no-show-splash-screen" 4 "title: GitKraken Desktop"
          start_app kitty 5 "class: kitty"
          #start_app boxbuddy-rs 6 "class: io.github.dvlv.boxbuddyrs"
          #start_app pods 6 "class: com.github.marhkb.Pods"
          if [ "$HOSTNAME" == "phasma" ] || [ "$HOSTNAME" == "vader" ]; then
              start_app "obs --disable-shutdown-check --collection 'VirtualCam' --profile 'VirtualCam' --scene 'VirtualCam-DetSys' --startvirtualcam" 7 "class: com.obsproject.Studio"
          fi
          start_app cider 8 "class: Cider"
          firefox -CreateProfile meet-detsys
          start_app "firefox \
            -P meet-detsys \
            -no-remote \
            --new-window https://meet.google.com" 9 "title: Google Meet - Mozilla Firefox"
          start_app heynote  9 "class: Heynote"
          hyprctl dispatch forcerendererreload
      }

      function activity_linuxmatters() {
          start_app audacity 9 "class: audacity"
          firefox -CreateProfile linuxmatters-stage
          start_app "firefox -P linuxmatters-stage -no-remote --new-window https://github.com/restfulmedia/linuxmatters_backstage" 9 "title: restfulmedia/linuxmatters_backstage"
          if [ "$HOSTNAME" == "phasma" ] || [ "$HOSTNAME" == "vader" ]; then
              start_app "obs --disable-shutdown-check --collection VirtualCam --profile VirtualCam --scene VirtualCam-LinuxMatters --startvirtualcam" 9 "class: com.obsproject.Studio"
          fi
          hyprctl dispatch workspace 9 &>/dev/null
          firefox -CreateProfile linuxmatters-studio
          start_app "firefox \
              -P linuxmatters-studio \
              -no-remote \
              --new-window https://talky.io/linux-matters-studio" 7 "title: Talky — Mozilla Firefox"
          start_app telegram-desktop 7 "initialTitle: Telegram"
          start_app "nautilus -w $HOME/Audio" 7 "title: Audio"
          hyprctl dispatch workspace 7 &>/dev/null
          hyprctl dispatch forcerendererreload
      }

      function activity_wimpysworld() {
          firefox -CreateProfile wimpysworld-studio
          start_app "firefox \
              -P wimpysworld-studio \
              -no-remote \
              --new-window https://dashboard.twitch.tv/u/wimpysworld/stream-manager \
              --new-tab https://streamelements.com \
              --new-tab https://botrix.live" 9 "title: Twitch — Mozilla Firefox"
          start_app "obs --disable-shutdown-check --collection 'Wimpys World' --profile Dev-Local --scene Collage" 7 "class: com.obsproject.Studio"
          start_app chatterino 7 "chatterino"
          start_app discord 9 " - Discord"
          start_app code 10 "initialTitle: Visual Studio Code"
          start_app gitkraken 10 "title: GitKraken Desktop"
          start_app kitty 10 "class: kitty"
          firefox -CreateProfile wimpysworld-stage
          start_app "firefox \
              -P wimpysworld-stage \
              -no-remote \
              --new-window https://wimpysworld.com
              --new-tab https://github.com/wimpysworld" 10 "title: Wimpy's World — Mozilla Firefox"
          hyprctl dispatch forcerendererreload
      }

      function activity_8bitversus() {
          firefox -CreateProfile 8bitversus-studio
          start_app "firefox \
            -P 8bitversus-studio \
            -no-remote \
            --new-window https://dashboard.twitch.tv/u/8bitversus/stream-manager" 9 "title: Twitch — Mozilla Firefox"
          start_app "obs --disable-shutdown-check --collection 8-bit-VS --profile 8-bit-VS-Local --scene Hosts" 7 "class: com.obsproject.Studio"
          start_app chatterino 7 "chatterino"
          start_app discord 9 " - Discord"
          hyprctl dispatch forcerendererreload
      }

      function activity_clear() {
          if pidof -q obs; then
              obs-cmd virtual-camera stop
          fi
          sleep 0.25
          hyprctl clients -j | jq -r ".[].address" | xargs -I {} hyprctl dispatch closewindow address:{}
          sleep 0.75
          hyprctl dispatch workspace 1 &>/dev/null
      }

      OPT="help"
      if [ -n "$1" ]; then
          OPT="$1"
      fi

      case "$OPT" in
          8bitversus) activity_8bitversus;;
          clear) activity_clear;;
          gsd) activity_gsd;;
          linuxmatters) activity_linuxmatters;;
          wimpysworld) activity_wimpysworld;;
          *) echo "Usage: $(basename "$0") {clear|gsd|8bitversus|linuxmatters|wimpysworld}";
            exit 1;;
      esac
    '';
  };
  hyprActivityMenu = pkgs.writeShellApplication {
    name = "hypr-activity-menu";
    runtimeInputs = with pkgs; [
      fuzzel
      notify-desktop
    ];
    text = ''
      appname="hypr-sessionmenu"
      gsd="💩 Get Shit Done"
      record_linuxmatters="️🎙️ Record Linux Matters"
      stream_wimpysworld="📹 Stream Wimpys's World"
      stream_8bitversus="️🕹️ Stream 8-bit VS"
      clear="🛑 Close Everything"
      selected=$(
        echo -e "$gsd\n$record_linuxmatters\n$stream_wimpysworld\n$stream_8bitversus\n$clear" |
        fuzzel --dmenu --prompt "󱑞 " --lines 5)
      case $selected in
        "$clear")
          notify-desktop "$clear" "Whelp! Here comes the desktop Thanos snap!" --app-name="$appname"
          hypr-activity clear
          ;;
        "$gsd")
          notify-desktop "$gsd" "Time to knuckle down. Here's comes the default session." --app-name="$appname"
          hypr-activity gsd
          notify-desktop "💩 Session is ready" "The desktop session is all set and ready to go." --app-name="$appname"
          ;;
        "$record_linuxmatters")
          notify-desktop "$record_linuxmatters" "Get some Yerba Mate and clear your throat. Time to chat with Alan and Mark." --app-name="$appname"
          hypr-activity linuxmatters
          notify-desktop "🎙️ Session is ready" "Podcast studio session is initialised." --app-name="$appname"
          ;;
        "$stream_wimpysworld")
          notify-desktop "$stream_wimpysworld" "Lights. Camera. Action. Setting up the session to stream to Wimpy's World." --app-name="$appname"
          hypr-activity wimpysworld
          notify-desktop "📹 Session is ready" "Streaming session is engaged and ready to go live." --app-name="$appname"
          ;;
        "$stream_8bitversus")
          notify-desktop "$stream_8bitversus" "Two grown men reignite the ultimate playground fight of their pasts: which is better, the Commodore 64 or ZX Spectrum?" --app-name="$appname"
          hypr-activity 8bitversus
          notify-desktop "🕹️ Session is ready" "Dust of your cassette tapes, retro-gaming streaming is ready." --app-name="$appname"
          ;;
      esac
    '';
  };
  hyprSession = pkgs.writeShellApplication {
    name = "hypr-session";
    runtimeInputs = with pkgs; [
      bluez
      coreutils-full
      gnused
      playerctl
      procps
    ];
    text = ''
      set +e  # Disable errexit
      set +u  # Disable nounset
      HOSTNAME=$(hostname -s)

      function bluetooth_devices() {
          case "$1" in
              connect|disconnect)
                  if [ "$HOSTNAME" == "phasma" ]; then
                      bluetoothctl "$1" E4:50:EB:7D:86:22
                  fi
                  ;;
          esac
      }

      function session_start() {
          # Restart the desktop portal services in the correct order
          for ACTION in stop start; do
            for PORTAL in xdg-desktop-portal-hyprland xdg-desktop-portal-gtk xdg-desktop-portal; do
                systemctl --user "$ACTION" "$PORTAL"
            done;
          done

          bluetooth_devices connect
          sleep 3.0
          systemctl --user restart maestral-gui
          # if ! pidof -q waybar; then
          #   systemctl --user restart waybar
          # fi
      }

      function session_stop() {
          playerctl --all-players pause
          hypr-activity clear
          pkill trayscale
      }

      OPT="help"
      if [ -n "$1" ]; then
          OPT="$1"
      fi

      case "$OPT" in
          start) session_start;;
          lock)
            pkill wlogout
            sleep 0.5
            hyprlock --immediate;;
          logout)
            session_stop
            hyprctl dispatch exit;;
          reboot)
            session_stop
            systemctl reboot;;
          shutdown)
            session_stop
            systemctl poweroff;;
          *) echo "Usage: $(basename "$0") {start|lock|logout|reboot|shutdown}";
            exit 1;;
      esac
    '';
  };
in {
  home = {
    file = {
      ".config/hypr" = {
        source = ./hypr;
        recursive = true;
      };
    };

    packages =
      (with pkgs; [
        hyprActivity
        hyprActivityMenu
        hyprSession
      ])
      ++ (with inputs.hyprland-contrib.packages.${pkgs.system}; [
        hdrop
        hyprprop
        scratchpad
      ]);
  };
  # Hyprland is a Wayland compositor and dynamic tiling window manager
  # Additional applications are required to create a full desktop shell
  imports = [
    # inputs.hyprland.homeManagerModules.default
    ./ags
    ./grim # screenshot grabber and annotator
    ./hyprlock
    ./hyprpicker
    ./rofi # app launcher, emoji picker and clipboard manager
    # ./swaync        # notification center
    ./swww # wallpaper
    # ./waylandidle   # idle
    ./wlogout # session menu
  ];
  services = {
    flameshot = {
      enable = true;
      package = pkgs.unstable.flameshot.override {enableWlrSupport = true;};
      settings.General = {
        disabledTrayIcon = true;
        showStartupLaunchMessage = false;
      };
    };
    gpg-agent.pinentryPackage = lib.mkForce pkgs.pinentry-gnome3;
  };

  systemd.user.services = {
    polkit-gnome-authentication-agent-1 = {
      Unit.Description = "polkit-gnome-authentication-agent-1";
      Install.WantedBy = ["hyprland-session.target"];
      Service = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
  };

  wayland.windowManager.hyprland = {
    enable = true;
    # importantPrefixes = [];
    # package = pkgs.hyprland;
    plugins = with inputs.hyprland-plugins.packages.${pkgs.system}; [
      #   csgo-vulkan-fix
      hyprtrails
    ];
    settings = {
      inherit (envs) env;
      inherit (monitors) monitor workspace;
      inherit (windowrules) windowrule windowrulev2;
      animations = {
        animation = [
          "windows, 1, 6, wind, slide"
          "windowsIn, 1, 6, winIn, slide"
          "windowsOut, 1, 5, winOut, slide"
          "windowsMove, 1, 5, wind, slide"
          "border, 1, 10, liner"
          "borderangle, 1, 100, linear, loop"
          "fade, 1, 10, default"
          "workspaces, 1, 5, wind"
        ];
        bezier = [
          "wind, 0.05, 0.9, 0.1, 1.05"
          "winIn, 0.1, 1.1, 0.1, 1.1"
          "winOut, 0.3, -0.3, 0, 1"
          "liner, 1, 1, 1, 1"
          "linear, 0.0, 0.0, 1.0, 1.0"
        ];
        enabled = true;
        first_launch_animation = true;
      };
      binds = {
        pass_mouse_when_bound = true; # 如果禁用，则不会将鼠标事件传递给应用 在触发键绑定时拖动窗口
        scroll_event_delay = 300; # 以 ms 为单位，在滚动事件后等待多少毫秒，才允许传递建绑定 (ms)
        workspace_back_and_forth = false; # 如果启用，尝试切换到当前焦点工作区将更改为切换到上一个工作区，类似 i3 的 auto_back_and_forth
        allow_workspace_cycles = false; # 如果启用，工作区不会忘记以前的工作区，因此可以通过按顺序切换到第一个工作区来创建周期
        workspace_center_on = 0; # 切换工作区是应将光标居中放在工作区 （0） 上还是该工作区的最后一个活动窗口 （1）
        focus_preferred_method = 0; # 设置使用 movewindow / focuswindow 方向时首选的焦点查找方法，0 - 历史记录（最近优先）， 1 - 长度 （较长的共享边具有优先级）
        ignore_group_lock = false; # 启用后，dispatchers moveintogroup moveoutofgroup movewindoworgroup 将会忽略组锁定
      };
      cursor = {
        no_hardware_cursors = 2; # 禁用硬件光标。将auto设置为 2，这会在 Nvidia 上禁用它们，而在其他情况下保持启用状态。
        no_break_fs_vrr = false; # 禁用在启用 VRR 的全屏应用的光标移动时安排新帧，以避免帧速率峰值(需要 no_hardware_cursors = true)
        min_refresh_rate = 24; # no_break_fs_vrr = true 时光标移动的最小刷新率，设置为支持的最低刷新率或者更高
        hotspot_padding = 1; # 屏幕边缘和光标之间的填充 (px)
        inactive_timeout = 3; # 光标不活动多少秒后隐藏, 0 表示从不
        no_warps = false; # 如果为 true ，则在许多情况下不会扭曲光标 (聚焦，按键绑定)
        persistent_warps = true; # 当窗口重新聚焦时，光标返回到相对于该窗口的最后位置，而不是中心
        warp_on_change_workspace = true; # 如果为 true ，则在更改工作区后将光标移动到最后一个焦点窗口
        #default_monitor = [[Empty]]  # 启动时要设置的光标的默认监视器的名称，(相关名称，参阅 hyprctl monitors)
        zoom_factor = 1.0; # 光标周围缩放的系数，最小 1.0 (表示无缩放)
        zoom_rigid = false; # 缩放是否应该严格跟随光标 (如果可以，光标始终居中)还是松散的跟随
        enable_hyprcursor = true; # 启动hyprcursor支持
        hide_on_key_press = false; # 当按下任意键时隐藏光标，直到鼠标移动
        hide_on_touch = true; # 当最后一个输入是触摸输入时隐藏光标，直到鼠标输入完成
        #allow_dumb_copy = false;     # 使硬件光标在 nvidia 上工作，(每当图像发生变化时可能出现故障)
      };
      debug = {
        disable_scale_checks = false;
        disable_logs = true; # 禁用记录到文件
      };
      decoration = {
        # ## 圆角
        rounding = 15; # 半径 （px)

        # ## 透明度
        active_opacity = 0.8; # 活动 (0.0 - 1.0)
        inactive_opacity = 0.8; # 非活动
        fullscreen_opacity = 0.8; # 全屏窗口

        # ## 阴影
        shadow = {
          enabled = true; # 启用阴影
          range = 40; # 范围 (px)
          render_power = 3; # 衰减功率 (1 - 4, 越大衰减越快)
          ignore_window = true; # 是否渲染在窗口本身后面，否则仅渲染窗口周围
          color = "0x66404040"; # 活动窗口阴影颜色
          color_inactive = "0x66404040"; # 非活动窗口阴影颜色 (unset 则与 col.shadow 相同)
          offset = "1 2"; # 偏移 [0,0]
          scale = 1.0; # 阴影缩放比例 (0.0 - 1.0)
        };

        # 其他
        dim_inactive = false; # 非活动窗口变暗 (效果在窗口非透明情况下不错)
        dim_strength = 0.5; # 非活动窗口变暗数值(0.0 - 1.0)
        dim_special = 0.4; # 打开特殊工作区时，屏幕其余部分暗度(0.0 - 1.0)
        dim_around = 0.4; # 添加了 dimaround 窗口规则情况下窗口的暗度(0.0 - 1.0)
        #screen_shader          =              # 在渲染结束时应用的自定义着色器的路径 ( 参考: https://github.com/hyprwm/Hyprland/tree/main/example/screenShader.frag )

        blur = {
          enabled = true; # [ NEW BUG ]
          size = 10; # 最少为 1
          passes = 5; # 最少为 1，高 passes 对 GPU 施加更大压力
          new_optimizations = true; # 是否对模糊启用优化，提高性能
          xray = true; # 浮动窗口透明桌面
          ignore_opacity = false; # 使模糊图层忽略窗口的不透明度
          noise = 0.02; # 噪声 (0.0 - 1.0)
          contrast = 1.2; # 对比度 (0.0 -2.0)
          brightness = 0.8; # 亮度 (0.0 - 2.0)
          special = false; # 作用于特殊工作区 (性能损耗大)
          vibrancy = 1.0; # 模糊颜色的饱和度
          vibrancy_darkness = 0.5; # 对变暗区域的 vibrancy 影响
          popups = true; # 是否模糊弹出窗口 （右键菜单）
          popups_ignorealpha = 0.2; # 如果像素不透明度地域设定值，则不会模糊 [0.0 - 1.0]
        };
      };
      dwindle = {
        pseudotile = true; # enable pseudotiling on dwindle
        force_split = 2;
        preserve_split = true;
        special_scale_factor = 0.8; # (0.0 - 1.0) 指定特殊工作区上窗口的缩放
      };
      exec = [
        "ags"
        # "hyprshade auto"
      ];
      exec-once = [
        "hypr-session start"
        "echo \"Xft.dpi: 100\" | xrdb -merge"
        "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
        "swww query || swww-daemon --format xrgb"
        "fcitx5 --replace -d"
        "$AOTU_SWITCH_WALLPAPER"
        "mpd && mpc random on"
        "xrdb ~/.Xresource"
      ];
      general = {
        # ## 布局
        layout = "scroller"; # master,dwindle(default)

        # ## 鼠标
        #sensitivity             = 1.0;        # 鼠标灵敏度  (推荐优先使用 input:sensitivity，将灵敏度绑定到指定设备避免未知错误)
        #cursor_inactive_timeout = 3;          # 非活动状态隐藏鼠标(秒)
        #no_cursor_warps         = false;      # 如果为 true，则在许多情况下不会扭曲光标（聚焦、键绑定等)
        #apply_sens_to_raw       = false;       # 如果启用，还将对原始鼠标输出应用灵敏度（例如游戏中的灵敏度） 注意：真的不推荐。

        # ## 窗口
        gaps_in = 8; # 窗口之间的间隙
        gaps_out = 15; # 窗口与屏幕边缘之间的间隙
        border_size = 2; # 窗口边框大小
        "col.active_border" = "rgb(cba6f7) rgb(f38ba8) rgb(eba0ac) rgb(fab387) rgb(f9e2af) rgb(a6e3a1) rgb(94e2d5) rgb(89dceb) rgb(89b4fa) rgb(b4befe) 270deg"; # 活动窗口边框颜色
        "col.inactive_border" = "rgb(45475a) rgb(313244) rgb(45475a) rgb(313244) 270deg"; # 非活动窗口边框颜色
        no_border_on_floating = false; # 浮动窗口边框
        #no_focus_fallback       = false;       # 如果为 true，则在将焦点移动到没有窗口的方向时失去窗口焦点，不回退到下一个可选窗口

        # ## Group 组
        "col.nogroup_border" = "rgb(ffaaff)"; # 对于禁止添加入组的窗口的非活动边框颜色（请参阅 denywindowfromgroup 调度程序）
        "col.nogroup_border_active" = "rgb(ff00ff)"; # 对于禁止加入组的窗口的活动边框颜色

        # ## 其他
        resize_on_border = true; # 允许拖动边框和间隙调整窗口大小
        extend_border_grab_area = 15; # 拓展边框周围区域，允许在其中单击并拖动 前置设置：general:resize_on_border
        hover_icon_on_border = true; # 鼠标悬停边框周围时显示拖动图标         前置设置：general:extend_border_grab_area
        allow_tearing = false; # 是否允许发送画面撕裂的主开关 (intel 不支持) [v0.30.0]
        gaps_workspaces = 0; # 工作区之间的间距，并与gaps_out 堆叠
        resize_corner = 0; # 强制浮动窗口在调整大小时使用特定角度（1-4 从左上角顺时针旋转，0禁用）
      };
      gestures = {
        workspace_swipe = false; # 启用工作区滑动手势
        workspace_swipe_fingers = 2; # 手指数量
        workspace_swipe_distance = 300; # 手势距离 (px)
        workspace_swipe_invert = true; # 反转方向
        workspace_swipe_min_speed_to_force = 0; # 每个时间点以 px 为单位的最小速度，以强制忽略 cancel_ratio 更改。设置为 将 0 禁用此机制。
        workspace_swipe_cancel_ratio = 0.5; # 手势触发距离 (0.0 - 1.0) 滑动距离 > 0.5 * 手势距离 = 触发手势
        workspace_swipe_create_new = true; # 在最后一个工作区向右滑动是否创建新工作区
        workspace_swipe_direction_lock = true; # 锁屏触发？
        workspace_swipe_direction_lock_threshold = 10; # 方向锁定触发的距离 (px) ?
        workspace_swipe_forever = false; # 滑动不会回退到相邻工作区，而是到下一个工作区 ?
        # workspace_swipe_numbered            = false;   # ## 在连续编号的工作区之间切换 [delete]
        workspace_swipe_use_r = false; # ## 如果启用，轻扫将使用前缀 r 而不是 m 前缀来查找工作区。（需要禁用 workspace_swipe_numbered)
      };
      group = {
        insert_after_current = true; # 组中新窗口是在当前之后还是在组尾生成
        focus_removed_window = false; # 是否聚焦于刚移除群组的窗口
        # ## Colors: #c23c7f Default
        # ====| #ef5b9c:踯躅 | #ea66a6:牡丹 | #c77eb5:菖蒲 | #f05b72:蔷薇 | #f173ac:赤紫 |====

        # ====| #f15b6c:韩红 | #ca8687:薄柿 | #5f3c32:枯茶 | #6b473c:焦茶 | #6d5826:鹭茶 |====

        # ====| #444693:绀桔 | #2b4490:花   | #2a5caa:瑠璃 | #102b6a:青蓝 | #4e72b8:群青 |====
        # ## 组
        "col.border_active" = "rgb(8D54E0)"; # 活动组边框颜色   -聚焦
        "col.border_inactive" = "rgb(40E0D0)"; # 非活动组边框颜色 -失焦 {#40E0D0:只此青绿,}
        "col.border_locked_active" = "rgb(E60000)"; # locked组边框颜色 -聚焦
        "col.border_locked_inactive" = "rgb(900021)"; # locked组边框颜色 -失焦

        groupbar = {
          enabled = true; # 启用groupbar
          scrolling = true; # 在组拦中滚动是否更改活动窗口
          font_family = "Maple Mono NF CN";
          font_size = 12; # 标题字体大小(8)
          gradients = false; # 组窗口标题栏是否绘制渐变(true)
          render_titles = false; # 窗口组标题显示 (true)
          text_color = "0xffffffff"; # (0xffffffff) 组标题栏背景颜色
          "col.active" = "0x66777700"; # 活跃组边框颜色
          "col.inactive" = "0x66ff5500"; # 非活动组边框颜色
          "col.locked_active" = "0x66ff5500"; # 活动锁定组边框颜色
          "col.locked_inactive" = "0x66775500"; # 非活动锁定组边框颜色
          #moveintogroup_lock_check  = false  # 窗口加入组前检查组是否已经锁定 [v0.30.0 delete]
        };
      };
      input = {
        # ## XKB 键盘映射
        #kb_model  =
        kb_layout = "us";
        #kb_variant=
        #kb_options=
        #kb_rules  =
        #kb_file =                        # 自定义 XKB 文件路径

        # ## keyboard
        numlock_by_default = false; # 默认开启小键盘
        resolve_binds_by_sym = false; # 使用多个键盘布局时案件绑定的行为模式，false 默认为第一个指定布局，否则当使用相应布局则激活对应布局指定的符号指定的按键绑定
        #repeat_rate = 25                  # 按住键的重复速率 (秒/次数)
        #repeat_delay = 600                # 重复按住键之前的延迟 (ms)

        # ## mouse
        sensitivity = 1.0; # 鼠标灵敏度 (-1.0 - 1.0) (https://wayland.freedesktop.org/libinput/doc/latest/pointer-acceleration.html#pointer-acceleration)
        accel_profile = "custom"; # 设置光标加速配置文件。可以是adaptive、flat 之一  。也可以， custom 见下文。留空以对输入设备使用 libinput 的默认模式。
        force_no_accel = false; # 强制不启用光标加速。这将绕过大多数指针设置，以获得尽可能原始的信号。不建议启用此功能，因为可能会出现游标不同步。
        left_handed = false; # 左手模式
        # scroll_points: custom 设置滚动加速配置文件，<step> <point> 形式，留空则使用平滑的滚动曲线 [模拟windows: https://gist.github.com/fufexan/de2099bc3086f3a6c83d61fc1fcc06c9]
        scroll_points = "0.2144477506  0.000 0.051 0.102 0.179 0.257 0.334 0.418 0.535 0.652 0.769 0.886 1.003 1.120 1.237 1.354 1.471 1.588 1.705 1.823 2.064";
        # scroll_method =                  # 设置滚动方法。可以是 2fg （2 根手指）、 edge 、 on_button_down 、 no_scroll 之一。库输入#滚动
        # scroll_button = 0                # 滚动按钮 (int) 0 是默认值
        # natural_scroll = false            # 反转滚动方向，滚动会直接移动内筒而不是操控滚动条
        # scroll_button_lock = false        # 滚动按钮锁定，则无需按住滚动按钮，再次按下则切换按钮锁定状态
        # scroll_factor = 1.0               # 为外部鼠标滚动添加乘数（触摸板有一个单独的的scroll_factor 设置)
        follow_mouse = 1; # （0/1/2/3） 指定光标移动是否以及如何影响窗口焦点
        mouse_refocus = false; # 禁用则鼠标焦点将不会切换到悬浮窗口，在悬浮窗口与普通窗口重叠时, 除非在 follow_mouse=1 时鼠标越过普通窗口边界
        float_switch_override_focus = 2; # 如果启用（1 或 2），则从平铺更改为浮动时，焦点将更改为光标下方的窗口，反之亦然。如果为 2，焦点也将跟随鼠标在浮子到浮子开关上
        special_fallthrough = true; # 如果启动，则特殊工作区中只有浮动窗口的情况下将不会挡住常规工作区中的聚焦窗口 (没效果？)
        off_window_axis_events = 1; # 处理聚焦窗口周围的轴事件（平铺间隙/边框，浮动的拖动区域/边框），0 忽略，1发送界坐标，2 伪造指针坐标到窗口内最近的点，3 扭曲窗口光标移动到窗口内最近的点

        touchpad = {
          # 触摸板设置
          disable_while_typing = true; # 输入时禁用触摸板
          natural_scroll = true; # 反向滚动
          scroll_factor = 1.0; # 滚动距离
          middle_button_emulation = false; # 同时发送 LMB 和 RMB 将被识别为鼠标中间点击，这将禁用任何通常会根据位置发送中键单击的触摸板区域。( https://wayland.freedesktop.org/libinput/doc/latest/middle-button-emulation.html )
          # tap_button_map       =          # 设置触摸板按钮模拟的点击映射，lrm (default) 或者 lmr (left,middle,right buttons)
          # clickfinger_behavior = false    # 分别用 1 2 3 根手指按下映射为 LMB,RMB,MMB。这将会禁用触摸板的单击解释 (https://wayland.freedesktop.org/libinput/doc/latest/clickpad-softbuttons.html#clickfinger-behavior)
          # tap-to-click         = true     # 分别用 1 2 3 根手指按下映射为 LMB,RMB,MMB
          drag_lock = false; # 拖动时将手指抬起一小段时间不会放下拖动项目
          # tap-and-drag         = false    # 触摸板的点击和拖动模式
        };

        touchdevice = {
          # [v0.30.0]
          transform = 3;
          #output = [auto]    # 显示器绑定触摸设备，默认为自动，空字符串/[[Empty]]停止自动检测
          #enabled = true     # 是否为触摸设备启动输入
        };
        tablet = {
          # [v0.30.0]
          transform = 3;
          #output = [[Empty]]         # 显示器绑定 tablet, 空字符串为不绑定
          #region_position = [0,0]    # 监视器布局中映射区域的位置
          #region_size     = [0,0]    # 映射区域的大小，tablet 输入将映射到该区域，[0,0]/无效的大小表示未设置
          #relative_input = false     # 相对输入
          #left_handed = flase        # 如果启用，tablet 将旋转 180度
          #active_area_size = [0,0]   # tablet 活动区域大小 (毫米)
          #active_area_position = [0,0] # 活动区域位置 (毫米)
        };
      };
      layerrule = [
        "blur, launcher" # fuzzel
        "ignorezero, launcher"
        "blur, logout_dialog" # wlogout
        "blur, rofi"
        "blur, swaync-control-center"
        "blur, swaync-notification-window"
        "ignorealpha 0.7, swaync-control-center"
        "ignorealpha 0.7, swaync-notification-window"
      ];
      #https://wiki.hyprland.org/Configuring/Master-Layout/
      master = {
        mfact =
          if (hostname == "laptop" || hostname == "phasma")
          then 0.5
          else 0.55;
      };
      misc = {
        disable_hyprland_logo = false; # 禁用随机海普兰徽标/动漫女孩背景
        disable_splash_rendering = false; # 禁用 Hyprland splash 渲染
        force_default_wallpaper = -1; # 强制执行 3 张默认壁纸中的任何一张。 0: 禁用动漫背景。 -1: “随机”
        #col.splash                    =
        # font_family                   = "Maple Mono NF CN";   # 设置全局默认字体以呈现从系统字体中选择的文本，包括调试 fps/通知、配置错误消息等。
        vfr = true; # 控制 hyprland 的 VFR 状态。强烈建议保留 true 以节省资源 (default:true)
        vrr = 0; # 控制显示器的 VRR 自适应同步，0 - 关闭，1 - 打开, 2 - 仅全屏 (default:0)
        mouse_move_enables_dpms = false; # 关闭禁用鼠标移动唤醒可以一同禁用触控唤醒
        key_press_enables_dpms = true; # 在dmps设置为关闭时，只能通过键盘来唤醒屏幕
        always_follow_on_dnd = true; # 拖放时鼠标焦点跟随鼠标 (default:true)
        layers_hog_keyboard_focus = true; # 使键盘交互层将焦点集中在鼠标移动上
        animate_manual_resizes = true; # 手动更改窗口大小时进行动画处理 (default:false)
        animate_mouse_windowdragging = false; # 对鼠标拖动移动的窗口进行动画处理,可能会有奇怪画面bug(default:false)
        disable_autoreload = false; # 关闭 Hyprland 配置自动重载，可以使用 hyprctl reload 手动重载，可能会节省电池
        enable_swallow = false; # 窗口吞噬
        #swallow_regex                 =        # 用于应吞噬的窗口 (通常是终端) 的类正则表达式 (str, https://github.com/ziishaned/learn-regex/blob/master/README.md )
        #swallow_exception_regex       =        # 标题正则，用于不应该被 swallow_regex 中指定的窗口吞噬的窗口 (e.g. wev)
        focus_on_activate = true; # Hyprland 是否关注请求聚焦的应用
        #no_direct_scanout             = true   # 禁用直接扫描。当屏幕只有一个全屏应用 (e.g. 游戏)，直接扫描尝试减少延迟 (default:true)
        allow_session_lock_restore = true; # 允许您重新启动锁屏应用程序，以防它崩溃红屏死机
        mouse_move_focuses_monitor = true; # 窗口焦点移动到其他显示器时是否聚焦
        render_ahead_of_time = false; # 在显示器显示帧之前开始渲染，以降低延迟 (Warning:Buggy, default:false)
        render_ahead_safezone = 1; # 要提前添加到渲染中的安全时区 (ms) (推荐 1-2 ms)
        close_special_on_empty = true; # 如果删除最后一个窗口，关闭特殊工作区 (0.29.1)
        #background_color              = 0x111111 # 启用背景颜色 (前置启用 disable_hyprland_logo/ v0.29.0)
        #ssuppress_portal_warnings      = false   # 禁用有关不兼容 portal 实现的警告 [wiki 中有相关选项，但是实际并不支持？]
        #font_family                   = HYLeMiaoTiJ Regular
        #splash_font_family            =       # 更改用于渲染启动文本的字体，从系统字体中选择（需要重新加载监视器才能生效）。	string 细绳	[[Empty]] [[空的]]

        # ## Cursor
        #cursor_zoom_factor            = 1.0    # 光标围绕缩放，放大镜 (Minimum:1.0 无缩放)
        #cursor_zoom_rigid             = false  # 光标周围的缩放应该严格跟随光标(如果可以，光标始终居中)还是松散 (default:false)

        # ## 触控屏幕
        #hide_cursor_on_touch          = true  # 当最后一个输入是触摸时隐藏光标，直到输入完毕

        new_window_takes_over_fullscreen = 2; # ## 如果存在全屏窗口，则打开的新平铺窗口应替换全屏窗口还是保留。0 - 后面，1 - 接管，2 - 取消全屏当前全屏窗口 [v 0.31.0 add]
        initial_workspace_tracking = 0; # 窗口将在调用他们的工作区上打开，0禁用，1单次，2持久
        middle_click_paste = true; # 鼠标中键单击粘贴(也称为主要选择)
      };
      plugin = {
        # csgo-vulkan-fix = {
        #   res_w = 1680;
        #   res_h = 1050;

        #   # NOT a regex! This is a string and has to exactly match initial_class
        #   class = "cs2";

        #   # Whether to fix the mouse position. A select few apps might be wonky with this.
        #   fix_mouse = true;
        # };
        hyprtrails = {
          color = "rgba(a6e3a1aa)";
          bezier_step = 0.025; #0.025
          points_per_step = 2; #2
          history_points = 12; #20
          history_step = 2; #2
        };
      };
      source = [
        "~/.config/hypr/init.conf"
        "~/.config/hypr/**/*.conf"
      ];
      xwayland = {
        use_nearest_neighbor = true; # 对 xwayland 应用使用最近的 neigbor 过滤，使它们像素化而不是模糊 (default:true)
        force_zero_scaling = true; # 强制缩放显示器上的 xwayland 窗口比例为 1 (default:false)
      };
    };
    # sourceFirst = true;
    systemd = {
      enableXdgAutostart = true;
      variables = [
        "--all"
      ];
    };
    xwayland.enable = true;
  };
}
