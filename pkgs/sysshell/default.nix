{
  fetchFromGitHub,
  fetchurl,
  pkg-config,
  stdenv,
  lib,
  libevdev,
  gtkmm4,
  glibmm,
  gtk4-layer-shell,
  git,
  gtk-session-lock,
  pam,
  kdePackages,
  wrapGAppsHook4,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "sysshell";
  version = "0-unstable-2024-11-17";
  src = fetchFromGitHub {
    owner = "System64fumo";
    repo = finalAttrs.pname;
    rev = "599da9ffed8d79047b750470562324e7bb94ca88";
    sha256 = "sha256-b2j3IQIZr1VNRPVXzFl1ADUw+YEfN6AXEQsNiyFykQc=";
  };

  postPatch = ''
    substituteInPlace Makefile \
      --replace-fail pkg-config ''${PKG_CONFIG}
    substituteInPlace src/main.cpp \
      --replace-fail "/usr/share/sys64/shell/config.conf" "$out/share/sys64/shell/config.conf"
    substituteInPlace src/libs/sysbar.cpp \
      --replace-fail "/usr/share/sys64/bar/config.con" "$out/share/sys64/bar/config.conf"
    substituteInPlace src/libs/syshud.cpp \
      --replace-fail "/usr/share/sys64/hud/config.con" "$out/share/sys64/hud/config.conf"
  '';

  makeFlags = [
    "DESTDIR=${placeholder "out"}"
    "PREFIX="
  ];

  nativeBuildInputs = [ 
    pkg-config
    libevdev
    gtkmm4
    pam
    gtk4-layer-shell
    gtk-session-lock
    wrapGAppsHook4
  ];

  buildInputs = [
    glibmm
    gtkmm4
  ];

  postInstall = ''
    wrapProgram $out/bin/sysshell --prefix LD_LIBRARY_PATH : $out/lib
  '';
})
