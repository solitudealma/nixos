# This file defines overlays
{inputs, ...}: {
  # This one brings our custom packages from the 'pkgs' directory
  additions = final: _prev: import ../pkgs final.pkgs;

  # This one contains whatever you want to overlay
  # You can change versions, add patches, set compilation flags, anything really.
  # https://nixos.wiki/wiki/Overlays
  modifications = _final: prev: {
    awesome = let
      extraGIPackages = with prev; [
        networkmanager
        upower
        playerctl
      ];
    in
      (prev.awesome.override {
        gtk3Support = true;
        lua = prev.lua53Packages.lua;
      })
      .overrideAttrs (old: {
        src = prev.fetchFromGitHub {
          owner = "awesomewm";
          repo = "awesome";
          rev = "0f950cbb625175134b45ea65acdf29b2cbe8c456";
          sha256 = "sha256-GIUkREl60vQ0cOalA37sCgn7Gv8j/9egfRk9emgGm/Y=";
        };

        patches = [];

        postPatch = ''
          patchShebangs tests/examples/_postprocess.lua
          patchShebangs tests/examples/_postprocess_cleanup.lua
        '';

        cmakeFlags = old.cmakeFlags ++ ["-DGENERATE_MANPAGES=OFF"];

        GI_TYPELIB_PATH = let
          mkTypeLibPath = pkg: "${pkg}/lib/girepository-1.0";
          extraGITypeLibPaths = prev.lib.forEach extraGIPackages mkTypeLibPath;
        in
          prev.lib.concatStringsSep ":" (extraGITypeLibPaths ++ [(mkTypeLibPath prev.pango.out)]);
      });
    # custom-caddy = import ./custom-caddy.nix {pkgs = prev;};
    gitkraken = prev.gitkraken.overrideAttrs (old: rec {
      version = "10.7.0";

      src =
        {
          x86_64-linux = prev.fetchzip {
            url = "https://release.axocdn.com/linux/GitKraken-v${version}.tar.gz";
            hash = "sha256-fNx3mZnoMkEd1RlvcEmnncX0cLJhRjbf2t4CfB5eRl4=";
          };

          x86_64-darwin = prev.fetchzip {
            url = "https://release.axocdn.com/darwin/GitKraken-v${version}.zip";
            hash = "sha256-FLNzB1MvW943DDBs5EmxOWx31CMm2KWXrXp6EjfkPeQ=";
          };

          aarch64-darwin = prev.fetchzip {
            url = "https://release.axocdn.com/darwin-arm64/GitKraken-v${version}.zip";
            hash = "sha256-+uEpm9A9zkTMWL2XccWFTkuhFdZMJUZHSD3FinNsRyA=";
          };
        }
        .${prev.stdenv.hostPlatform.system}
        or (throw "Unsupported system: ${prev.stdenv.hostPlatform.system}");
    });
    ncmpcpp = prev.ncmpcpp.override {
      clockSupport = true;
      outputsSupport = true;
      taglibSupport = true;
      visualizerSupport = true;
    };
    nu_scripts = prev.nu_scripts.overrideAttrs (old: rec {
      pname = "nu_scripts";
      src = prev.fetchFromGitHub {
        owner = "nushell";
        repo = pname;
        rev = "9270f34d6b82a682780bcbf3df06f9ffe5e316b0";
        hash = "sha256-1QC9TKnaa9KsYwyJFV/p9zpYQh8N+Xck+Ae3fBpBfPc=";
      };
    });
    pyprland = prev.pyprland.overrideAttrs (old: rec {
      version = "2.4.3";
      src = prev.fetchFromGitHub {
        owner = "hyprland-community";
        repo = "pyprland";
        rev = "refs/tags/${version}";
        hash = "sha256-0vI8f5XXYi7LG6wMH2Uw05pDbozO2eBzLCuaCHBY7BQ=";
      };
    });
    qq = prev.qq.overrideAttrs (oldAttrs: {
      pname = "qq";
      src = prev.fetchurl {
        url = "https://dldir1.qq.com/qqfile/qq/QQNT/Linux/QQ_3.2.15_250110_amd64_01.deb";
        hash = "sha256-hDfaxxXchdZons8Tb5I7bsd7xEjiKpQrJjxyFnz3Y94=";
      };
    });
    resources = prev.resources.overrideAttrs (_old: rec {
      pname = "resources";
      version = "1.7.1";
      src = prev.fetchFromGitHub {
        owner = "nokyan";
        repo = "resources";
        rev = "refs/tags/v${version}";
        hash = "sha256-SHawaH09+mDovFiznZ+ZkUgUbv5tQGcXBgUGrdetOcA=";
      };

      cargoDeps = prev.rustPlatform.fetchCargoTarball {
        inherit src;
        name = "resources-${version}";
        hash = "sha256-tUD+gx9nQiGWKKRPcR7OHbPvU2j1dQjYck7FF9vYqSQ=";
      };
    });
    zen-browser = prev.wrapFirefox prev.zen-browser-unwrapped {
      pname = "zen-browser";
      libName = "zen";
    };
  };

  # When applied, the unstable nixpkgs set (declared in the flake inputs) will
  # be accessible through 'pkgs.unstable'
  unstable-packages = final: _prev: {
    unstable = import inputs.nixpkgs-unstable {
      inherit (final) system;
      config.allowUnfree = true;
    };
  };
}
