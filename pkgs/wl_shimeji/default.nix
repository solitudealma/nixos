{
  fetchurl,
  fetchFromGitHub,
  pkg-config,
  stdenv,
  gnumake,
  libspng,
  kdePackages,
  wayland,
  wlr-protocols,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "wl_shimeji";
  version = "0.1";
  src = fetchFromGitHub {
    owner = "CluelessCatBurger";
    repo = finalAttrs.pname;
    rev = "e16698f474cdedcb88a602db747b55e49e26ecb6";
    sha256 = "sha256-wJbmG2XBHeGBP7RkDlLmyFS5yFfGQYD+g7Re+h+sptg=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ 
    pkg-config
  ];

  buildInputs = [
    libspng
    wayland
    kdePackages.wayland-protocols
    wlr-protocols
  ];
})
