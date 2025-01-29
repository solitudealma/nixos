{
  lib,
  stdenv,
  fetchFromGitHub,
  ffmpeg,
  fftwFloat,
  chafa,
  libnotify,
  libogg,
  faad2,
  taglib,
  libvorbis,
  opusfile,
  libopus,
  glib,
  pkg-config,
  cmake,
  glibc,
  zlib,
  utf8cpp,
  gcc,
  testers,
}:
stdenv.mkDerivation rec {
  pname = "kew";
  version = "3.0.1";

  src = fetchFromGitHub {
    owner = "ravachol";
    repo = "kew";
    rev = "v${version}";
    hash = "sha256-CvnfxUd+S7hL6VdukS0mS4k+epKlMN1N8PP9nnyIeDY=";
  };

  nativeBuildInputs = [pkg-config];
  buildInputs = [libvorbis opusfile taglib libogg faad2 fftwFloat chafa glib];

  installFlags = [
    "MAN_DIR=${placeholder "out"}/share/man"
    "PREFIX=${placeholder "out"}"
  ];

  meta = with lib; {
    description = "Command-line music player for Linux";
    homepage = "https://github.com/ravachol/kew";
    platforms = platforms.linux;
    license = licenses.gpl2Only;
    maintainers = with maintainers; [demine];
    mainProgram = "kew";
  };
}
