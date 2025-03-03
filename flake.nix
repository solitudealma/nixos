{
  description = "SolitudeAlma's NixOS, nix-darwin and Home Manager Configuration";
  # It is also possible to "inherit" an input from another input. This is useful to minimize
  # flake dependencies. For example, the following sets the nixpkgs input of the top-level flake
  # to be equal to the nixpkgs input of the nixops input of the top-level flake:
  inputs = {
    # nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable-small";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable-small";

    ags.url = "github:Aylur/ags"; #"git+https://github.com/Aylur/ags?rev=60180a184cfb32b61a1d871c058b31a3b9b0743d";

    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";

    daeuniverse.url = "github:daeuniverse/flake.nix";

    disko.url = "github:nix-community/disko";

    flameshot-git.url = "github:flameshot-org/flameshot";
    flameshot-git.flake = false;

    fastanime.url = "github:Benex254/fastanime";

    fum.url = "github:qxb3/fum";

    grub2-themes.url = "github:vinceliuice/grub2-themes";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    hyprland-contrib.url = "github:hyprwm/contrib";
    hyprland-contrib.inputs.nixpkgs.follows = "nixpkgs";

    # hyprland.url = "git+https://github.com/hyprwm/hyprland?ref=refs/tags/v0.47.2&submodules=1";
    hyprland.url = "github:hyprwm/Hyprland";

    hyprland-plugins.url = "github:hyprwm/hyprland-plugins";
    hyprland-plugins.inputs.hyprland.follows = "hyprland";

    nixd.url = "github:nix-community/nixd";

    niri.url = "github:sodiboo/niri-flake";

    nixos-cosmic.url = "github:lilyinstarlight/nixos-cosmic";
    # nixpkgs.follows = "nixos-cosmic/nixpkgs";

    nix-flatpak.url = "github:gmodena/nix-flatpak";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";

    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";

    nur.url = "github:nix-community/NUR";

    nur-Moraxyc.url = "github:Moraxyc/nur-packages";

    nur-xddxdd.url = "github:xddxdd/nur-packages";
    nur-xddxdd.inputs.nixpkgs.follows = "nixpkgs";

    plasma-manager.url = "github:nix-community/plasma-manager";
    plasma-manager.inputs.nixpkgs.follows = "nixpkgs";
    plasma-manager.inputs.home-manager.follows = "home-manager";

    # sops-nix.url = "github:Mic92/sops-nix";
    # sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
    spicetify-nix.inputs.nixpkgs.follows = "nixpkgs";

    stylix.url = "github:danth/stylix";

    treefmt-nix.url = "github:numtide/treefmt-nix";
    treefmt-nix.inputs.nixpkgs.follows = "nixpkgs";

    wayland-pipewire-idle-inhibit.url = "github:rafaelrc7/wayland-pipewire-idle-inhibit";
    wayland-pipewire-idle-inhibit.inputs.nixpkgs.follows = "nixpkgs";

    yazi.url = "github:sxyazi/yazi";

    # FlakeHub

    nixos-needsreboot.url = "https://flakehub.com/f/wimpysworld/nixos-needsreboot/*.tar.gz";
    nixos-needsreboot.inputs.nixpkgs.follows = "nixpkgs";

    quickemu.url = "https://flakehub.com/f/quickemu-project/quickemu/*";
    quickemu.inputs.nixpkgs.follows = "nixpkgs";
    quickgui.url = "https://flakehub.com/f/quickemu-project/quickgui/*.tar.gz";
    quickgui.inputs.nixpkgs.follows = "nixpkgs";
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
      test = helper.mkNixos {
        hostname = "test";
        desktop = "hyprland";
      };
    };
    # Custom packages and modifications, exported as overlays
    overlays = import ./overlays {inherit inputs;};
    # Custom packages; acessible via 'nix build', 'nix shell', etc
    packages = helper.forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});
    # Formatter for .nix files, available via 'nix fmt'
    formatter = helper.forAllSystems (system: nixpkgs.legacyPackages.${system}.nixfmt-rfc-style);
  };
}
