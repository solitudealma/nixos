{
  config,
  desktop,
  lib,
  pkgs,
  username,
  ...
}: let
  inherit (config._custom.globals) fonts;
  inherit (pkgs.stdenv) isLinux;
in {
  # import the DE specific configuration and any user specific desktop configuration
  imports =
    [
      ./apps
      ./features
    ]
    ++ lib.optional (builtins.pathExists (./. + "/${desktop}")) ./${desktop}
    ++ lib.optional (builtins.pathExists (
      ./. + "/${desktop}/${username}/default.nix"
    ))
    ./${desktop}/${username};

  # Authrorize X11 access in Distrobox
  home.file = lib.mkIf isLinux {
    ".distroboxrc".text = ''${pkgs.xorg.xhost}/bin/xhost +si:localuser:$USER'';
  };

  programs = lib.mkIf (username == "solitudealma") {
    kitty = {
      enable = true;
      settings = {
        scrollback_lines = 10000;
        update_check_interval = 0;
        enable_audio_bell = false;
        confirm_os_window_close = "0";
        disable_ligatures = "never";
        url_style = "curly";
        copy_on_select = "yes";
        cursor_shape = "Underline";
        cursor_underline_thickness = 5;
        window_padding_width = 15;
        tab_bar_style = "fade";
        tab_fade = 1;

        # Font
        font_family = fonts.mono;
        font_size = fonts.size;

        # Colors
        foreground = "#d3c6aa";
        background = "#2b3339";
        color0 = "#272727";
        color1 = "#e67e80";
        color2 = "#a7c080";
        color3 = "#dbbc7f";
        color4 = "#7fbbb3";
        color5 = "#d699b6";
        color6 = "#83c092";
        color7 = "#d3c6aa";
        color8 = "#928373";
        color9 = "#f85552";
        color10 = "#8da101";
        color11 = "#dfa000";
        color12 = "#3a94c5";
        color13 = "#df69ba";
        color14 = "#35a77c";
        color15 = "#5c6a72";
        cursor = "#d8caac";
        selection_foreground = "#655b53";
        selection_background = "#ebdbb2";
        url_color = "#d65c0d";
        active_tab_font_style = "bold";
        inactive_tab_font_style = "bold";
      };
    };
  };

  # https://nixos.wiki/wiki/Bluetooth#Using_Bluetooth_headsets_with_PulseAudio
  services.mpris-proxy.enable = isLinux;

  xresources = {
    extraConfig = ''
      #include "/home/${username}/.config/dwm/xcolors_dwm/rose_pine"
      #include "/home/${username}/.config/dmenu/xcolors_dmenu/rose_pine"
    '';
    properties = {
      # Font
      "St.font" = "${fonts.mono}:style=Medium:size=15:antialias=true:autohint=true";

      # Fallback fonts (max 8)
      "St.font_fallback1" = "JetBrainsMono Nerd Font Mono:size=15:antialias=true:autohint=true";
      "St.font_fallback2" = "Source Han Sans SC:size=13.5:antialias=true:autohint=true";

      # Default columns and rows numbers
      "St.cols" = 80;
      "St.rows" = 24;

      # Border
      "St.borderpx" = 2;

      # Allow resizing the window to any pixel size: 0 = off, 1 = on
      "St.anysize" = 1;

      # Background opacity
      "St.alpha" = "0.93";
      "St.alphaUnfocused" = "0.60";

      # Colors
      "St.foreground" = "gray90";
      "St.background" = "black";
      "St.bgUnfocused" = "black";
      "St.cursorColor" = "#cccccc";
      "St.reverseCursor" = "#555555";
      "St.visualbellcolor" = "gray90";
      "St.color0" = "black";
      "St.color1" = "red3";
      "St.color2" = "green3";
      "St.color3" = "yellow3";
      "St.color4" = "blue2";
      "St.color5" = "magenta3";
      "St.color6" = "cyan3";
      "St.color7" = "gray90";
      "St.color8" = "gray50";
      "St.color9" = "red";
      "St.color10" = "green";
      "St.color11" = "yellow";
      "St.color12" = "#5c5cff";
      "St.color13" = "magenta";
      "St.color14" = "cyan";
      "St.color15" = "white";
      # Foreground and background color of search results
      "St.highlightfg" = 15;
      "St.highlightbg" = 160;
      # Foreground and background color of the hyperlink hint
      "St.hyperlinkhintfg" = 0;
      "St.hyperlinkhintbg" = 258;
      # Foreground and background colors for keyboard selection mode bars
      "St.kbselectfg" = 0;
      "St.kbselectbg" = 258;
      # Dynamic cursor color:
      # 0 = the cursor color is fixed (default st behavior)
      # 1 = the cursor uses reverse colors based on the colors of the text cell
      "St.dynamic_cursor_color" = 1;
      # Default style of cursor
      "St.cursorstyle" = 2;
      # Controls the blinking of the cursor
      "St.cursorblinking" = 1;

      # Specifies how fast the blinking cursor blinks
      "St.cursorblinktimeout" = 800;
      # Kerning / character bounding-box multipliers
      "St.cwscale" = 1;
      "St.chscale" = 1;
      # Vertically center lines in the space available: 0 = off, 1 = on
      "St.vertcenter" = 0;
      # Boxdraw settings see. config.def.h
      "St.boxdraw" = 0;
      "St.boxdraw_bold" = 0;
      "St.boxdraw_braille" = 0;
      # Hide the X cursor whenever a key is pressed: 0 = off, 1 = on
      "St.hidecursor" = 0;
      # Ligatures: 0 = off, 1 = on
      "St.ligatures" = 0;
      # Command that is executed when a URL or hyperlink is clicked
      "St.url_opener" = "xdg-open";
      # List of URL protocols to search for when detecting a URL under the mouse
      "St.url_protocols" = "https:\/\/,http:\/\/,file:\/,ftp:\/\/,mailto:,vscode:\/\/";
      # Undercurl style: 0 = none, 1 = curly, 2 = spiky, 3 = capped
      "St.undercurl_style" = 2;
      # Adds 1 pixel of thickness for every undercurl_thickness_threshold pixels of font size
      "St.undercurl_thickness_threshold" = 28;
      # Extra thickness for spiky and capped waves: 0 = off, 1 = on
      "St.undercurl_extra_thickness" = 0;
      # Y-offset of undercurl
      "St.undercurl_yoffset" = 0;
      # Scaling factor for undercurl height
      "St.undercurl_height_scale" = 1;
      # Misc settings
      "St.termname" = "st-256color";
      "St.shell" = "/bin/sh";
      "St.minlatency" = 2;
      "St.maxlatency" = 33;
      "St.su_timeout" = 200;
      "St.blinktimeout" = 800;
      "St.doubleclicktimeout" = 300;
      "St.tripleclicktimeout" = 600;
      "St.bellvolume" = 0;
      "St.visualbellstyle" = 0;
      "St.visualbellduration" = 100;
      "St.visualbellanimfps" = 60;
      "St.tabspaces" = 8;
      "St.cursorthickness" = 2;
      "St.disable_bold" = 0;
      "St.disable_italic" = 0;
      "St.bold_is_not_bright" = 1;
      "St.hyperlinkstyle" = 1;
      "St.showhyperlinkhint" = 1;
      "St.disablehyperlinks" = 0;
      "St.autoscrolltimeout" = 200;
      "St.autoscrollacceleration" = 1;
    };
  };
}
