{config, ...}: {
  programs.zsh = {
    enable = true;
    initExtraFirst = ''
      source ~/.config/omz/omz.zsh
    '';
  };
  xdg.configFile."omz".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/omz";
}
