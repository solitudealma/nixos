{ lib
, buildPythonApplication
, fetchFromGitHub
, meson
, ninja
, fakeroot
, python3
, gtk4
, pkg-config
, appstream-glib
, desktop-file-utils
, unstable
, setuptools
, ...
}:

buildPythonApplication rec {
  pname = "waydroid-helper";
  version = "0.1.1";
  pyproject = false;
  src = fetchFromGitHub{
    owner = "ayasa520";
    repo = pname;
    rev = "93f98e7455ec4efe2010528619569a53d7c140a6";
    sha256 = "sha256-pJvRmFdsWBRjbxC0uJCMaVM8prSHIxa9hDM07mv8a3A=";
  };

  nativeBuildInputs = [
    meson
    ninja
    setuptools
    pkg-config
    gtk4
    appstream-glib
    desktop-file-utils
  ];

  buildInputs = [
    fakeroot
    gtk4
    unstable.libadwaita
  ];

  dependencies = with python3.pkgs; [
    bidict 
    httpx 
    pyyaml 
    pygobject3 
    pywayland 
    pycairo 
    aiofiles
  ];

  mesonFlags = [
    "-Dauto_features=enabled"
  ];
}