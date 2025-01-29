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
    custom-caddy = import ./custom-caddy.nix {pkgs = prev;};
    gitkraken = prev.gitkraken.overrideAttrs (old: rec {
      version = "10.6.2";
      src =
        {
          x86_64-linux = prev.fetchzip {
            url = "https://release.axocdn.com/linux/GitKraken-v${version}.tar.gz";
            hash = "sha256-E/9BR4PE5QF075+NgJZTtgDoShHEqeRcoICnMLt3RuY=";
          };

          x86_64-darwin = prev.fetchzip {
            url = "https://release.axocdn.com/darwin/GitKraken-v${version}.zip";
            hash = "sha256-gCiZN+ivXEF5KLas7eZn9iWfXcDGwf1gXK1ejY2C4xs=";
          };

          aarch64-darwin = prev.fetchzip {
            url = "https://release.axocdn.com/darwin-arm64/GitKraken-v${version}.zip";
            hash = "sha256-1zd57Kqi5iKHw/dNqLQ7jVAkNFvkFeqQbZPN32kF9IU=";
          };
        }
        .${prev.stdenv.hostPlatform.system}
        or (throw "Unsupported system: ${prev.stdenv.hostPlatform.system}");
    });
    # hyprland = inputs.hyprland.packages.${prev.system}.default.overrideAttrs (_old: {
    hyprland = prev.hyprland.overrideAttrs (_old: {
      postPatch =
        _old.postPatch
        + ''
          sed -i 's|Exec=Hyprland|Exec=hypr-launch|' example/hyprland.desktop
        '';
    });
    wavebox = prev.wavebox.overrideAttrs (_old: rec {
      pname = "wavebox";
      version = "10.131.15-2";
      src = prev.fetchurl {
        url = "https://download.wavebox.app/stable/linux/deb/amd64/wavebox_${version}_amd64.deb";
        sha256 = "sha256-rGMkXs5w/NrIYOKPArCLBMUDoMnvQqggo91viyJUfj4=";
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
    qq = let
      LITELOADERQQNT_PROFILE = "$HOME/.config/llqqnt";
      llSrc = builtins.fetchGit {
        url = "https://github.com/LiteLoaderQQNT/LiteLoaderQQNT";
        rev = "5a1a08aed69d128ec4b711aaaba8f3d255a1916c";
        submodules = true;
      };
    in
      prev.qq.overrideAttrs (oldAttrs: {
        pname = "llqqnt";
        src = prev.fetchurl {
          url = "https://dldir1.qq.com/qqfile/qq/QQNT/Linux/QQ_3.2.15_250110_amd64_01.deb";
          hash = "sha256-hDfaxxXchdZons8Tb5I7bsd7xEjiKpQrJjxyFnz3Y94=";
        };
        postInstall =
          ''
            echo "require('"${llSrc.outPath}"');" > "$out/opt/QQ/resources/app/app_launcher/llqqnt.js"
            sed -i 's#\./application.asar/app_launcher/index\.js#./app_launcher/llqqnt.js#g' "$out/opt/QQ/resources/app/package.json"
          ''
          + prev.lib.optionalString (LITELOADERQQNT_PROFILE != "") ''sed -i '$i\export LITELOADERQQNT_PROFILE=${LITELOADERQQNT_PROFILE}' "$out/bin/qq"'';
      });
    resources = prev.resources.overrideAttrs (_old: rec {
      pname = "resources";
      version = "1.7.0";
      src = prev.fetchFromGitHub {
        owner = "nokyan";
        repo = "resources";
        rev = "refs/tags/v${version}";
        hash = "sha256-mnOpWVJTNGNdGd6fMIZl3AOF4NbtMm1XS8QFqfAF/18=";
      };
      cargoDeps = prev.rustPlatform.fetchCargoTarball {
        inherit src;
        name = "resources-${version}";
        hash = "sha256-vIqtKJxKQ/mHFcB6IxfX27Lk2ID/W+M4hQnPB/aExa4=";
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
