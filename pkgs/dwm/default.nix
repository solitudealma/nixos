{
  lib,
  stdenv,
  fetchgit,
  libX11,
  libXinerama,
  libXft,
  writeText,
  patches ? [],
  conf ? null,
  # update script dependencies
  gitUpdater,
}:
stdenv.mkDerivation {
  pname = "dwm";
  version = "6.5";

  src = fetchgit {
    url = "file:///home/solitudealma/.config/dwm/src";
    rev = "4aa81320663ebf368786766cbca2c7faefdb705c";
  };

  buildInputs = [
    libX11
    libXinerama
    libXft
  ];

  prePatch = ''
    sed -i "s@/usr/local@$out@" config.mk
  '';

  # Allow users set their own list of patches
  inherit patches;

  # Allow users to set the config.def.h file containing the configuration
  postPatch = let
    configFile =
      if lib.isDerivation conf || builtins.isPath conf
      then conf
      else writeText "config.def.h" conf;
  in
    lib.optionalString (conf != null) "cp ${configFile} config.def.h";

  makeFlags = ["CC=${stdenv.cc.targetPrefix}cc"];

  passthru.updateScript = gitUpdater {
    url = "git://git.suckless.org/dwm";
  };

  meta = with lib; {
    homepage = "https://dwm.suckless.org/";
    description = "Extremely fast, small, and dynamic window manager for X";
    longDescription = ''
      dwm is a dynamic window manager for X. It manages windows in tiled,
      monocle and floating layouts. All of the layouts can be applied
      dynamically, optimising the environment for the application in use and the
      task performed.
      Windows are grouped by tags. Each window can be tagged with one or
      multiple tags. Selecting certain tags displays all windows with these
      tags.
    '';
    license = licenses.mit;
    maintainers = with maintainers; [neonfuz];
    platforms = platforms.all;
    mainProgram = "dwm";
  };
}
