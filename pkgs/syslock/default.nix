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
let
  wayland-protocols = rec {
    pname = "wayland-protocols";
    version = "1.38";
    src = fetchurl {
      url = "https://gitlab.freedesktop.org/wayland/${pname}/-/releases/${version}/downloads/${pname}-${version}.tar.xz";
      hash = "sha256-/xcpLAUVnSsgzmys/kLX4xooGY+hQpp2mwOvfDhYHb4=";
    };
  };
in

stdenv.mkDerivation (finalAttrs: {
  pname = "syslock";
  version = "0-unstable-2024-11-17";
  src = fetchFromGitHub {
    owner = "System64fumo";
    repo = finalAttrs.pname;
    rev = "8856cddbf205886a4c3b09f1669c0e6b8e435dbb";
    sha256 = "sha256-YC1G00bSTMyjC0vhZ3yxMzs3Jnb2oDnfHwtfDkRofbY=";
  };

  configurePhase = ''
    runHook preConfigure

    echo '#define GIT_COMMIT_MESSAGE "${finalAttrs.src.rev}"' >> src/git_info.hpp
    echo '#define GIT_COMMIT_DATE "${lib.removePrefix "0-unstable-" finalAttrs.version}"' >> src/git_info.hpp

    runHook postConfigure
  '';

  postPatch = ''
    tar xf ${wayland-protocols.src}
    substituteInPlace Makefile \
      --replace-fail "/usr/share/wayland-protocols/staging/ext-session-lock" "${wayland-protocols.pname}-${wayland-protocols.version}/staging/ext-session-lock" \
      --replace-fail pkg-config ''${PKG_CONFIG}
    substituteInPlace src/main.cpp \
      --replace-fail "/usr/share/sys64/lock/config.conf" "$out/share/sys64/lock/config.conf"
    substituteInPlace src/window.cpp \
      --replace-fail "/usr/share/sys64/lock/style.css" "$out/share/sys64/lock/style.css"
  '';

  makeFlags = [
    "DESTDIR=${placeholder "out"}"
    "PREFIX="
  ];

  nativeBuildInputs = [ 
    pkg-config
    kdePackages.wayland-protocols
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
    wrapProgram $out/bin/syslock --prefix LD_LIBRARY_PATH : $out/lib
  '';
})
