{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  nvimPath = "${config.home.homeDirectory}/nvim";
in {
  home = {
    packages = with pkgs; (
      [
        #markdown preview
        wyeb

        vim-language-server
        vscode-langservers-extracted

        nur.repos.dustinblackman.oatmeal
      ]
      ++
      # -*- Data & Configuration Languages -*-#
      [
        #-- nix
        inputs.nixd.packages.${pkgs.system}.nixd
        statix # Lints and suggestions for the nix programming language
        deadnix # Find and remove unused code in .nix source files
        alejandra # Nix Code Formatter

        #-- nickel lang
        nickel

        #-- json like
        # terraform  # install via brew on macOS
        terraform-ls
        jsonnet
        jsonnet-language-server
        taplo # TOML language server / formatter / validator
        nodePackages.yaml-language-server
        actionlint # GitHub Actions linter

        #-- dockerfile
        hadolint # Dockerfile linter
        nodePackages.dockerfile-language-server-nodejs

        #-- markdown
        marksman # language server for markdown
        glow # markdown previewer
        pandoc # document converter
        hugo # static site generator

        #-- sql
        sqlfluff

        #-- protocol buffer
        buf # linting and formatting
      ]
      ++
      #-*- General Purpose Languages -*-#
      [
        #-- c/c++
        cmake
        cmake-language-server
        gnumake
        checkmake
        # c/c++ compiler, required by nvim-treesitter!
        gcc
        gdb
        # c/c++ tools with clang-tools, the unwrapped version won't
        # add alias like `cc` and `c++`, so that it won't conflict with gcc
        # llvmPackages.clang-unwrapped
        clang-tools
        lldb
        vscode-extensions.vadimcn.vscode-lldb.adapter # codelldb - debugger

        #-- python
        pyright # python language server
        (python311.withPackages (
          ps:
            with ps; [
              ruff-lsp
              black # python formatter
              # debugpy

              # my commonly used python packages
              jupyter
              ipython
              pandas
              requests
              pyquery
              pyyaml
              boto3

              ## emacs's lsp-bridge dependenciesge
              # epc
              # orjson
              # sexpdata
              # six
              # setuptools
              # paramiko
              # rapidfuzz
            ]
        ))

        #-- rust
        # we'd better use the rust-overlays for rust development
        rustc
        rust-analyzer
        cargo # rust package manager
        rustfmt
        clippy # rust linter

        #-- golang
        go
        gomodifytags
        iferr # generate error handling code for go
        impl # generate function implementation for go
        gotools # contains tools like: godoc, goimports, etc.
        gopls # go language server
        delve # go debugger

        # -- java
        jdk17
        gradle
        maven
        spring-boot-cli
        jdt-language-server

        #-- zig
        zls

        #-- lua
        stylua
        lua-language-server

        #-- bash
        nodePackages.bash-language-server
        shellcheck
        shfmt
      ]
      #-*- Web Development -*-#
      ++ [
        nodePackages.nodejs
        nodePackages.typescript
        nodePackages.typescript-language-server
        # HTML/CSS/JSON/ESLint language servers extracted from vscode
        nodePackages.vscode-langservers-extracted
        nodePackages."@tailwindcss/language-server"
        emmet-ls
      ]
      # -*- Lisp like Languages -*-#
      ++ [
        guile
        racket-minimal
        fnlfmt # fennel
        (
          if pkgs.stdenv.isDarwin
          then pkgs.emptyDirectory
          else akkuPackages.scheme-langserver
        )
      ]
      ++ [
        proselint # English prose linter

        #-- verilog / systemverilog
        verible

        #-- Optional Requirements:
        nodePackages.prettier # common code formatter
        fzf
        gdu # disk usage analyzer, required by AstroNvim
        (ripgrep.override {withPCRE2 = true;}) # recursively searches directories for a regex pattern
      ]
    );
    shellAliases = {
      v = "nvim";
      vdiff = "nvim -d";
    };
  };

  programs.neovim = {
    defaultEditor = true;
    enable = true;
    # These environment variables are needed to build and run binaries
    # with external package managers like mason.nvim.
    #
    # LD_LIBRARY_PATH is also needed to run the non-FHS binaries downloaded by mason.nvim.
    # it will be set by nix-ld, so we do not need to set it here again.
    extraWrapperArgs = with pkgs; [
      # LIBRARY_PATH is used by gcc before compilation to search directories
      # containing static and shared libraries that need to be linked to your program.
      "--suffix"
      "LIBRARY_PATH"
      ":"
      "${lib.makeLibraryPath [stdenv.cc.cc zlib]}"

      # PKG_CONFIG_PATH is used by pkg-config before compilation to search directories
      # containing .pc files that describe the libraries that need to be linked to your program.
      "--suffix"
      "PKG_CONFIG_PATH"
      ":"
      "${lib.makeSearchPathOutput "dev" "lib/pkgconfig" [stdenv.cc.cc zlib]}"
    ];
    package = pkgs.neovim-unwrapped;
    viAlias = true;
    vimAlias = true;
    withNodeJs = true;
    withPython3 = true;
  };

  xdg.configFile."nvim".source = config.lib.file.mkOutOfStoreSymlink nvimPath;
}
