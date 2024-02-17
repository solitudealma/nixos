{ config, pkgs, ... }:

{
    home.username = "SolitudeAlma";
    #home.homeDirectory = "/home/SolitudeAlma";

    xresources.properties = {
        "Xcursor.size" = 16;
        "Xft.dpi" = 100;
    };

    home.packages = with pkgs; [
        neofetch
        vscode
        google-chrome
        qq
        jq
        #discord
        nix-tree
        clash-verge
        nixpkgs-fmt
        unzip
        zip
        git
        neovim
        vim
        zsh
        alacritty
        lazygit
        gcc
        ripgrep
        fd
        fzf
        yazi
        openssh
        zoxide
        wget
        telegram-desktop
        eza
        ncmpcpp
        grimblast
        slurp
        cliphist
    ];

    home.stateVersion = "23.11";

    programs.home-manager.enable = true;
}
