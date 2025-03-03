{
  lib,
  fetchFromGitea,
  fetchFromGitHub,
  installShellFiles,
  libX11,
  libinput,
  libxcb,
  libxkbcommon,
  pixman,
  pkg-config,
  stdenv,
  testers,
  wayland,
  wayland-protocols,
  wayland-scanner,
  wlroots,
  writeText,
  xcbutilwm,
  xwayland,
  # Boolean flags
  enableXWayland ? true,
  withCustomConfigH ? (configH != null),
  # Configurable options
  configH ?
    if conf != null
    then
      lib.warn ''
        conf parameter is deprecated;
        use configH instead
      ''
      conf
    else null,
  # Deprecated options
  # Remove them before next version of either Nixpkgs or dwl itself
  conf ? null,
  meson,
  ninja,
  cmake,
  wlroots_0_17,
}:
# If we set withCustomConfigH, let's not forget configH
assert withCustomConfigH -> (configH != null);
  stdenv.mkDerivation (finalAttrs: {
    pname = "dwl";
    version = "0.7";

    src = fetchFromGitHub {
      owner = "DreamMaoMao";
      repo = "plumewm";
      rev = "aef9a14cf996e2e3bf2565eb1f2726bebe674bc1";
      hash = "sha256-7ladqHpgEkgKsazRM3LPcE9p+XRhZeK7SqLHModfLvk=";
    };

    nativeBuildInputs = [
      installShellFiles
      pkg-config
      wayland-scanner
      meson
      ninja
      cmake
    ];

    buildInputs =
      [
        libinput
        libxcb
        libxkbcommon
        pixman
        wayland
        wayland-protocols
        wlroots_0_17
      ]
      ++ lib.optionals enableXWayland [
        libX11
        xcbutilwm
        xwayland
      ];

    postPatch = let
      configFile =
        if lib.isDerivation configH || builtins.isPath configH
        then configH
        else writeText "config.h" configH;
    in
      lib.optionalString withCustomConfigH "cp ${configFile} config.h";

    meta = {
      homepage = "https://codeberg.org/dwl/dwl";
      description = "Dynamic window manager for Wayland";
      longDescription = ''
        dwl is a compact, hackable compositor for Wayland based on wlroots. It is
        intended to fill the same space in the Wayland world that dwm does in X11,
        primarily in terms of philosophy, and secondarily in terms of
        functionality. Like dwm, dwl is:

        - Easy to understand, hack on, and extend with patches
        - One C source file (or a very small number) configurable via config.h
        - Tied to as few external dependencies as possible
      '';
      license = lib.licenses.gpl3Only;
      maintainers = [lib.maintainers.AndersonTorres];
      inherit (wayland.meta) platforms;
      mainProgram = "dwl";
    };
  })
# TODO: custom patches from upstream website

