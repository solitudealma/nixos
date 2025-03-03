{
  fetchFromGitHub,
  mpvScripts,
  lib,
}:
mpvScripts.buildLua {
  pname = "mpv-M-x-rofi";
  version = "2024-04-06";
  src = fetchFromGitHub {
    owner = "Seme4eg";
    repo = "mpv-scripts";
    rev = "e691bcebad9a352d31c42d3f1c9cc00a43ee14ca";
    hash = "sha256-FJw8FTFYTW6qYGOnQchqKpdr2+VIyJufqcOmhLeMchQ=";
  };
  scriptPath = "M-x-rofi.lua";

  meta = {
    description = "Adds leader key";
    license = lib.licenses.mit;
    homepage = "https://github.com/Seme4eg/mpv-scripts";
  };
}
