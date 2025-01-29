{
  config,
  hostname,
  isLima,
  lib,
  pkgs,
  username,
  ...
}: let
  inherit (config._custom.globals) _git;
  inherit (pkgs.stdenv) isLinux;
  isStreamstation = hostname == "laptop";
in {
  home = {
    file = {
      "${config.xdg.configHome}/autostart/deskmaster-xl.desktop" = lib.mkIf isStreamstation {
        text = ''
          [Desktop Entry]
          Name=Deckmaster XL
          Comment=Deckmaster XL
          Type=Application
          Exec=deckmaster -deck ${config.home.homeDirectory}/Studio/StreamDeck/Deckmaster-xl/main.deck
          Categories=
          Terminal=false
          NoDisplay=true
          StartupNotify=false
        '';
      };
      ".face".source = ./face.jpg;
      ".ssh/allowed_signers".text = ''
        ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFwN20aih/o2JTFLrjSXxDfnzMFPJ5VSA6M5HDR5jq5+ 2241141629yt@gmail.com
      '';
    };
  };
  programs = {
    git = {
      extraConfig = {
        gpg = {
          format = "ssh";
          ssh = {
            allowedSignersFile = "${config.home.homeDirectory}/.ssh/allowed_signers";
          };
        };
        url = {
          "ssh://git@github.com:" = {
            insteadOf = "github:";
          };
          "https://github.com/" = {
            insteadOf = "github:";
          };
        };
      };
      signing = {
        key = "${config.home.homeDirectory}/.ssh/id_ed25519";
        signByDefault = true;
      };
      userName = _git.userName;
      userEmail = _git.email;
    };
  };
  systemd.user.tmpfiles = lib.mkIf (isLinux && !isLima) {
    rules = [
      "d ${config.home.homeDirectory}/Crypt 0755 ${username} users - -"
      "d ${config.home.homeDirectory}/Vaults/Armstrong 0755 ${username} users - -"
      "d ${config.home.homeDirectory}/Vaults/Secrets 0755 ${username} users - -"
    ];
  };
}
