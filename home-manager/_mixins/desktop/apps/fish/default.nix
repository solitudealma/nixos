{
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./tide.nix
  ];

  home = {
    packages = with pkgs; [
      lla
      (pkgs.writeShellScriptBin "xterm" ''
        handlr launch x-scheme-handler/terminal -- "$@"
      '')
      # (pkgs.writeShellScriptBin "xdg-open" ''
      #   handlr open "$@"
      # '')
    ];
  };
  programs = {
    fish = {
      enable = true;
      functions = {
        # Disable greeting
        fish_greeting = "";
        # Merge history when pressing up
        up-or-search = lib.readFile ./up-or-search.fish;
        y = {
          body = ''
            set -l tmp (mktemp -t "yazi-cwd.XXXXX")
            command yazi $argv --cwd-file="$tmp"
            if set cwd (cat -- "$tmp"); and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
                builtin cd -- "$cwd"
            end
            rm -f -- "$tmp"
          '';
        };
      };
      interactiveShellInit = ''
        # Open command buffer in editor when alt+e is pressed
        bind \ee edit_command_buffer

        # Use terminal colors
        set -x fish_color_autosuggestion      brblack
        set -x fish_color_cancel              -r
        set -x fish_color_command             brgreen
        set -x fish_color_comment             brmagenta
        set -x fish_color_cwd                 green
        set -x fish_color_cwd_root            red
        set -x fish_color_end                 brmagenta
        set -x fish_color_error               brred
        set -x fish_color_escape              brcyan
        set -x fish_color_history_current     --bold
        set -x fish_color_host                normal
        set -x fish_color_host_remote         yellow
        set -x fish_color_match               --background=brblue
        set -x fish_color_normal              normal
        set -x fish_color_operator            cyan
        set -x fish_color_param               brblue
        set -x fish_color_quote               yellow
        set -x fish_color_redirection         bryellow
        set -x fish_color_search_match        'bryellow' '--background=brblack'
        set -x fish_color_selection           'white' '--bold' '--background=brblack'
        set -x fish_color_status              red
        set -x fish_color_user                brgreen
        set -x fish_color_valid_path          --underline
        set -x fish_pager_color_completion    normal
        set -x fish_pager_color_description   yellow
        set -x fish_pager_color_prefix        'white' '--bold' '--underline'
        set -x fish_pager_color_progress      'brwhite' '--background=cyan'
      '';
      shellAbbrs = {
        ls = "lla";
      };
    };
  };
}
