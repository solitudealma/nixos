{
  inputs,
  lib,
  pkgs,
  username,
  ...
}: let
  installFor = ["solitudealma"];
  inherit (pkgs.stdenv) isLinux;
in
  lib.mkIf (lib.elem username installFor) {
    # NOTE! I avoid using home-manager to configure settings.json because it
    #       makes it settings.json immutable. I prefer to use the Code settings
    #       sync extension to sync across machines.
    programs = {
      vscode = {
        enable = true;
        profiles.default.extensions = with pkgs;
          [
            vscode-marketplace.aaron-bond.better-comments
            vscode-marketplace.alefragnani.project-manager
            vscode-marketplace.alexgb.nelua
            vscode-marketplace.bmalehorn.shell-syntax
            # vscode-marketplace.bmalehorn.vscode-fish
            vscode-marketplace.budparr.language-hugo-vscode
            vscode-marketplace.codezombiech.gitignore
            # vscode-marketplace.continue.continue
            vscode-marketplace.coolbear.systemd-unit-file
            vscode-marketplace.dart-code.dart-code
            vscode-marketplace.dart-code.flutter
            vscode-marketplace.dotjoshjohnson.xml
            vscode-marketplace.editorconfig.editorconfig
            vscode-marketplace.eliostruyf.vscode-front-matter
            vscode-marketplace.esbenp.prettier-vscode
            vscode-marketplace.evan-buss.font-switcher
            vscode-marketplace.fill-labs.dependi
            vscode-marketplace.foxundermoon.shell-format
            # vscode-marketplace.github.copilot
            # vscode-marketplace.github.copilot-chat
            vscode-marketplace.github.vscode-github-actions
            vscode-marketplace.github.vscode-pull-request-github
            vscode-marketplace.golang.go
            vscode-marketplace.griimick.vhs
            vscode-marketplace.hoovercj.vscode-power-mode
            vscode-marketplace.jdemille.debian-control-vscode
            vscode-marketplace.jeff-hykin.better-csv-syntax
            vscode-marketplace.jeff-hykin.better-dockerfile-syntax
            vscode-marketplace.jeff-hykin.better-nix-syntax
            vscode-marketplace.jeff-hykin.better-shellscript-syntax
            vscode-marketplace.jeff-hykin.polacode-2019
            vscode-marketplace.jeroen-meijer.pubspec-assist
            vscode-marketplace.jonathanharty.gruvbox-material-icon-theme
            vscode-marketplace.jnoortheen.nix-ide
            vscode-marketplace.kamadorueda.alejandra
            vscode-marketplace.mads-hartmann.bash-ide-vscode
            # vscode-marketplace.marp-team.marp-vscode
            vscode-marketplace.mechatroner.rainbow-csv
            vscode-marketplace.mkhl.direnv
            # vscode-marketplace.ms-python.debugpy
            vscode-marketplace.ms-python.python
            # vscode-marketplace.ms-python.vscode-pylance
            vscode-marketplace.ms-vscode.cmake-tools
            vscode-marketplace.ms-vscode.hexeditor
            # vscode-marketplace.ms-vscode-remote.remote-ssh
            vscode-marketplace.nico-castell.linux-desktop-file
            vscode-marketplace.pixelbyte-studios.pixelbyte-love2d
            vscode-marketplace.pkief.material-product-icons
            vscode-marketplace.pollywoggames.pico8-ls
            vscode-marketplace.prince781.vala
            vscode-marketplace.redhat.vscode-yaml
            vscode-marketplace.rogalmic.bash-debug
            vscode-marketplace.rust-lang.rust-analyzer
            vscode-marketplace.ryu1kn.partial-diff
            vscode-marketplace.s3anmorrow.openwithkraken
            vscode-marketplace.sanjulaganepola.github-local-actions
            # vscode-marketplace.saoudrizwan.claude-dev
            vscode-marketplace.slevesque.shader
            vscode-marketplace.sainnhe.everforest
            vscode-marketplace.streetsidesoftware.code-spell-checker
            # vscode-marketplace.sumneko.lua
            vscode-marketplace.tamasfe.even-better-toml
            vscode-marketplace.timonwong.shellcheck
            vscode-marketplace.tomblind.local-lua-debugger-vscode
            vscode-marketplace.trond-snekvik.simple-rst
            vscode-marketplace.twxs.cmake
            vscode-marketplace.unifiedjs.vscode-mdx
            vscode-marketplace.viktorzetterstrom.non-breaking-space-highlighter
            vscode-marketplace.vscode-icons-team.vscode-icons
            vscode-marketplace.xyc.vscode-mdx-preview
            vscode-marketplace.yzhang.markdown-all-in-one
          ]
          ++ lib.optionals isLinux [
            vscode-extensions.ms-vscode.cpptools-extension-pack
            vscode-marketplace.ms-vsliveshare.vsliveshare
            vscode-marketplace.vadimcn.vscode-lldb
          ];
        mutableExtensionsDir = true;
        package = pkgs.vscode;
      };
    };
  }
