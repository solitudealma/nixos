{
  config,
  inputs,
  pkgs,
  ...
}: let
  inherit (config._custom.globals) configDirectory;
  yazi-plugins = pkgs.fetchFromGitHub {
    owner = "yazi-rs";
    repo = "plugins";
    rev = "71c4fc2e6fa1d6f70c85bf525842d6888d1ffa46";
    hash = "";
  };
in {
  nixpkgs.overlays = [inputs.yazi.overlays.default];
  home = {
    packages = with pkgs; [
      eog
      feh
      foliate
      ouch
    ];
  };

  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
    # package = inputs.yazi.packages.${pkgs.system}.default;
    # plugins = {
    #   arrow-parent = ./plugins/arrow-parent.yazi;
    #   autofilter = pkgs.fetchFromGitHub {
    #     owner = "DreamMaoMao";
    #     repo = "autofilter.yazi";
    #     rev = "6ecc3ea5596fe445381e94a4fc51fc022ee5f9fa";
    #     sha256 = "sha256-hoI5c2LrNmImAYRrLu96SVw2r9WeklY1pYaCHOaYJ0g=";
    #   };
    #   autosort = pkgs.fetchgit {
    #     url = "https://gitee.com/DreamMaoMao/autosort.yazi";
    #     rev = "e74985299eb6470b971ed15eb8c4e2db51d5d6e0";
    #     sha256 = "sha256-C+oCasP/1E3D3ycP0l8WNF4/tgHFUS6r8DwFUaM+YBw=";
    #   };
    #   bookmarks = pkgs.fetchFromGitHub {
    #     owner = "DreamMaoMao";
    #     repo = "bookmarks.yazi";
    #     rev = "83580203c014ad48834af51ee6a11767511a25a6";
    #     sha256 = "sha256-TfOdLAs7ljLl5WmCsmP4o6JCQqUtvSdZgn+O9QKjTV4=";
    #   };
    #   cd-last = ./plugins/cd-last.yazi;
    #   clipboard = pkgs.fetchFromGitHub {
    #     owner = "DreamMaoMao";
    #     repo = "clipboard.yazi";
    #     rev = "93b73d41e17f3342dab36c4280ec16d1afc7f40e";
    #     sha256 = "sha256-yeKh0uQBrkqls4D28xKKyq1MF5LpleZW0/uxFWf1tQw=";
    #   };
    #   cmd = ./plugins/cmd.yazi;
    #   current-size = pkgs.fetchgit {
    #     url = "https://gitee.com/DreamMaoMao/current-size.yazi";
    #     rev = "465b578a16c386d9f290ed727e362ad8a869109f";
    #     sha256 = "sha256-MRTRuYq8oTv1MZBQWzzNrboo0Jve7pQenEEKGRuVPEQ=";
    #   };
    #   disable = ./plugins/disable.yazi;
    #   easyjump = pkgs.fetchFromGitHub {
    #     owner = "DreamMaoMao";
    #     repo = "easyjump.yazi";
    #     rev = "964aaf807d00617027cbc23f71ce58151e0451b1";
    #     sha256 = "sha256-uNrZ5kTzwl8Ec/pftrnlljVN306DCUZUUggOtAxVf+k=";
    #   };
    #   epub-preview = pkgs.fetchFromGitHub {
    #     owner = "kirasok";
    #     repo = "epub-preview.yazi";
    #     rev = "77a76b8dc36c52b8713bd3745456d096732be7bd";
    #     sha256 = "sha256-Ig0sUamVUmveOm0EuCBE2hzk53LdDVjUg7Ij0CnnDmE=";
    #   };
    #   fg = pkgs.fetchFromGitHub {
    #     owner = "DreamMaoMao";
    #     repo = "fg.yazi";
    #     rev = "69576ef43b3f350d49b0467efb1ff15af66eb177";
    #     sha256 = "sha256-G6QL4IcbB+EvMWQaiuDIi5gi+zTNLqhCrYFR3GNeSJo=";
    #   };
    #   full-border = ./plugins/full-border.yazi;
    #   git = pkgs.fetchFromGitHub {
    #     owner = "DreamMaoMao";
    #     repo = "git.yazi";
    #     rev = "6ee2aac2782d4094beb919906840ce150149a3aa";
    #     sha256 = "sha256-bgbQPsfL3QzxMmoA99eEN29t9EFoi3Sy+Yc6FtZ4Fkg=";
    #   };
    #   glow = pkgs.fetchFromGitHub {
    #     owner = "Reledia";
    #     repo = "glow.yazi";
    #     rev = "5ce76dc92ddd0dcef36e76c0986919fda3db3cf5";
    #     sha256 = "sha256-UljcrXXO5DZbufRfavBkiNV3IGUNct31RxCujRzC9D4=";
    #   };
    #   header-hidden = ./plugins/header-hidden.yazi;
    #   header-host = ./plugins/header-host.yazi;
    #   html = ./plugins/html.yazi;
    #   keyjump = pkgs.fetchFromGitHub {
    #     owner = "DreamMaoMao";
    #     repo = "keyjump.yazi";
    #     rev = "4fb2bc3ae51993c7196b32bc781b5c5d0ae1e437";
    #     sha256 = "sha256-NZDPaqCoq5MGBocTxnNHR2MSi7y1RIi2j2+rL+7M/jI=";
    #   };
    #   lastopen = pkgs.fetchFromGitHub {
    #     owner = "DreamMaoMao";
    #     repo = "lastopen.yazi";
    #     rev = "d7be71bcd2cef4698696a413d6681ce302d2b334";
    #     sha256 = "sha256-xGxGE/Nz/8jX9lCk9ROafNDH2zyPoUKWrMJ7rLzDu8A=";
    #   };
    #   mime-ext = pkgs.fetchFromGitHub {
    #     owner = "DreamMaoMao";
    #     repo = "mime-ext.yazi";
    #     rev = "47b5f85b0b6156f689641132eb9d29f7301b9b6a";
    #     sha256 = "sha256-+hxHKEhvpvHcTrb56BY7cuvzKYO3ywbvdY4dmPQR4pU=";
    #   };
    #   mime-preview = pkgs.fetchFromGitHub {
    #     owner = "DreamMaoMao";
    #     repo = "mime-preview.yazi";
    #     rev = "acd59e2e9fb8f6ad31b549e57ddc2985113b8f56";
    #     sha256 = "sha256-yH7yDPwoedPiqf4lbIUk/99j+Lwrj9qgsrq2Rh03tVA=";
    #   };
    #   mount = ./plugins/mount.yazi;
    #   searchjump = pkgs.fetchFromGitHub {
    #     owner = "DreamMaoMao";
    #     repo = "searchjump.yazi";
    #     rev = "b88b072299834ea1ec62c4c6bfb9998aca2d2671";
    #     sha256 = "sha256-ltkF0h3SwKWW+p2rISIgxHIQt2CmyTt9Nrrjfcu8ZSM=";
    #   };
    #   status-mtime = ./plugins/status-mtime.yazi;
    #   status-owner = ./plugins/status-owner.yazi;
    # };
    shellWrapperName = "y";
  };

  xdg.configFile."yazi/init.lua".source = config.lib.file.mkOutOfStoreSymlink "${configDirectory}/home-manager/_mixins/configs/yazi/init.lua";
  xdg.configFile."yazi/yazi.toml".source = config.lib.file.mkOutOfStoreSymlink "${configDirectory}/home-manager/_mixins/configs/yazi/yazi.toml";
  xdg.configFile."yazi/theme.toml".source = config.lib.file.mkOutOfStoreSymlink "${configDirectory}/home-manager/_mixins/configs/yazi/theme.toml";
  xdg.configFile."yazi/keymap.toml".source = config.lib.file.mkOutOfStoreSymlink "${configDirectory}/home-manager/_mixins/configs/yazi/keymap.toml";
}
