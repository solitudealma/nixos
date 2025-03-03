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
    rev = "5186af7984aa8cb0550358aefe751201d7a6b5a8";
    hash = "sha256-Cw5iMljJJkxOzAGjWGIlCa7gnItvBln60laFMf6PSPM=";
  };
in {
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
    enableFishIntegration = false;
    # package = inputs.yazi.packages.${pkgs.system}.default;
    plugins = {
      arrow-parent = ./plugins/arrow-parent.yazi;
      autofilter = pkgs.fetchFromGitHub {
        owner = "DreamMaoMao";
        repo = "autofilter.yazi";
        rev = "6ecc3ea5596fe445381e94a4fc51fc022ee5f9fa";
        sha256 = "sha256-hoI5c2LrNmImAYRrLu96SVw2r9WeklY1pYaCHOaYJ0g=";
      };
      autosort = pkgs.fetchgit {
        url = "https://gitee.com/DreamMaoMao/autosort.yazi";
        rev = "9678ca6328442f3edb5770101096afb3a3f25bbe";
        sha256 = "sha256-ZQhl3oOUzXnLbqTQXDSjtyl0c4i+CQdt2DgOgSualOY=";
      };
      bookmarks = pkgs.fetchFromGitHub {
        owner = "DreamMaoMao";
        repo = "bookmarks.yazi";
        rev = "83580203c014ad48834af51ee6a11767511a25a6";
        sha256 = "sha256-TfOdLAs7ljLl5WmCsmP4o6JCQqUtvSdZgn+O9QKjTV4=";
      };
      cd-last = ./plugins/cd-last.yazi;
      clipboard = pkgs.fetchFromGitHub {
        owner = "DreamMaoMao";
        repo = "clipboard.yazi";
        rev = "93b73d41e17f3342dab36c4280ec16d1afc7f40e";
        sha256 = "sha256-yeKh0uQBrkqls4D28xKKyq1MF5LpleZW0/uxFWf1tQw=";
      };
      cmd = ./plugins/cmd.yazi;
      current-size = pkgs.fetchgit {
        url = "https://gitee.com/DreamMaoMao/current-size.yazi";
        rev = "bcc41b3f6d5439cf2b6f6f87cc2a3898af7b0086";
        sha256 = "sha256-ZNLAnqvm0uRKFqBNlzvOR0uoIAVoeSaxnqNIJTHxzAA=";
      };
      disable = ./plugins/disable.yazi;
      easyjump = pkgs.fetchFromGitHub {
        owner = "DreamMaoMao";
        repo = "easyjump.yazi";
        rev = "964aaf807d00617027cbc23f71ce58151e0451b1";
        sha256 = "sha256-uNrZ5kTzwl8Ec/pftrnlljVN306DCUZUUggOtAxVf+k=";
      };
      epub-preview = pkgs.fetchFromGitHub {
        owner = "kirasok";
        repo = "epub-preview.yazi";
        rev = "77a76b8dc36c52b8713bd3745456d096732be7bd";
        sha256 = "sha256-Ig0sUamVUmveOm0EuCBE2hzk53LdDVjUg7Ij0CnnDmE=";
      };
      fg = pkgs.fetchFromGitHub {
        owner = "DreamMaoMao";
        repo = "fg.yazi";
        rev = "daf696065d65e61a1b3026ab8190351203513d51";
        sha256 = "sha256-dcidPBhc0+NvPb80hK+kUoq+PxspceFCliyEc7K3OTk=";
      };
      full-border = ./plugins/full-border.yazi;
      git = pkgs.fetchFromGitHub {
        owner = "DreamMaoMao";
        repo = "git.yazi";
        rev = "24d78dc895eee4da234fd87619aebb8fe3cc7156";
        sha256 = "sha256-r8vx8rP19Q2N2Tqwi9IsW9aHzOuSFMaXKtx33sAo38g=";
      };
      glow = pkgs.fetchFromGitHub {
        owner = "Reledia";
        repo = "glow.yazi";
        rev = "5ce76dc92ddd0dcef36e76c0986919fda3db3cf5";
        sha256 = "sha256-UljcrXXO5DZbufRfavBkiNV3IGUNct31RxCujRzC9D4=";
      };
      header-hidden = ./plugins/header-hidden.yazi;
      header-host = ./plugins/header-host.yazi;
      html = ./plugins/html.yazi;
      keyjump = pkgs.fetchFromGitHub {
        owner = "DreamMaoMao";
        repo = "keyjump.yazi";
        rev = "4fb2bc3ae51993c7196b32bc781b5c5d0ae1e437";
        sha256 = "sha256-NZDPaqCoq5MGBocTxnNHR2MSi7y1RIi2j2+rL+7M/jI=";
      };
      lastopen = pkgs.fetchFromGitHub {
        owner = "DreamMaoMao";
        repo = "lastopen.yazi";
        rev = "d7be71bcd2cef4698696a413d6681ce302d2b334";
        sha256 = "sha256-xGxGE/Nz/8jX9lCk9ROafNDH2zyPoUKWrMJ7rLzDu8A=";
      };
      mime-ext = "${yazi-plugins}/mime-ext.yazi";
      mime-preview = pkgs.fetchFromGitHub {
        owner = "DreamMaoMao";
        repo = "mime-preview.yazi";
        rev = "5ee0e78d7a46b756b77bec029722d31823869f08";
        sha256 = "sha256-utK+Ng0M5BvxAH/Cjz6/Gg6vc+cD9bwJxiQTerOhnW8=";
      };
      mount = ./plugins/mount.yazi;
      searchjump = pkgs.fetchFromGitHub {
        owner = "DreamMaoMao";
        repo = "searchjump.yazi";
        rev = "df6ee75772d4095c740572fa4adb06a27857c721";
        sha256 = "sha256-JgHxItaE/C7xdc7fe35KfLZGJKiIvurKizPH9cOb3Z0=";
      };
      status-mtime = ./plugins/status-mtime.yazi;
      status-owner = ./plugins/status-owner.yazi;
    };
  };

  xdg.configFile = {
    "yazi/init.lua".source = config.lib.file.mkOutOfStoreSymlink "${configDirectory}/home-manager/_mixins/configs/yazi/init.lua";
    "yazi/yazi.toml".source = config.lib.file.mkOutOfStoreSymlink "${configDirectory}/home-manager/_mixins/configs/yazi/yazi.toml";
    "yazi/keymap.toml".source = config.lib.file.mkOutOfStoreSymlink "${configDirectory}/home-manager/_mixins/configs/yazi/keymap.toml";
    "yazi/theme.toml".source = config.lib.file.mkOutOfStoreSymlink "${configDirectory}/home-manager/_mixins/configs/yazi/theme.toml";
    "yazi/bat-theme".source = config.lib.file.mkOutOfStoreSymlink "${configDirectory}/home-manager/_mixins/configs/yazi/bat-theme";
  };
}
