{
  config,
  isInstall,
  lib,
  pkgs,
  ...
}: let
  inherit (config._custom.globals) fonts;
  inherit (pkgs.stdenv) isDarwin;
  isOtherOS =
    if builtins.isString (builtins.getEnv "__NIXOS_SET_ENVIRONMENT_DONE")
    then false
    else true;
in
  lib.mkIf (isDarwin || isOtherOS) {
    # https://yildiz.dev/posts/packing-custom-fonts-for-nixos/
    home = {
      packages = with pkgs;
        [
          nerd-fonts.jetbrains-mono
          nerd-fonts.fira-code
          nerd-fonts.symbols-only
          fira
          font-awesome
          liberation_ttf
          noto-fonts-emoji
          noto-fonts-monochrome-emoji
          source-serif
          symbola
          work-sans
          fonts.package
          material-icons
          # nur.repos.mgord9518.windows-fonts
          wqy_microhei
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
          ubuntu_font_family
          unscii
          zx-spectrum-7-font
        ];
    };

    fonts.fontconfig = {
      enable = true;
      defaultFonts = {
        serif = [
          fonts.mono
          "JetBrainsMono Nerd Font"
          "WenQuanYi Micro Hei"
          "Source Serif"
          "Noto Color Emoji"
        ];
        sansSerif = [
          fonts.mono
          "JetBrainsMono Nerd Font"
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
    };
  }
