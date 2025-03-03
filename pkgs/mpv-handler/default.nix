{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage rec {
  pname = "mpv-handler";
  version = "0.3.13";

  src = fetchFromGitHub {
    owner = "akiirui";
    repo = "mpv-handler";
    rev = "v${version}";
    hash = "sha256-NSDcGzeO8+oPKs0xTE6qcZsT/huhcQLBFuAqLg3tyMs=";
  };

  cargoHash = "sha256-3dFqDz+nnE46MAKN07IPLSUqPMByJ7yVsKdXidcdeSg=";

  postInstall = ''
    install -Dm444 -t $out/share/applications share/linux/mpv-handler.desktop
    install -Dm444 -t $out/share/applications share/linux/mpv-handler-debug.desktop
  '';

  meta = {
    description = "A protocol handler for mpv. Use mpv and yt-dlp to play video and music from the websites";
    homepage = "https://github.com/akiirui/mpv-handler";
    license = lib.licenses.mit;
    mainProgram = "mpv-handler";
  };
}
