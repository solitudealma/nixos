{
  config,
  pkgs,
  ...
}: let
  inherit (config._custom.globals) fonts;
in {
  services.dunst = {
    enable = true;
    iconTheme = {
      package = pkgs.adwaita-icon-theme;
      name = "Adwaita";
    };
    settings = {
      experimental = {
        per_monitor_dpi = false;
      };
      global = {
        width = 400;
        height = 200;
        origin = "top-right";
        offset = "15x65";
        scale = 0;
        monitor = 0;
        follow = "mouse";
        progress_bar = true;
        progress_bar_height = 10;
        progress_bar_frame_width = 0;
        progress_bar_min_width = 350;
        progress_bar_max_width = 400;
        indicate_hidden = "yes";
        padding = 12;
        horizontal_padding = 15;
        text_icon_padding = 0;
        frame_width = 2;
        frame_color = "#0f0f0f";
        transparency = 30;
        notification_limit = 0;
        separator_height = 2;
        separator_color = "auto";
        sort = "yes";
        idle_threshold = 120;
        font = "${fonts.mono} 16";
        line_height = 0;
        markup = "full";
        format = ''<b>%s</b>\n<span size="small">%b</span>'';
        alignment = "center";
        vertical_alignment = "center";
        show_age_threshold = 60;
        ellipsize = "end";
        ignore_newline = "no";
        stack_duplicates = true;
        hide_duplicate_count = false;
        show_indicators = "yes";
        icon_position = "left";
        min_icon_size = 32;
        max_icon_size = 64;
        icon_corner_radius = 10;
        enable_recursive_icon_lookup = true;
        sticky_history = "yes";
        history_length = 20;
        dmenu = "${pkgs.dmenu}/bin/dmenu -p dunst";
        always_run_script = true;
        title = "Dunst";
        class = "Dunst";
        corner_radius = 10;
        ignore_dbusclose = false;
        # only Wayland
        layer = "top";
        force_xwayland = false;
        force_xinerama = false;
        mouse_left_click = "close_current";
        mouse_middle_click = "context";
        mouse_right_click = "do_action";
      };
      urgency_low = {
        foreground = "#F1F0F5";
        background = "#111019";
        frame_color = "#0B0A10";
        timeout = 3;
        highlight = "#AAC5A0";
      };
      urgency_normal = {
        foreground = "#F1F0F5";
        background = "#111019";
        frame_color = "#0B0A10";
        timeout = 5;
        highlight = "#A8C5E6";
      };
      urgency_critical = {
        background = "#111019";
        foreground = "#F1F0F5";
        frame_color = "#0B0A10";
        timeout = 10;
      };
    };
  };
}
