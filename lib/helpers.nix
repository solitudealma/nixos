{
  inputs,
  outputs,
  stateVersion,
  ...
}: {
  # Helper function for generating NixOS configs
  mkNixos = {
    hostname,
    username ? "solitudealma",
    desktop ? null,
    platform ? "x86_64-linux",
  }: let
    isISO = builtins.substring 0 4 hostname == "iso-";
    isInstall = !isISO;
    isLaptop = hostname != "others";
    isLima = hostname == "blackace" || hostname == "defender" || hostname == "fighter";
    isWorkstation = builtins.isString desktop;
  in
    inputs.nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit
          inputs
          outputs
          desktop
          hostname
          platform
          username
          stateVersion
          isInstall
          isISO
          isLaptop
          isWorkstation
          ;
      };
      # If the hostname starts with "iso-", generate an ISO image
      modules = let
        cd-dvd =
          if (desktop == null)
          then inputs.nixpkgs + "/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
          else inputs.nixpkgs + "/nixos/modules/installer/cd-dvd/installation-cd-graphical-calamares.nix";
      in
        [
          ../nixos
          inputs.home-manager.nixosModules.home-manager
          {
            home-manager = {
              extraSpecialArgs = {
                inherit
                  inputs
                  desktop
                  hostname
                  platform
                  username
                  stateVersion
                  isInstall
                  isISO
                  isLaptop
                  isLima
                  isWorkstation
                  ;
              };
              useGlobalPkgs = true;
              useUserPackages = true;
              backupFileExtension = "backup";
              users.${username} = import ../home-manager;
            };
          }
        ]
        ++ inputs.nixpkgs.lib.optionals isISO [cd-dvd];
    };

  mkDarwin = {
    desktop ? "aqua",
    hostname,
    username ? "solitudealma",
    platform ? "aarch64-darwin",
  }: let
    isISO = false;
    isInstall = true;
    isLaptop = true;
    isWorkstation = true;
  in
    inputs.nix-darwin.lib.darwinSystem {
      specialArgs = {
        inherit
          inputs
          outputs
          desktop
          hostname
          platform
          username
          stateVersion
          isInstall
          isISO
          isLaptop
          isWorkstation
          ;
      };
      modules = [../darwin];
    };

  forAllSystems = inputs.nixpkgs.lib.genAttrs [
    "aarch64-linux"
    "x86_64-linux"
    "aarch64-darwin"
    "x86_64-darwin"
  ];
}
