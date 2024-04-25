{
  description = "ZaneyOS";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nix-colors.url = "github:misterio77/nix-colors";
    nur.url = "github:nix-community/NUR";
    nvimdots.url = "github:ayamir/nvimdots";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hycov = {
      url = "github:DreamMaoMao/hycov";
      inputs.hyprland.follows = "hyprland";
    };
    yazi.url = "github:sxyazi/yazi";
    impermanence.url = "github:nix-community/impermanence";
  };

  outputs = inputs @ {
    nixpkgs,
    home-manager,
    impermanence,
    hycov,
    ...
  }: let
    system = "x86_64-linux";
    host = "laptop";
    inherit (import ./hosts/${host}/options.nix) username hostname;

    pkgs = import nixpkgs {
      inherit system;
      config = {
        allowUnfree = true;
      };
    };
  in {
    nixosConfigurations = {
      "${hostname}" = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit system;
          inherit inputs;
          inherit username;
          inherit hostname;
          inherit host;
        };
        modules = [
          ./system.nix
          impermanence.nixosModules.impermanence
          home-manager.nixosModules.home-manager
          {
            home-manager.extraSpecialArgs = {
              inherit username;
              inherit inputs;
              inherit host;
              inherit (inputs.nix-colors.lib-contrib {inherit pkgs;}) gtkThemeFromScheme;
            };
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "backup";
            home-manager.users.${username} = import ./users/default/home.nix;
          }
        ];
      };
    };
  };
}
