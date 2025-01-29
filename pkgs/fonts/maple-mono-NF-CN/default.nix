{
  lib,
  stdenv,
  unzip,
  fetchurl,
}:
stdenv.mkDerivation rec {
  pname = "MapleMono-NF-CN";
  sha256 = "sha256-Og8dpTa/BGV54rKwShBue93OWNzESnEkJccAg9yqai4=";
  desc = "Nerd Font CN";
  version = "7.0-beta35";

  src = fetchurl {
    url = "https://github.com/subframe7536/maple-font/releases/download/v${version}/${pname}.zip";
    inherit sha256;
  };

  # Work around the "unpacker appears to have produced no directories"
  # case that happens when the archive doesn't have a subdirectory.
  sourceRoot = ".";
  nativeBuildInputs = [unzip];
  installPhase = ''
    find . -name '*.ttf'    -exec install -Dt $out/share/fonts/truetype {} \;
    find . -name '*.otf'    -exec install -Dt $out/share/fonts/opentype {} \;
    find . -name '*.woff2'  -exec install -Dt $out/share/fonts/woff2 {} \;
  '';

  meta = with lib; {
    homepage = "https://github.com/subframe7536/Maple-font";
    description = ''
      Open source ${desc} font with round corner and ligatures for IDE and command line
    '';
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = with maintainers; [oluceps];
  };
}
