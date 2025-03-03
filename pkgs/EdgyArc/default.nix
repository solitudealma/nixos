{
  lib,
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation rec {
  pname = "EdgyArc-fr";
  version = "2ba31f414811324f218111c94586651456d89fdf";

  src = fetchFromGitHub {
    owner = "artsyfriedchicken";
    repo = pname;
    rev = version;
    hash = "sha256-KvzYDTMHZom9kDCGL9NMBH76s4kIgtOVG8hb88VfREY=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/EdgyArc-fr
    cp -r chrome/. $out/EdgyArc-fr

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/artsyfriedchicken/EdgyArc-fr";
    description = "A very shy little theme that hides the entire browser interface in the window border";
    license = with licenses; [mpl20];
    platforms = platforms.all;
  };
}
