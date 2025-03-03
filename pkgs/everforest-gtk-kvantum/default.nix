{
  lib,
  stdenvNoCC,
  # fetchUrl,
  fetchFromGitHub,
  unstableGitUpdater,
}:
stdenvNoCC.mkDerivation
{
  pname = "everforest-gtk-kvantum";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "binEpilo";
    repo = "materia-everforest-kvantum";
    rev = "391eb1d917dab900dc1ef16ffdff1a4546308ee4";
    hash = "sha256-5ihKScPJMDU0pbeYtUx/UjC4J08/r40mAK7D+1TK6wA=";
  };
  # src = fetchUrl {
  #   url = "";
  #   hash = "sha256-eQmEeKC+L408ajlNg3oKMnDK6Syy2GV6FrR2TN5ZBCg=";
  # };

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/Kvantum
    cp -a MateriaEverforestDark $out/share/Kvantum
    runHook postInstall
  '';

  passthru.updateScript = unstableGitUpdater {};

  meta = {
    description = "Soothing pastel theme for Kvantum";
    homepage = "https://github.com/catppuccin/Kvantum";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = [lib.maintainers.bastaynav];
  };
}
