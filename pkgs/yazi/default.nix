{
  rustPlatform,
  fetchFromGitHub,
  lib,
  installShellFiles,
  stdenv,
  Foundation,
  rust-jemalloc-sys,
}:
rustPlatform.buildRustPackage {
  pname = "yazi";
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "sxyazi";
    repo = "yazi";
    rev = "c061397a09bb08e293317f5b93dc870d453af9ef";
    hash = "";
  };

  cargoHash = "";

  env.YAZI_GEN_COMPLETIONS = true;
  env.VERGEN_GIT_SHA = "Nixpkgs";
  env.VERGEN_BUILD_DATE = "2025-01-29";

  nativeBuildInputs = [installShellFiles];
  buildInputs = [rust-jemalloc-sys] ++ lib.optionals stdenv.hostPlatform.isDarwin [Foundation];

  postInstall = ''
    installShellCompletion --cmd yazi \
      --bash ./yazi-boot/completions/yazi.bash \
      --fish ./yazi-boot/completions/yazi.fish \
      --zsh  ./yazi-boot/completions/_yazi

    install -Dm444 assets/yazi.desktop -t $out/share/applications
    install -Dm444 assets/logo.png $out/share/pixmaps/yazi.png
  '';

  passthru.updateScript.command = [./update.sh];

  meta = {
    description = "Blazing fast terminal file manager written in Rust, based on async I/O";
    homepage = "https://github.com/sxyazi/yazi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      eljamm
      khaneliman
      linsui
      matthiasbeyer
      uncenter
      xyenon
    ];
    mainProgram = "yazi";
  };
}
