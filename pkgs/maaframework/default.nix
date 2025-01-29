{
  fetchurl,
  fetchFromGitHub,
  pkg-config,
  stdenv,
  lib,
  cmake,
}: let
  maadepsdev = fetchurl {
    url = "https://github.com/MaaXYZ/MaaDeps/releases/download/v2.7.1/MaaDeps-x64-linux-devel.tar.xz";
    hash = "sha256-gneNVcaAmiXavMUgRBUnTajkgjQeOMnbQ9jDoghx+lY=";
  };
  maadepsruntime = fetchurl {
    url = "https://github.com/MaaXYZ/MaaDeps/releases/download/v2.7.1/MaaDeps-x64-linux-runtime.tar.xz";
    hash = "sha256-iz51FZKqPY8yYA7cilfqIH8W2Oyz33tH5qEOHNB0ny4=";
  };
in
  stdenv.mkDerivation rec {
    pname = "MaaFramework";
    version = "2.2.2";
    src = fetchFromGitHub {
      owner = "MaaXYZ";
      repo = pname;
      rev = "ab0dcffc02650d722fed59eb5e6d994e3240c010";
      fetchSubmodules = true;
      sha256 = "sha256-zfjcK18u2qBD6eXf6wUTjBbEP35HT7jX5upl1OrUxaI=";
    };

    nativeBuildInputs = [
      pkg-config
      cmake
    ];

    preConfigure = ''
      mkdir -p 3rdparty/MaaDeps/tarball
      tar xf ${maadepsdev} -C 3rdparty/MaaDeps/
      tar xf ${maadepsruntime} -C 3rdparty/MaaDeps/
    '';
  }
