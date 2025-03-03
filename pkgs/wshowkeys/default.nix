{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  pkg-config,
  wayland-scanner,
  ninja,
  cairo,
  libinput,
  pango,
  wayland,
  wayland-protocols,
  libxkbcommon,
}:
stdenv.mkDerivation rec {
  pname = "wshowkeys-unstable";
  version = "2024-07-03";

  src = fetchFromGitHub {
    owner = "DreamMaoMao";
    repo = "wshowkeys";
    rev = "24364e5f40b7ccbed728fe88757f559d84fae234";
    sha256 = "sha256-I1nnwaE1Wr1b5EzQ4CP5sDCY8ZBaxP2FYZdIsKcVXL4=";
  };

  strictDeps = true;
  nativeBuildInputs = [
    meson
    pkg-config
    wayland-scanner
    ninja
  ];
  buildInputs = [
    cairo
    libinput
    pango
    wayland
    wayland-protocols
    libxkbcommon
  ];

  meta = with lib; {
    description = "Displays keys being pressed on a Wayland session";
    longDescription = ''
      Displays keypresses on screen on supported Wayland compositors (requires
      wlr_layer_shell_v1 support).
      Note: This tool requires root permissions to read input events, but these
      permissions are dropped after startup. The NixOS module provides such a
      setuid binary (use "programs.wshowkeys.enable = true;").
    '';
    homepage = "https://github.com/ammgws/wshowkeys";
    license = with licenses; [
      gpl3Only
      mit
    ];
    # Some portions of the code are taken from Sway which is MIT licensed.
    # TODO: gpl3Only or gpl3Plus (ask upstream)?
    platforms = platforms.linux;
    maintainers = with maintainers; [
      primeos
      berbiche
    ];
    mainProgram = "wshowkeys";
  };
}
