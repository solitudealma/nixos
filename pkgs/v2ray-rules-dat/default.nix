{
  lib,
  stdenvNoCC,
  fetchurl,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "v2ray-rules-dat";
  version = "202501162211";

  srcs = [
    (fetchurl {
      url = "https://github.com/techprober/v2ray-rules-dat/releases/latest/download/geoip.dat";
      hash = "sha256-L1jLQCsrYh5k5B6z/Wq4Ujzbf13Ht1i/9+h6lGNiROc=";
    })
    (fetchurl {
      url = "https://github.com/techprober/v2ray-rules-dat/releases/latest/download/geosite.dat";
      hash = "sha256-ubYM+IkncWOkpjg5ndDxEeFo8nP2g7pO4iOSyG1/lTU=";
    })
  ];

  dontConfigure = true;
  dontBuild = true;
  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    install -Dm644 ${builtins.elemAt finalAttrs.srcs 0} $out/share/v2ray/geoip.dat
    install -Dm644 ${builtins.elemAt finalAttrs.srcs 1} $out/share/v2ray/geosite.dat

    runHook postInstall
  '';

  meta = {
    description = "Enhanced edition of V2Ray rules dat files";
    homepage = "https://github.com/Loyalsoldier/v2ray-rules-dat";
    license = lib.getLicenseFromSpdxId "GPL-3.0-only";
    platforms = lib.platforms.all;
  };
})
