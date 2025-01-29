{
  stdenvNoCC,
  lib,
  fetchFromGitHub,
}:
stdenvNoCC.mkDerivation rec {
  pname = "oh-my-rime";
  version = "1.0";
  
  src = fetchFromGitHub {
    owner = "Mintimate";
    repo = "oh-my-rime";
    rev = "ec9ede2e05a36c9214fd5adfc1645e0b72181e90";
    sha256 = "sha256-awpjFT38zMXPV0nhBacIFaMP7HhqWgM7jr+kt/Cc88c=";
  };

  # buildPhase = ''
  #   runHook preBuild

  #   mv default.yaml rime_mint_suggestion.yaml

  #   runHook postBuild
  # '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/rime-data
    cp -r * $out/share/rime-data/

    runHook postInstall
  '';

  meta = {
    maintainers = with lib.maintainers; [ solitudealma ];
    description = "Rime 配置：薄荷拼音 | 长期维护的简体词库";
    homepage = "https://www.mintimate.cc";
    license = lib.licenses.gpl3Only;
  };
}