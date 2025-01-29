{lib, ...}: {
  options._custom.globals = {
    fonts = {
      mono = lib.mkOption {
        type = lib.types.str;
        default = "Maple Mono NF CN";
      };
      size = lib.mkOption {
        type = lib.types.int;
        default = 13;
      };
    };

    homeDirectory = lib.mkOption {
      type = lib.types.str;
      default = "/home/solitudealma";
      example = "/home/solitudealma";
      description = "Path of user home folder";
    };
    configDirectory = lib.mkOption {
      type = lib.types.str;
      default = "/home/solitudealma/Zero/nix-config";
      example = "/home/solitudealma/Zero/nix-config";
      description = "Path of config folder";
    };

    _git = {
      userName = lib.mkOption {
        type = lib.types.str;
        default = "SolitudeAlma";
        example = "SolitudeAlma";
        description = "Git userName";
      };

      email = lib.mkOption {
        type = lib.types.str;
        default = "2241141629yt@gmail.com";
        example = "2241141629yt@gmail.com";
        description = "Git email";
      };
    };

    theme = {
      name = lib.mkOption {
        type = lib.types.str;
        default = "gruvbox-material-dark-medium"; # select your theme here
        example = "{}";
        description = "Theme colors";
      };
      color = lib.mkOption {
        type = lib.types.attrsOf lib.types.attrs;
        default = "[]";
        example = "[]";
        description = "Theme colors";
      };
    };

    keyboardLayout = lib.mkOption {
      type = lib.types.str;
      default = "us";
      example = "us";
      description = "Keyborad layout";
    };

    proxy = {
      host_ip = lib.mkOption {
        type = lib.types.str;
        default = "127.0.0.1";
        example = "127.0.0.1";
        description = "Proxy ip";
      };
      port = lib.mkOption {
        type = lib.types.str;
        default = "7897";
        example = "7897";
        description = "Proxy port";
      };
    };

    timeZone = lib.mkOption {
      type = lib.types.str;
      default = "Asia/Shanghai";
      example = "Asia/Shanghai";
      description = "Time zone";
    };

    defaultLocale = lib.mkOption {
      type = lib.types.str;
      default = "en_US.UTF-8";
      example = "en_US.UTF-8";
      description = "Default locale language";
    };

    extraLocale = lib.mkOption {
      type = lib.types.str;
      default = "en_US.UTF-8";
      example = "en_US.UTF-8";
      description = "Extra locale language";
    };
  };
}
