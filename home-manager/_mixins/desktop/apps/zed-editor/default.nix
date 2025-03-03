{
  config,
  lib,
  pkgs,
  username,
  ...
}: let
  inherit (pkgs.stdenv) isLinux;
  inherit (lib) mkDefault;
  inherit (config._custom.globals) fonts;
  installFor = ["solitudealma"];
in
  lib.mkIf (lib.elem username installFor && isLinux) {
    programs.zed-editor = {
      enable = true;
      userSettings = {
        auto_update = mkDefault false;

        buffer_font_size = mkDefault 20;
        buffer_font_family = mkDefault "${fonts.mono}";

        confirm_quit = mkDefault false;
        file_scan_exclusions = [
          "**/.git"
          "**/.svn"
          "**/.hg"
          "**/CVS"
          "**/.DS_Store"
          "**/Thumbs.db"
          "**/.classpath"
          "**/.settings"
          "**/vendor"
          "**/.tmp*"
        ];
        features = {
          copilot = mkDefault false;
        };

        indent_guides = {
          coloring = "indent_aware";
        };
        inlay_hints = {
          enabled = true;
          font_family = "Consolas";
        };
        languages = {
          "C++" = {
            formatter = {
              external = {
                command = "clang-format";
                arguments = ["-style={BasedOnStyle: Google, IndentWidth: 2}"];
              };
            };
          };
          Go = {
            code_actions_on_format = {
              "source.organizeImports" = true;
            };
          };
          JavaScript = {
            formatter = {
              external = {
                command = "prettier";
                arguments = ["--stdin-filepath" "{buffer_path}" "--tab-width" "2"];
              };
            };
            code_actions_on_format = {
              "source.fixAll.eslint" = true;
            };
          };
          Luau = {
            formatter = {
              external = {
                command = "stylua";
                arguments = ["-"];
              };
            };
          };
          Markdown = {
            enable_language_server = false;
          };
          Nix = {
            formatter = {
              external = {
                command = "${lib.getExe pkgs.alejandra}";
              };
            };
            language_servers = ["nixd" "!nil"];
          };
          Rust = {
            tab_size = 2;
          };
          TSX = {
            formatter = {
              external = {
                command = "prettier";
                arguments = ["--stdin-filepath" "{buffer_path}" "--tab-width" "2"];
              };
            };
            code_actions_on_format = {
              "source.organizeImports" = true;
              "source.fixAll.eslint" = true;
            };
          };
          TypeScript = {
            formatter = {
              external = {
                command = "prettier";
                arguments = ["--stdin-filepath" "{buffer_path}" "--tab-width" "2"];
              };
            };
            code_actions_on_format = {
              "source.organizeImports" = true;
              "source.fixAll.eslint" = true;
            };
          };
        };

        lsp = {
          eslint = {
            settings = {
              codeActionOnSave = {
                rules = ["import/order"];
              };
            };
          };
          nixd = {
            settings = {
              diagnostic = {
                suppress = ["sema-extra-with"];
              };
            };
          };
          rust-analyzer = {
            initialization_options = {
              checkOnSave = {
                # rust-analyzer.check.command (default: "check")
                command = "clippy";
              };
            };
          };
        };
        search.exclude = {
          "**/*.snap" = true;
          "**/.git" = true;
          "**/.github" = false;
          "**/.nuxt" = true;
          "**/.output" = true;
          "**/.pnpm" = true;
          "**/.vscode" = true;
          "**/.yarn" = true;
          "**/node_modules" = true;
          "**/out/**" = true;
          "**/package-lock.json" = true;
          "**/pnpm-lock.yaml" = true;
          "**/temp" = true;
          "**/yarn.lock" = true;
          "**/CHANGELOG*" = true;
          "**/LICENSE*" = true;
        };
        tabs = {
          close_position = mkDefault "right";
          file_icons = mkDefault true;
          git_status = mkDefault true;
          activate_on_close = mkDefault "history";
        };
        tab_size = mkDefault 2;
        telemetry = {
          diagnostics = false;
          metrics = false;
        };
        terminal = {
          copy_on_select = true;
          env = {
            TERM = "xterm-256color";
          };
          font_family = mkDefault "${fonts.mono}";
          font_size = mkDefault 18;
        };
        theme = {
          mode = "system";
          light = "Base16 Everforest";
          dark = "Base16 Everforest Dark Hard";
        };

        ui_font_size = mkDefault 22;
        ui_font_family = mkDefault "${fonts.mono}";

        vim_mode = mkDefault false;
      };

      extensions = ["base16" "fish" "nix" "lua" "toml"];

      # unstable options
      #extraPackages = with pkgs; [
      #  nixd
      #];
      userKeymaps = [
        {
          bindings = {
            ctrl-shift-p = "command_palette::Toggle";
            ctrl-shift-k = "zed::OpenKeymap";
            ctrl-shift-x = "zed::Extensions";
            f11 = "zed::ToggleFullScreen";
            ctrl-alt-n = "task::Spawn";
            ctrl-alt-r = "task::Rerun";
            # ctrl-alt-o = "zed::OpenLocalTasks";
            "ctrl-\\" = "workspace::NewCenterTerminal";
            ctrl-t = "terminal_panel::ToggleFocus";
          };
        }
        {
          context = "Workspace";
          bindings = {
            "shift shift" = "workspace::NewSearch";
          };
        }
        {
          context = "Editor";
          bindings = {
            ctrl-a = "editor::SelectAll";
            ctrl-w = "pane::CloseActiveItem";
            alt-enter = "editor::ToggleCodeActions";
          };
        }
        {
          context = "Editor && VimControl && !VimWaiting && !menu";
          bindings = {
            H = "pane::ActivatePrevItem";
            L = "pane::ActivateNextItem";
            K = "editor::Hover";
            "g h" = "editor::MoveToBeginningOfLine";
            "g l" = "editor::MoveToEndOfLine";
            "g b" = "pane::GoBack";
            "g r" = "editor::GoToTypeDefinition";
            "g i" = "editor::GoToImplementation";
            "space c f" = "editor::Format";
            "space c r" = "editor::Rename";
            "space e" = "project_panel::ToggleFocus";
            "space f o" = "outline::Toggle";
            "space f p" = "projects::OpenRecent";
            "space f q" = "file_finder::Toggle";
            "space g [" = "editor::GoToPrevHunk";
            "space g ]" = "editor::GoToHunk";
            "space g b" = "editor::ToggleGitBlame";
            "space g d" = "editor::ToggleHunkDiff";
            "space g r" = "editor::RevertSelectedHunks";
            "space m o" = "markdown::OpenPreview";
            "space m p" = "markdown::OpenPreviewToTheSide";
            "space o" = "tab_switcher::Toggle";
            "space p d" = "diagnostics::Deploy";
            "space w c" = "pane::CloseAllItems";
            "space w k" = "pane::SplitUp";
            "space w j" = "pane::SplitDown";
            "space w h" = "pane::SplitLeft";
            "space w l" = "pane::SplitRight";
          };
        }
        {
          context = "ProjectPanel && not_editing";
          bindings = {
            j = "menu::SelectNext";
            k = "menu::SelectPrev";
            a = "project_panel::NewFile";
            A = "project_panel::NewDirectory";
            c = "project_panel::Copy";
            d = "project_panel::Delete";
            p = "project_panel::Paste";
            r = "project_panel::Rename";
            x = "project_panel::Cut";
            "y p" = "project_panel::CopyPath";
            "y r" = "project_panel::CopyRelativePath";
          };
        }
        {
          context = "Dock || Terminal || Editor";
          bindings = {
            ctrl-h = ["workspace::ActivatePaneInDirection" "Left"];
            ctrl-l = ["workspace::ActivatePaneInDirection" "Right"];
            ctrl-k = ["workspace::ActivatePaneInDirection" "Up"];
            ctrl-j = ["workspace::ActivatePaneInDirection" "Down"];
          };
        }
        {
          context = "Terminal";
          bindings = {
            ctrl-t = "workspace::ToggleBottomDock";
          };
        }
      ];
    };

    xdg.configFile."zed" = {
      source = ../../../configs/zed;
      recursive = true; # 递归整个文件夹
    };
  }
