{
  description = "SolitudeAlma's NixOS, nix-darwin and Home Manager Configuration";

  # It is also possible to "inherit" an input from another input. This is useful to minimize
  # flake dependencies. For example, the following sets the nixpkgs input of the top-level flake
  # to be equal to the nixpkgs input of the nixops input of the top-level flake:
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable-small";

    ags.url = "github:Aylur/ags/v1"; #"git+https://github.com/Aylur/ags?rev=60180a184cfb32b61a1d871c058b31a3b9b0743d";

    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";

    daeuniverse.url = "github:daeuniverse/flake.nix";

    # dmenu.url = "/home/solitudealma/dmenu";

    # dwm.url = "/home/solitudealma/.config/dwm";

    fastanime.url = "github:Benex254/fastanime";
    fastanime.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager/release-24.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    hyprland-contrib.url = "github:hyprwm/contrib";
    hyprland-contrib.inputs.nixpkgs.follows = "nixpkgs";

    hyprland.url = "github:hyprwm/Hyprland";

    hyprland-plugins.url = "github:hyprwm/hyprland-plugins";
    hyprland-plugins.inputs.hyprland.follows = "hyprland";

    matugen.url = "github:/InioX/Matugen";

    nixd.url = "github:nix-community/nixd";

    niri.url = "github:sodiboo/niri-flake";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    nix-alien.url = "github:thiagokokada/nix-alien";

    nix-index-database.url = "github:Mic92/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";

    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
    nix-vscode-extensions.inputs.nixpkgs.follows = "nixpkgs";

    nixpkgs-wayland.url = "github:nix-community/nixpkgs-wayland?rev=52b72b12c456a5c0c87c40941ef79335e8d61104"; # master (sep 03 2024)
    nixpkgs-wayland.inputs.nixpkgs.follows = "nixpkgs";

    nur-xddxdd.url = "github:xddxdd/nur-packages";
    nur-xddxdd.inputs.nixpkgs.follows = "nixpkgs";

    nur.url = "github:nix-community/NUR";

    picom.url = "github:yaocccc/picom";

    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
    spicetify-nix.inputs.nixpkgs.follows = "nixpkgs";

    stylix.url = "github:danth/stylix";

    wayland-pipewire-idle-inhibit.url = "github:rafaelrc7/wayland-pipewire-idle-inhibit";
    wayland-pipewire-idle-inhibit.inputs.nixpkgs.follows = "nixpkgs";

    yazi.url = "github:sxyazi/yazi";

    # FlakeHub
    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/0";

    disko.url = "https://flakehub.com/f/nix-community/disko/1.11.0.tar.gz";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    fh.url = "https://flakehub.com/f/DeterminateSystems/fh/0";

    nix-flatpak.url = "https://flakehub.com/f/gmodena/nix-flatpak/*";

    nixos-needsreboot.url = "https://flakehub.com/f/wimpysworld/nixos-needsreboot/0.2.3.tar.gz";
    nixos-needsreboot.inputs.nixpkgs.follows = "nixpkgs";

    quickemu.url = "https://flakehub.com/f/quickemu-project/quickemu/*";
    quickemu.inputs.nixpkgs.follows = "nixpkgs";
    quickgui.url = "https://flakehub.com/f/quickemu-project/quickgui/*.tar.gz";
    quickgui.inputs.nixpkgs.follows = "nixpkgs";

    stream-sprout.url = "https://flakehub.com/f/wimpysworld/stream-sprout/*";
    stream-sprout.inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs = {
    self,
    nixpkgs,
    ...
  } @ inputs: let
    inherit (self) outputs;
    # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
    stateVersion = "24.11";
    helper = import ./lib {inherit inputs outputs stateVersion;};
  in {
    # home-manager switch -b backup --flake $HOME/Zero/nix-config
    # nix run nixpkgs#home-manager -- switch -b backup --flake "${HOME}/Zero/nix-config"
    homeConfigurations = {
      # .iso images
      "nixos@iso-console" = helper.mkHome {
        hostname = "iso-console";
        username = "nixos";
      };
      "nixos@iso-gnome" = helper.mkHome {
        hostname = "iso-gnome";
        username = "nixos";
        desktop = "gnome";
      };

      # Workstations
      "solitudealma@laptop" = helper.mkHome {
        hostname = "laptop";
        desktop = "niri";
      };

      # palpatine/sidious are dual boot hosts, WSL2/Ubuntu and NixOS respectively.
      "solitudealma@palpatine" = helper.mkHome {hostname = "palpatine";};
      "solitudealma@sidious" = helper.mkHome {
        hostname = "sidious";
        desktop = "gnome";
      };
      # Servers
      "solitudealma@malak" = helper.mkHome {hostname = "malak";};
      "solitudealma@revan" = helper.mkHome {hostname = "revan";};
      # Steam Deck
      "deck@steamdeck" = helper.mkHome {
        hostname = "steamdeck";
        username = "deck";
      };
      # VMs
      "solitudealma@blackace" = helper.mkHome {hostname = "blackace";};
      "solitudealma@defender" = helper.mkHome {hostname = "defender";};
      "solitudealma@fighter" = helper.mkHome {hostname = "fighter";};
      "solitudealma@crawler" = helper.mkHome {hostname = "crawler";};
      "solitudealma@dagger" = helper.mkHome {
        hostname = "dagger";
        desktop = "pantheon";
      };
    };
    nixosConfigurations = {
      # .iso images
      #  - nix build .#nixosConfigurations.{iso-console|iso-gnome}.config.system.build.isoImage
      iso-console = helper.mkNixos {
        hostname = "iso-console";
        username = "nixos";
      };
      iso-gnome = helper.mkNixos {
        hostname = "iso-gnome";
        username = "nixos";
        desktop = "gnome";
      };
      # Workstations
      #  - sudo nixos-rebuild boot --flake $HOME/Zero/nix-config
      #  - sudo nixos-rebuild switch --flake $HOME/Zero/nix-config
      #  - nix build .#nixosConfigurations.{hostname}.config.system.build.toplevel
      #  - nix run github:nix-community/nixos-anywhere -- --flake '.#{hostname}' root@{ip-address}
      laptop = helper.mkNixos {
        hostname = "laptop";
        desktop = "niri";
      };
      # Servers
      malak = helper.mkNixos {hostname = "malak";};
      revan = helper.mkNixos {hostname = "revan";};
      # VMs
      crawler = helper.mkNixos {hostname = "crawler";};
      dagger = helper.mkNixos {
        hostname = "dagger";
        desktop = "pantheon";
      };
    };

    devShells = helper.forAllSystems (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
      in
        import ./shell.nix {inherit pkgs;}
    );
    # Custom packages and modifications, exported as overlays
    overlays = import ./overlays {inherit inputs;};
    # Custom packages; acessible via 'nix build', 'nix shell', etc
    packages = helper.forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});
    # Formatter for .nix files, available via 'nix fmt'
    formatter = helper.forAllSystems (system: nixpkgs.legacyPackages.${system}.nixfmt-rfc-style);
  };
}
