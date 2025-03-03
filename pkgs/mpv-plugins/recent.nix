{
  mpvScripts,
  lib,
  fetchFromGitHub,
  unstableGitUpdater,
}:
mpvScripts.buildLua rec {
  pname = "mpv-recent";
  version = "bd0721470097165b8800b93f46aebaadd7751666";
  src = fetchFromGitHub {
    owner = "hacel";
    repo = "recent";
    rev = version;
    hash = "sha256-rC+2UEffV5YPKUjWUfWGIBOSeftpfGUQJtrSznw2++8=";
  };
  passthru.updateScript = unstableGitUpdater {};
  meta = {
    description = "Adds leader key";
    license = lib.licenses.mit;
    homepage = "https://github.com/Seme4eg/mpv-scripts";
  };
}
