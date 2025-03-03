{
  config,
  pkgs,
  username,
  ...
}: {
  programs = {
    carapace.enable = true;
    carapace.enableNushellIntegration = true;

    nushell = {
      enable = true;

      plugins = with pkgs.nushellPlugins; [
        # skim
        query
        gstat
        polars
      ];

      extraConfig = let
        conf = builtins.toJSON {
          show_banner = false;
          edit_mode = "vi";
          error_style = "fancy";
          ls = {
            clickable_links = true;
            use_ls_colors = true;
          };
          rm.always_trash = true;
          history = {
            max_size = 100000; # Session has to be reloaded for this to take effect
            sync_on_enter = true; # Enable to share history between multiple sessions, else you have to close the session to write history to file
            file_format = "plaintext"; # "sqlite" or "plaintext"
            isolation = false; # only available with sqlite file_format. true enables history isolation, false disables it. true will allow the history to be isolated to the current session using up/down arrows. false will allow the history to be shared across all sessions.
          };
          explore = {
            status_bar_background = {
              fg = "#1D1F21";
              bg = "#C4C9C6";
            };
            command_bar_text = {fg = "#C4C9C6";};
            highlight = {
              fg = "black";
              bg = "yellow";
            };
            status = {
              error = {
                fg = "white";
                bg = "red";
              };
              warn = {};
              info = {};
            };
            selected_cell = {bg = "light_blue";};
          };
          table = {
            mode = "rounded";
            index_mode = "always";
            header_on_separator = false;
            show_empty = true;
            padding = {
              left = 1;
              right = 1;
            };
            trim = {
              methodology = "wrapping"; # wrapping or truncating
              wrapping_try_keep_words = true; # A strategy used by the 'wrapping' methodology
              truncating_suffix = "..."; # A suffix used by the 'truncating' methodology
            };
          };
          cursor_shape = {
            vi_insert = "line";
            vi_normal = "block";
          };

          display_errors = {
            exit_code = false;
          };

          menus = [
            {
              name = "completion_menu";
              only_buffer_difference = false;
              marker = "? ";
              type = {
                layout = "columnar"; # list, description
                columns = 4;
                col_padding = 2;
              };
              style = {
                text = "magenta";
                selected_text = "blue_reverse";
                description_text = "yellow";
              };
            }
          ];
        };
        completions = let
          completion = name: ''
            source ${pkgs.nu_scripts}/share/nu_scripts/custom-completions/${name}/${name}-completions.nu
          '';
        in
          names:
            builtins.foldl'
            (prev: str: "${prev}\n${str}") ""
            (map completion names);
      in ''
        $env.config = ${conf};

        ${completions ["git" "nix" "man" "rg"]}

        # use ${pkgs.nu_scripts}/share/nu_scripts/modules/background_task/task.nu
        source ${pkgs.nu_scripts}/share/nu_scripts/modules/formats/from-env.nu

        # const path = "~/.nushellrc.nu"
        # const null = "/dev/null"
        # source (if ($path | path exists) {
        #     $path
        # } else {
        #     $null
        # })

        def fcd [] {
          let dir = (fd --type d | sk | str trim)
          if ($dir != "") {
            cd $dir
          }
        }

        def installed [] {
          nix-store --query --requisites /run/current-system/ | parse --regex '.*?-(.*)' | get capture0 | sk
        }

        def installedall [] {
          nix-store --query --requisites /run/current-system/ | sk | wl-copy
        }

        def search [term: string] {
          nix search nixpkgs --json $term | from json | values | select pname description
        }

        def homesearch [program: string] {
          http get https://raw.githubusercontent.com/mipmip/home-manager-option-search/refs/heads/main/static/data/options-release-24.11.json
          | get options
          | where { |opt|
            $opt.title =~ $program or ($opt.declarations | any { |decl| $decl.name =~ $program })
          }
          | each { |option|
            let type_info = if ($option.type | is-empty) { "No type info" } else { $option.type }
            let default_info = if ($option.default | is-empty) { "null" } else { $option.default }
            let description = if ($option.description | is-empty) { "No description" } else { $option.description }

            {
              title: $option.title,
              type: $type_info,
              description: $description,
              default: $default_info,
              files: ($option.declarations | each { |d| $d.name } | str join ", ")
            }
          }
        }
      '';

      shellAliases = {
        cleanup = "sudo nix-collect-garbage --delete-older-than 1d";
        listgen = "sudo nix-env -p /nix/var/nix/profiles/system --list-generations";
        nixremove = "nix-store --gc";
        bloat = "nix path-info -Sh /run/current-system";
        c = "clear";
        q = "exit";
        cleanram = "sudo sh -c 'sync; echo 3 > /proc/sys/vm/drop_caches'";
        trimall = "sudo fstrim -va";
        temp = "cd /tmp/";
        zed = "zeditor";

        # git
        g = "git";
        add = "git add .";
        commit = "git commit";
        push = "git push";
        pull = "git pull";
        diff = "git diff --staged";
        gcld = "git clone --depth 1";
        gco = "git checkout";
        gitgrep = "git ls-files | rg";
        # gitrm = "git ls-files --deleted -z | xargs -0 git rm";

        # cat = "bat --theme=base16 --number --color=always --paging=never --tabs=2 --wrap=never";
        fcd = "cd (fd --type d | sk | str trim)";
        grep = "rg";
        l = "eza -lF --time-style=long-iso --icons";
        # la = "eza -lah --tree";
        # ls = "eza -h --git --icons --color=auto --group-directories-first -s extension";
        ll = "eza -h --git --icons --color=auto --group-directories-first -s extension";
        tree = "eza --tree --icons --tree";

        # systemctl
        us = "systemctl --user";
        rs = "sudo systemctl";
      };

      environmentVariables = {
        SHELL = "${pkgs.nushell}/bin/nu";
      };
      envFile.text = ''
        def create_left_prompt [] {
            let dir = match (do --ignore-errors { $env.PWD | path relative-to $nu.home-path }) {
                null => $env.PWD
                '''''' => '~'
                $relative_pwd => ([~ $relative_pwd] | path join)
            }

            let path_color = (if (is-admin) { ansi red_bold } else { ansi green_bold })
            let separator_color = (if (is-admin) { ansi light_red_bold } else { ansi light_green_bold })
            let path_segment = $"($path_color)($dir)"

            $path_segment | str replace --all (char path_sep) $"($separator_color)(char path_sep)($path_color)"
        }

        $env.PROMPT_COMMAND = {|| create_left_prompt }
        $env.PROMPT_COMMAND_RIGHT = {||}
        $env.PROMPT_INDICATOR_VI_INSERT = {|| ": " }
        $env.PROMPT_INDICATOR_VI_NORMAL = {|| "> " }
        $env.PROMPT_MULTILINE_INDICATOR = {|| "::: " }
        $env.PATH = ($env.PATH | split row (char esep)
          | append "/usr/local/bin"
          | append "${config.home.homeDirectory}/.nix-profile/bin"
          | append "/usr/local/bin"
          | append "/run/current-system/sw/bin"
          | append "/etc/profiles/per-user/${username}/bin")
      '';
    };
  };
}
