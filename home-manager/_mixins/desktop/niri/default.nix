{
  config,
  inputs,
  lib,
  pkgs,
  username,
  ...
}:
with lib; let
  binds = {
    suffixes,
    prefixes,
    substitutions ? {},
  }: let
    replacer = replaceStrings (attrNames substitutions) (attrValues substitutions);
    format = prefix: suffix: let
      actual-suffix =
        if isList suffix.action
        then {
          action = head suffix.action;
          args = tail suffix.action;
        }
        else {
          inherit (suffix) action;
          args = [];
        };
      action =
        if prefix.action == "spawn"
        then replacer "${prefix.action}${actual-suffix.action}"
        else replacer "${prefix.action}-${actual-suffix.action}";
    in {
      name = "${prefix.key}+${suffix.key}";
      value.action.${action} = actual-suffix.args;
    };
    pairs = attrs: fn:
      concatMap (
        key:
          fn {
            inherit key;
            action = attrs.${key};
          }
      ) (attrNames attrs);
  in
    listToAttrs (pairs prefixes (prefix: pairs suffixes (suffix: [(format prefix suffix)])));
in {
  imports = [
    inputs.niri.homeModules.niri
    ./ags
    ./hyprlock
    ./rofi
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
  };

  home = {
    packages = with pkgs; [
      brightnessctl
      cliphist
      labwc
      lswt
      swww
      wlrctl
      wl-clip-persist
      xorg.xprop
      xwayland-satellite
    ];
    shellAliases = {
    };
    # make stuff work on wayland
    sessionVariables = {
      QT_QPA_PLATFORM = "wayland";
      SDL_VIDEODRIVER = "wayland";
      XDG_SESSION_TYPE = "wayland";
    };
  };

  programs = {
    niri = {
      enable = true;
      package = pkgs.niri-unstable;
      settings = {
        environment = {
          CLUTTER_BACKEND = "wayland";
          DISPLAY = ":0";
          GDK_BACKEND = "wayland,x11";
          MOZ_ENABLE_WAYLAND = "1";
          QT_QPA_PLATFORM = "wayland;xcb";
          QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
          SDL_VIDEODRIVER = "wayland";
        };
        screenshot-path = "~/Pictures/Screenshots from %Y-%m-%d %H-%M-%S.png";
        debug = {
          disable-cursor-plane = [];
          render-drm-device = "/dev/dri/renderD129";
        };
        # Input Configuration
        input = {
          keyboard.xkb.layout = "us";
          focus-follows-mouse.enable = true;
          mouse.accel-speed = 1.0;
          touchpad = {
            click-method = "clickfinger";
            dwt = true;
            dwtp = true;
            natural-scroll = true;
            scroll-method = "two-finger";
            tap = true;
          };
          tablet.map-to-output = "eDP-1";
          touch.map-to-output = "eDP-1";
          warp-mouse-to-focus = true;
        };

        outputs = {
          "eDP-1" = {
            mode = {
              height = 1080;
              width = 1920;
              refresh = 144.0;
            };
            scale = 1.0;
            position = {
              x = 0;
              y = 0;
            };
            variable-refresh-rate = true;
            background-color = "#003300";
          };
        };
        # Workspace Configuration
        prefer-no-csd = true;
        workspaces = {
          "1" = {
            name = "terminal";
            open-on-output = "eDP-1";
          };
          "2" = {
            name = "2";
          };
          "3" = {
            name = "3";
          };
          "4" = {
            name = "video";
          };
          "5" = {
            name = "browser";
          };
          "6" = {
            name = "music";
          };
          "7" = {
            name = "chat";
          };
          "8" = {
            name = "game";
          };
        };

        # Layout Configuration
        layout = {
          gaps = 8;
          struts = {
            top = 0;
            bottom = 0;
            left = 0;
            right = 0;
          };
          focus-ring.enable = false;
          border = {
            enable = true;
            width = 2;
            active = {
              gradient = {
                from = "#f38ba8";
                to = "#f9e2af";
                angle = 45;
                relative-to = "workspace-view";
              };
            };
            inactive = {
              gradient = {
                from = "#585b70";
                to = "#7f849c";
                angle = 45;
                relative-to = "workspace-view";
              };
            };
          };
          preset-column-widths = [
            {proportion = 1.0 / 3.0;}
            {proportion = 1.0 / 2.0;}
            {proportion = 2.0 / 3.0;}
            {proportion = 1.0;}
          ];
          default-column-width = {proportion = 1.0 / 2.0;};
        };

        hotkey-overlay.skip-at-startup = true;

        # Keybindings Configuration
        binds = with config.lib.niri.actions; let
          playerctl = spawn "${pkgs.playerctl}/bin/playerctl";
          set-volume = spawn "wpctl" "set-volume" "@DEFAULT_SINK@";
          sh = spawn "sh" "-c";
        in
          lib.attrsets.mergeAttrsList [
            # Basic Application Controls
            {
              "Mod+Return".action = spawn "st";
              "Mod+D".action = sh "rofi -show drun -show-icons";
              "Mod+E".action = spawn "thunar";
              "Mod+L".action = sh "pgrep hyprlock || hyprlock";
              "Mod+Q".action = close-window;
            }

            # Screenshot Controls
            {
              # "Print".action = sh "flameshot full --clipboard";
              "Print".action = screenshot;
              "Mod+Print".action = screenshot-screen;
              "Shift+Super+S".action = screenshot-window;
            }

            # Media Controls
            {
              "XF86AudioRaiseVolume" = {
                action = sh ''wpctl set-volume @DEFAULT_SINK@ 5%+ && notify-send -c "system" "  $(wpctl get-volume @DEFAULT_SINK@ | awk '{print $1 * 100}')%"'';
                allow-when-locked = true;
              };
              "XF86AudioLowerVolume" = {
                action = sh ''wpctl set-volume @DEFAULT_SINK@ 5%- && notify-send -c "system" "  $(wpctl get-volume @DEFAULT_SINK@ | awk '{print $1 * 100}')%"'';
                allow-when-locked = true;
              };
              "XF86AudioMute" = {
                action = sh ''wpctl set-mute @DEFAULT_SINK@ toggle && notify-send -c "system" " Toggle Mute'';
                allow-when-locked = true;
              };
              "XF86MonBrightnessUp".action = sh "brightnessctl set 10%+";
              "XF86MonBrightnessDown".action = sh "brightnessctl set 10%-";
              "XF86AudioPlay".action = playerctl "play-pause";
              "XF86AudioStop".action = playerctl "pause";
              "XF86AudioPrev".action = playerctl "previous";
              "XF86AudioNext".action = playerctl "next";
            }

            # Directional Controls
            (binds {
              suffixes = {
                "Left" = "column-left";
                "Down" = "window-down";
                "Up" = "window-up";
                "Right" = "column-right";
              };
              prefixes = {
                "Mod" = "focus";
                "Mod+Ctrl" = "move";
                "Mod+Shift" = "focus-monitor";
                "Mod+Shift+Ctrl" = "move-window-to-monitor";
              };
              substitutions = {
                "monitor-column" = "monitor";
                "monitor-window" = "monitor";
              };
            })

            # Column Navigation
            (binds {
              suffixes = {
                "Home" = "first";
                "End" = "last";
              };
              prefixes = {
                "Mod" = "focus-column";
                "Mod+Shift" = "move-column-to";
              };
            })

            # Workspace Navigation
            (binds {
              suffixes = {
                "U" = "workspace-down";
                "I" = "workspace-up";
              };
              prefixes = {
                "Mod" = "focus";
                "Mod+Ctrl" = "move-window-to";
                "Mod+Shift" = "move";
              };
            })

            # Workspace Number Bindings
            (binds {
              suffixes = builtins.listToAttrs (
                map (item: {
                  name = item.key;
                  value = [
                    "workspace"
                    item.name
                  ];
                })
                [
                  {
                    "key" = "1";
                    "name" = "terminal";
                  }
                  {
                    "key" = "2";
                    "name" = "2";
                  }
                  {
                    "key" = "3";
                    "name" = "3";
                  }
                ]
              );
              prefixes = {
                "Mod" = "focus";
              };
            })

            (binds {
              suffixes = builtins.listToAttrs (
                map (item: {
                  name = item.key;
                  value = [
                    ""
                    "switch-workspace"
                    item.name
                    item.appID
                  ];
                })
                [
                  {
                    "key" = "4";
                    "name" = "video";
                    "appID" = "com.obsproject.Studio";
                  }
                  {
                    "key" = "C";
                    "name" = "browser";
                    "appID" = "firefox";
                  }
                  {
                    "key" = "M";
                    "name" = "music";
                    "appID" = "Spotify";
                  }
                  {
                    "key" = "0";
                    "name" = "chat";
                    "appID" = "QQ";
                  }
                  {
                    "key" = "9";
                    "name" = "game";
                    "appID" = "steam";
                  }
                ]
              );
              prefixes = {
                "Mod" = "spawn";
              };
            })

            (binds {
              suffixes = builtins.listToAttrs (
                map (n: {
                  name = toString n;
                  value = [
                    "workspace"
                    n
                  ];
                }) (range 1 9)
              );
              prefixes = {
                "Mod+Shift" = "move-window-to";
              };
            })

            # Window Management
            {
              "Mod+Space".action = toggle-window-floating;
              "Mod+Tab".action = switch-focus-between-floating-and-tiling;
              "Mod+Comma".action = consume-window-into-column;
              "Mod+Period".action = expel-window-from-column;
              "Mod+R".action = switch-preset-column-width;
              "Mod+F".action = maximize-column;
              "Mod+Shift+F".action = fullscreen-window;
              "Mod+Shift+C".action = center-column;
              "Mod+Minus".action = set-column-width "-10%";
              "Mod+Plus".action = set-column-width "+10%";
              "Mod+Shift+Minus".action = set-window-height "-10%";
              "Mod+Shift+Plus".action = set-window-height "+10%";
              "Mod+Shift+Q".action = quit;
              "Mod+Shift+P".action = power-off-monitors;
              "Mod+Shift+Ctrl+T".action = toggle-debug-tint;
              "Mod+WheelScrollDown" = {
                action = focus-workspace-down;
                cooldown-ms = 150;
              };
            }
          ];

        # Startup Applications
        spawn-at-startup = [
          {command = ["${lib.getExe pkgs.xwayland-satellite}"];}
          {command = ["dbus-update-activation-environment" "--systemd" "WAYLAND_DISPLAY" "XDG_CURRENT_DESKTOP=sway"];}
          {command = ["ags"];}
          {command = ["fcitx5" "--replace" "-d"];}
          {command = ["swww-daemon"];}
          {command = ["swww" "img" "${./4.png}" "-t" "wipe"];}
          {command = ["wl-paste" "--type" "image" "--watch" "cliphist" "store"];}
          {command = ["wl-paste" "--type" "text" "--watch" "cliphist" "store"];}
          {command = ["wl-clip-persist" "--clipboard" "both"];}
        ];

        # Animations
        animations = {
          slowdown = 0.9;
          workspace-switch = {
            spring = {
              damping-ratio = 1.0;
              stiffness = 2000;
              epsilon = 0.0001;
            };
          };
          horizontal-view-movement = {
            spring = {
              damping-ratio = 1.0;
              stiffness = 1000;
              epsilon = 0.0001;
            };
          };
          window-movement = {
            spring = {
              damping-ratio = 1.0;
              stiffness = 1000;
              epsilon = 0.0001;
            };
          };
          shaders = {
            window-close = ''
              vec4 close_color(vec3 coords_geo, vec3 size_geo) {
                // For this shader, set animation curve to linear for best results.

                // Simulate an accelerated fall: square the (linear) progress.
                float progress = niri_clamped_progress * niri_clamped_progress;

                // Get our rotation pivot point coordinates at the bottom center of the window.
                vec2 coords = (coords_geo.xy - vec2(0.5, 1.0)) * size_geo.xy;

                // Move the window down to simulate a fall.
                coords.y -= progress * 200.0;

                // Randomize rotation direction and maximum angle.
                float random = (niri_random_seed - 0.5) / 2.0;
                random = sign(random) - random;
                float max_angle = 0.05 * random;

                // Rotate the window around our pivot point.
                float angle = progress * max_angle;
                mat2 rotate = mat2(cos(angle), -sin(angle), sin(angle), cos(angle));
                coords = rotate * coords;

                // Transform the coordinates back.
                coords_geo = vec3(coords / size_geo.xy + vec2(0.5, 1.0), 1.0);

                // Sample the window texture.
                vec3 coords_tex = niri_geo_to_tex * coords_geo;
                vec4 color = texture2D(niri_tex, coords_tex.st);

                // Multiply by alpha to fade out.
                return color * (1.0 - niri_clamped_progress);
              }
            '';
            window-resize = ''
              vec4 resize_color(vec3 coords_curr_geo, vec3 size_curr_geo) {
                vec3 coords_next_geo = niri_curr_geo_to_next_geo * coords_curr_geo;

                vec3 coords_stretch = niri_geo_to_tex_next * coords_curr_geo;
                vec3 coords_crop = niri_geo_to_tex_next * coords_next_geo;

                // We can crop if the current window size is smaller than the next window
                // size. One way to tell is by comparing to 1.0 the X and Y scaling
                // coefficients in the current-to-next transformation matrix.
                bool can_crop_by_x = niri_curr_geo_to_next_geo[0][0] <= 1.0;
                bool can_crop_by_y = niri_curr_geo_to_next_geo[1][1] <= 1.0;

                vec3 coords = coords_stretch;
                if (can_crop_by_x)
                    coords.x = coords_crop.x;
                if (can_crop_by_y)
                    coords.y = coords_crop.y;

                vec4 color = texture2D(niri_tex_next, coords.st);

                // However, when we crop, we also want to crop out anything outside the
                // current geometry. This is because the area of the shader is unspecified
                // and usually bigger than the current geometry, so if we don't fill pixels
                // outside with transparency, the texture will leak out.
                //
                // When stretching, this is not an issue because the area outside will
                // correspond to client-side decoration shadows, which are already supposed
                // to be outside.
                if (can_crop_by_x && (coords_curr_geo.x < 0.0 || 1.0 < coords_curr_geo.x))
                    color = vec4(0.0);
                if (can_crop_by_y && (coords_curr_geo.y < 0.0 || 1.0 < coords_curr_geo.y))
                    color = vec4(0.0);

                return color;
              }
            '';
          };
        };
        # Window Rules
        window-rules = [
          {
            draw-border-with-background = false;
            geometry-corner-radius = let
              r = 8.0;
            in {
              top-left = r;
              top-right = r;
              bottom-left = r;
              bottom-right = r;
            };
            clip-to-geometry = true;
          }
          {
            matches = [
              {
                app-id = "^org.telegram.desktop$";
                title = "^Media viewer$";
              }
            ];
            open-fullscreen = false;
            default-column-width = {proportion = 0.5;};
          }
          {
            matches = [{is-focused = false;}];
            opacity = 0.95;
          }
          {
            matches = [
              {
                app-id = "St";
              }
            ];
            # opacity = 0.8;
            open-maximized = true;
            open-focused = true;
          }
          {
            matches = [
              {
                app-id = "QQ";
              }
            ];
            opacity = 1.0;
            open-maximized = true;
            open-on-workspace = "chat";
          }
          {
            matches = [
              {
                app-id = "firefox";
              }
            ];
            opacity = 0.97;
            open-maximized = true;
            open-on-workspace = "browser";
          }
          {
            matches = [
              {
                app-id = "firefox$";
                title = "^Picture-in-Picture$";
              }
            ];
            open-floating = true;
            default-floating-position = {
              x = 32;
              y = 32;
              relative-to = "bottom-left";
            };
          }
          {
            matches = [
              {
                app-id = "^firefox$";
                title = "Private Browsing";
              }
            ];
            border.active.color = "purple";
          }
        ];
      };
    };
  };

  systemd.user = {
    services = {
      polkit-gnome-authentication-agent-1 = {
        Unit.Description = "polkit-gnome-authentication-agent-1";
        Install.WantedBy = ["graphical-session.target"];
        Service = {
          Type = "simple";
          ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
          Restart = "on-failure";
          RestartSec = 1;
          TimeoutStopSec = 10;
        };
      };
      # xwayland-satellite = {
      #   Unit = {
      #     Description = "XWayland Satellite";
      #     PartOf = ["graphical-session.target"];
      #     After = ["graphical-session.target"];
      #   };

      #   Service = {
      #     ExecStart = lib.getExe pkgs.xwayland-satellite;
      #     Restart = "on-failure";
      #     KillMode = "mixed";
      #   };

      #   Install = {
      #     WantedBy = ["graphical-session.target"];
      #   };
      # };
    };
  };
}
