{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  fontconfig,
  freetype,
  libX11,
  libXft,
  lua,
  harfbuzz,
  gd,
  imlib2,
  pcre2,
  ncurses,
  writeText,
  conf ? null,
  patches ? [],
  extraLibs ? [],
  nixosTests,
  # update script dependencies
  gitUpdater,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "st";
  version = "0.1";

  src = fetchFromGitHub {
    owner = "DreamMaoMao";
    repo = "st-fl";
    rev = "59261746cf8d8c6d27a98bcc6b258c26980a9df7";
    hash = "sha256-sOqmf9YocBicBkQxE0CQT1zWCVNp7XpwlFQ2rjk9YnI=";
  };

  allowSubstitutes = false;
  preferLocalBuild = true;

  outputs = ["out" "terminfo"];

  inherit patches;

  configFile =
    lib.optionalString (conf != null)
    (writeText "config.def.h" conf);

  postPatch =
    lib.optionalString (conf != null) "cp ${finalAttrs.configFile} config.def.h"
    + lib.optionalString stdenv.isDarwin ''
      substituteInPlace config.mk --replace "-lrt" ""
    '';

  strictDeps = true;

  makeFlags = [
    "PKG_CONFIG=${stdenv.cc.targetPrefix}pkg-config"
  ];

  nativeBuildInputs = [
    pkg-config
    ncurses
    fontconfig
    freetype
  ];
  buildInputs =
    [
      libX11
      libXft
      lua
      harfbuzz
      gd
      imlib2
      pcre2
    ]
    ++ extraLibs;

  preInstall = ''
    export TERMINFO=$terminfo/share/terminfo
    mkdir -p $TERMINFO $out/nix-support
    echo "$terminfo" >> $out/nix-support/propagated-user-env-packages
  '';

  installFlags = ["PREFIX=$(out)"];

  passthru = {
    tests.test = nixosTests.terminal-emulators.st;
    updateScript = gitUpdater {
      url = "https://github.com/DreamMaoMao/st-fl";
    };
  };

  meta = with lib; {
    homepage = "https://github.com/DreamMaoMao/st-fl";
    description = "Simple Terminal for X from Suckless.org Community";
    license = licenses.mit;
    maintainers = with maintainers; [qusic];
    platforms = platforms.unix;
    mainProgram = "st";
  };
})
