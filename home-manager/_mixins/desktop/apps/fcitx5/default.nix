{
  config,
  desktop,
  lib,
  pkgs,
  ...
}: let
  rime-solitudealma-custom = pkgs.callPackage ./rime-solitudealma-custom.nix {};

  fcitx5-rime-with-addons =
    (pkgs.fcitx5-rime.override {
      librime = pkgs.nur-xddxdd.lantianCustomized.librime-with-plugins;
      rimeDataPkgs = with pkgs; [
        oh-my-rime
        nur-xddxdd.rime-custom-pinyin-dictionary
        rime-data
        nur-xddxdd.rime-dict
        rime-frost
        nur-xddxdd.rime-moegirl
        rime-solitudealma-custom
        nur-xddxdd.rime-zhwiki
      ];
    })
    .overrideAttrs
    (old: {
      # Prebuild schema data
      nativeBuildInputs = (old.nativeBuildInputs or []) ++ [pkgs.parallel];
      postInstall =
        (old.postInstall or "")
        + ''
          for F in $out/share/rime-data/*.schema.yaml; do
            echo "rime_deployer --compile "$F" $out/share/rime-data $out/share/rime-data $out/share/rime-data/build" >> parallel.lst
          done
          parallel -j$(nproc) < parallel.lst || true
        '';
    });
in {
  home.sessionVariables = {
    GTK_IM_MODULE = "fcitx";
    QT_IM_MODULE = "fcitx";
    XMODIFIERS = "@im=fcitx";
    SDL_IM_MODULE = "fcitx";
    GLFW_IM_MODULE = "ibus";
  };
  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5 = {
      addons = with pkgs; [
        fcitx5-configtool
        fcitx5-lua
        fcitx5-gtk # gtk im module
        libsForQt5.fcitx5-qt
        fcitx5-rime-with-addons
      ];
    };
  };
}
