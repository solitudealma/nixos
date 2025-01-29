{
  fetchurl,
  fetchFromGitHub,
  pkg-config,
  stdenv,

  webkitgtk_4_1,
  discount,
  perl538Packages,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "wyeb";
  version = "4.1";
  src = fetchFromGitHub {
    owner = "jun7";
    repo = finalAttrs.pname;
    rev = finalAttrs.version;
    sha256 = "sha256-qXJY6ZQhQOoY3E4wd5Qt+OupQT2TnkCjIySQ40ZxC04=";
    fetchSubmodules = false;
  };

  enableParallelBuilding = true;

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    webkitgtk_4_1
    discount
    perl538Packages.FileMimeInfo
  ];

  installPhase = ''
    mkdir -p $out/{bin,lib} $out/share/applications $out/share/pixmaps
    install -m755 wyeb "$out/bin"
    install -Dm755 ext.so   "$out/lib"
    install -Dm644 wyeb.png   "$out/share/pixmaps"
    install -Dm644 wyeb.desktop "$out/share/applications"
  '';
})
