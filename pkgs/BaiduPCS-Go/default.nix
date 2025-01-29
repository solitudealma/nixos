{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "BaiduPCS-Go";
  version = "3.9.7";

  src = fetchFromGitHub {
    owner = "qjfoidnh";
    repo = "BaiduPCS-Go";
    rev = "3bda04c82d6225347491dbfde0ca0270af61333b";
    hash = "sha256-PJTPBYm9C0wtw+o1Y8eh6oIyWZQWLEptIyqViK8nWYE=";
  };

  vendorHash = "sha256-hW+IrzS5+DublQUIIcecL08xoauTjba9qnAtpzNeDXw=";

  doCheck = false;
}
