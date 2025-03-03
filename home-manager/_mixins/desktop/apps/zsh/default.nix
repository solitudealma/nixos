{
  config,
  pkgs,
  ...
}: let
  inherit (config._custom.globals) configDirectory;
in {
  home = {
    file.".zshenv".text = ''
      ZDOTDIR="$HOME/.config/zsh"
    '';
    packages = with pkgs; [
    ];
  };
  programs = {
    atuin = {
      enable = true;
      flags = ["--disable-up-arrow"];
      package = pkgs.atuin;
      settings = {
        auto_sync = true;
        dialect = "us";
        #key_path = config.sops.secrets.atuin_key.path;
        show_preview = true;
        style = "compact";
        sync_frequency = "1h";
        sync_address = "https://api.atuin.sh";
        update_check = false;
      };
    };
    bat = {
      enable = true;
      extraPackages = with pkgs.bat-extras; [
        batgrep
        batpipe
        batwatch
        prettybat
      ];
      config = {
        pager = "less -FR";
        style = "plain";
        theme = "gruvbox-dark";
      };
    };
    dircolors = {
      enable = true;
    };
    direnv = {
      enable = true;
      nix-direnv = {
        enable = true;
      };
    };
    eza = {
      enable = true;
      extraOptions = [
        "--group-directories-first"
        "--header"
      ];
      git = true;
      icons = "auto";
    };
    fzf = {
      changeDirWidgetCommand = "fd --type=d --hidden --strip-cwd-prefix --exclude .git";
      changeDirWidgetOptions = ["--preview 'eza --tree --color=always {} | head -200'"];
      defaultCommand = "fd --hidden --strip-cwd-prefix --exclude .git";
      ## Theme
      defaultOptions = [
        "--color=fg:-1,fg+:#FBF1C7,bg:-1,bg+:#282828"
        "--color=hl:#98971A,hl+:#B8BB26,info:#928374,marker:#D65D0E"
        "--color=prompt:#CC241D,spinner:#689D6A,pointer:#D65D0E,header:#458588"
        "--color=border:#665C54,label:#aeaeae,query:#FBF1C7"
        "--border='rounded' --border-label='' --preview-window='border-rounded' --prompt='> '"
        "--marker='>' --pointer='>' --separator='─' --scrollbar='│'"
        "--info='right'"
      ];
      enable = true;
      fileWidgetOptions = ["--preview 'if [ -d {} ]; then eza --tree --color=always {} | head -200; else bat -n --color=always --line-range :500 {}; fi'"];
    };
    ripgrep = {
      arguments = [
        "--colors=line:style:bold"
        "--max-columns-preview"
        "--smart-case"
      ];
      enable = true;
    };
    starship = {
      enable = true;
    };
    zoxide = {
      enable = true;
      enableBashIntegration = true;
      # Replace cd with z and add cdi to access zi
      options = ["--cmd cd"];
    };
  };
  xdg.configFile."zsh".source = config.lib.file.mkOutOfStoreSymlink "${configDirectory}/home-manager/_mixins/configs/zsh";
}
