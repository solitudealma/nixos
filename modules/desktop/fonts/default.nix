{pkgs, ...}: {
  fonts = {
    packages = with pkgs; [
      # icon fonts
      material-symbols
      material-design-icons
      font-awesome

      joypixels
      noto-fonts-emoji # 彩色的表情符号字体

      # normal fonts
      maple-mono
      maple-mono-NF
      maple-mono-SC-NF

      # nerdfonts
      (nerdfonts.override {
        fonts = [
          # symbols icon only
          "NerdFontsSymbolsOnly"
          # Characters
          "FiraCode"
          "JetBrainsMono"
          # "Iosevka"
        ];
      })
    ];

    # causes more issues than it solves
    enableDefaultPackages = false;

    # user defined fonts
    # the reason there's Noto Color Emoji everywhere is to override DejaVu's
    # B&W emojis that would sometimes show instead of some Color emojis
    fontconfig.defaultFonts = {
      serif = ["Maple Mono SC NF"];
      sansSerif = ["Maple Mono SC NF"];
      monospace = ["Maple Mono SC NF"];
      emoji = ["Noto Color Emoji"];
    };
  };
}
