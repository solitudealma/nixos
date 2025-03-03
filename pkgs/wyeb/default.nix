{
  fetchFromGitHub,
  pkg-config,
  stdenv,
  webkitgtk_4_0,
  discount,
  perl538Packages,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "wyeb";
  version = "d30790457cef201b8f490afba814a7f19bfc2e77";
  src = fetchFromGitHub {
    owner = "jun7";
    repo = finalAttrs.pname;
    rev = finalAttrs.version;
    sha256 = "sha256-VprJg8M0FlQ5/1evTmBYjPnt8SSOx8vFR4Fmr39L4qU=";
  };

  enableParallelBuilding = true;

  nativeBuildInputs = [pkg-config];

  buildInputs = [
    webkitgtk_4_0
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
