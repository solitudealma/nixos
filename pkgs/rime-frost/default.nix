{ stdenv
, lib
, fetchFromGitHub
}:
stdenv.mkDerivation rec {
  pname = "rime-frost";
  version = "0.0.4.1";

  src = fetchFromGitHub {
    owner = "gaboolic";
    repo = "rime-frost";
    rev = "76b607f5ab8f2c733fecb1f14597eff62bd81043";
    hash = "sha256-Q2g60u9Qd+OhZuiP6dtnu/e3P4EjrUme/grw6euVILk=";
  };

  dontUnpack = true;
  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/rime-data
    cp $src/rime_frost.dict.yaml $out/share/rime-data/rime_frost.dict.yaml

    runHook postInstall
  '';
  meta = with lib; {
    description = "Fcitx 5 PinyinDictionary from rime-frost";
    homepage = "https://github.com/gaboolic/rime-frost";
    license = licenses.unlicense;
  };
}