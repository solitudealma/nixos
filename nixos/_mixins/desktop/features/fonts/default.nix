{
  config,
  isInstall,
  lib,
  pkgs,
  ...
}: let
  inherit (config._custom.globals) fonts;
in {
  # https://yildiz.dev/posts/packing-custom-fonts-for-nixos/
  fonts = {
    # Enable a basic set of fonts providing several font styles and families and reasonable coverage of Unicode.
    enableDefaultPackages = false;
    fontDir.enable = true;
    packages = with pkgs;
      [
        nerd-fonts.jetbrains-mono
        nerd-fonts.fira-code
        nerd-fonts.symbols-only
        fira
        font-awesome
        liberation_ttf
        noto-fonts
        noto-fonts-cjk-sans
        noto-fonts-emoji
        noto-fonts-monochrome-emoji
        source-serif
        symbola
        work-sans
        fonts.package
        material-icons
        source-han-sans
        # nur.repos.mgord9518.windows-fonts
        wqy_microhei
        wqy_zenhei # for steam
      ]
      ++ lib.optionals isInstall [
        bebas-neue-2014-font
        bebas-neue-pro-font
        bebas-neue-rounded-font
        bebas-neue-semi-rounded-font
        boycott-font
        commodore-64-pixelized-font
        digital-7-font
        dirty-ego-font
        fixedsys-core-font
        fixedsys-excelsior-font
        impact-label-font
        mocha-mattari-font
        poppins-font
        spaceport-2006-font
        zx-spectrum-7-font
        ubuntu_font_family
        unscii
      ];

    fontconfig = {
      antialias = true;
      # Enable 32-bit support
      cache32Bit = lib.mkForce config.hardware.graphics.enable32Bit;
      defaultFonts = {
        serif = [
          fonts.mono
          "JetBrainsMono Nerd Font"
          "Source Han Sans SC"
          "WenQuanYi Micro Hei"
          "Source Serif"
          "Noto Color Emoji"
        ];
        sansSerif = [
          fonts.mono
          "JetBrainsMono Nerd Font"
          "Source Han Sans SC"
          "WenQuanYi Micro Hei"
          "Work Sans"
          "Fira Sans"
          "Noto Color Emoji"
        ];
        monospace = [
          fonts.mono
          "JetBrainsMono Nerd Font"
          "WenQuanYi Micro Hei Mono"
          "FiraCode Nerd Font Mono"
          "Font Awesome 6 Free"
          "Font Awesome 6 Brands"
          "Symbola"
          "Noto Emoji"
        ];
        emoji = [
          "Noto Color Emoji"
        ];
      };
      enable = true;
      hinting = {
        autohint = false;
        enable = true;
        style = "slight";
      };
      localConf = builtins.readFile ./fontconfig.xml;
      subpixel = {
        rgba = "rgb";
        lcdfilter = "light";
      };
    };
  };
}
