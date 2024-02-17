{
	description = "NixOS configuration";
  	inputs = {
		nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
        home-manager = {
            url = "github:nix-community/home-manager/release-23.11";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        hyprland = {
            url = "github:hyprwm/Hyprland";
            inputs.nixpkgs.follows = "nixpkgs";
        };
  	    vscode-server.url = "github:nix-community/nixos-vscode-server";
    };

    outputs = { nixpkgs, home-manager, ...}@inputs: {
	    nixosConfigurations = {
		    "nixos" = nixpkgs.lib.nixosSystem {
			    system = "x86_64-linux";
			    modules = [
				    { _module.args = inputs; }
				    ./hardware-configuration.nix
				    home-manager.nixosModules.home-manager
                    {
                        home-manager.useGlobalPkgs = true;
                        home-manager.useUserPackages = true;
                        home-manager.users.SolitudeAlma = import ./home.nix;
                    }
                    ({ config, pkgs, nixpkgs, lib, ... }: {
					    i18n = {
						    defaultLocale = "en_US.UTF-8";
						    supportedLocales = ["en_US.UTF-8/UTF-8"];
                            inputMethod = {
                                enabled = "fcitx5";
                                fcitx5.addons = with pkgs; [
                                    fcitx5-rime
                                    fcitx5-chinese-addons
                                    fcitx5-table-other
                                    fcitx5-table-extra
                                ];
                            };
					    };
					    time.timeZone = "Asia/Shanghai";
					    fonts.packages = with pkgs; [
                            #maplemono-SC-NF
                            jetbrains-mono
                        ];
                        nixpkgs.config.allowUnfree = true;
                        nix = {
						    channel.enable = false;
						    registry.nixpkgs.flake = nixpkgs;
						    package = pkgs.nixUnstable;
						    settings = {
							    nix-path = lib.mkForce "nixpkgs=flake:nixpkgs";
							    experimental-features = [
								    "nix-command"
								    "flakes"
								    "auto-allocate-uids"
								    "configurable-impure-env"
								    "cgroups"
							    ];
                                use-cgroups = true;
                                auto-optimise-store = true;
                                auto-allocate-uids = true;
                                substituters = [
                                    "https://mirrors.ustc.edu.cn/nix-channels/store"
                                    "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
                                    "https://mirror.sjtu.edu.cn/nix-channels/store"
                                ];
                            };
                            gc = {
                                automatic = true;
                                dates = "weekly";
                                options = "--delete-older-than2d";
                            };
                        };
                        networking = {
                            wireless = {
                                enable = false;
                                networks = {
                                    "GCCC".psk = "22050822";
                                };
                            };
                            networkmanager = {
                                enable = true;
                            };
                        };
                        services.xserver = {
                            enable = true;
                            displayManager.gdm.enable = true;
                            desktopManager.gnome.enable = true;
                        };
                        boot.loader.systemd-boot.enable = true;
                        boot.loader.efi.canTouchEfiVariables = true;
                        system.stateVersion = "23.11";
                        users.users.SolitudeAlma.group = "SolitudeAlma";
                        users.groups.SolitudeAlma = {};
                        users.users.SolitudeAlma.isNormalUser = true;
                    })
                ];
            };
        };
	};
}
