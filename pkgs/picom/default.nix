{
  asciidoc,
  dbus,
  fetchFromGitHub,
  hicolor-icon-theme,
  lib,
  libconfig,
  libev,
  libGL,
  libX11,
  libxcb,
  libXext,
  makeWrapper,
  meson,
  ninja,
  pcre,
  pixman,
  pkg-config,
  stdenv,
  uthash,
  xcbutilimage,
  xcbutilrenderutil,
  xorgproto,
  xwininfo,
  withDebug ? false,
  versionCheckHook,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "picom";
  version = "v9";

  # src = fetchFromGitHub {
  #   owner = "yaocccc";
  #   repo = "picom";
  #   rev = "eddcf51dc10182b50cdbb22f11f155a836a8aa53";
  #   hash = "sha256-5pHd9y4RENCciwx0yG8Sz4Oi1gPjMFcQ7lBKgRR2NAA=";
  # };

  src = fetchFromGitHub {
    owner = "DreamMaoMao";
    repo = "mypicom";
    rev = "8a4570782c31b1d739922bc6bfef95252280db26";
    hash = "sha256-cvf80q1o+YUao+EHsogBTAVP6v1JThiLyOfc9UnniOU=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    asciidoc
    makeWrapper
    meson
    ninja
    pkg-config
    xorgproto
  ];

  buildInputs = [
    dbus
    hicolor-icon-theme
    libconfig
    libev
    libGL
    libX11
    libxcb
    libXext
    pcre
    pixman
    uthash
    xcbutilimage
    xcbutilrenderutil
  ];

  # Use "debugoptimized" instead of "debug" so perhaps picom works better in
  # normal usage too, not just temporary debugging.
  mesonBuildType =
    if withDebug
    then "debugoptimized"
    else "release";
  dontStrip = withDebug;

  mesonFlags = [
    "-Dwith_docs=true"
  ];

  installFlags = ["PREFIX=$(out)"];

  # In debug mode, also copy src directory to store. If you then run `gdb picom`
  # in the bin directory of picom store path, gdb finds the source files.
  postInstall =
    ''
      wrapProgram $out/bin/picom-trans \
        --prefix PATH : ${lib.makeBinPath [xwininfo]}
    ''
    + lib.optionalString withDebug ''
      cp -r ../src $out/
    '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script {};
  };

  meta = {
    description = "Fork of XCompMgr, a sample compositing manager for X servers";
    license = lib.licenses.mit;
    longDescription = ''
      A fork of XCompMgr, which is a sample compositing manager for X
      servers supporting the XFIXES, DAMAGE, RENDER, and COMPOSITE
      extensions. It enables basic eye-candy effects. This fork adds
      additional features, such as additional effects, and a fork at a
      well-defined and proper place.

      The package can be installed in debug mode as:

        picom.override { withDebug = true; }

      For gdb to find the source files, you need to run gdb in the bin directory
      of picom package in the nix store.
    '';
    homepage = "https://github.com/yshui/picom";
    mainProgram = "picom";
    maintainers = with lib.maintainers; [
      ertes
      gepbird
      thiagokokada
      twey
    ];
    platforms = lib.platforms.linux;
  };
})
