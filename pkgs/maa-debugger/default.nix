{
  lib,
  pkg-config,
  fetchFromGitHub,
  buildPythonPackage,
  pdm-backend,
  zstd,
  pytest,
}:
buildPythonPackage rec {
  pname = "MaaDebugger";
  version = "1.3.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "MaaXYZ";
    repo = pname;
    rev = "54608380cdd7aef6af7011397c37ecf10121a014";
    sha256 = "sha256-DKuo09xFNPVdn3vBb0xfA0F1dCbTg5Vd6D3qMxgQM9k=";
    fetchSubmodules = false;
  };

  nativeCheckInputs = [pytest pdm-backend];
  checkPhase = ''
    pytest
  '';
}
