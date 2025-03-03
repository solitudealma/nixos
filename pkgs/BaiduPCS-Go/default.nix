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
    rev = "345147bc2ae58c6499920fc1d205c4d5aee736df";
    hash = "sha256-KqRzxx3Cj5F+mK3npKGauV+JwJikDT37cDPm4KFP/Go=";
  };

  vendorHash = "sha256-hW+IrzS5+DublQUIIcecL08xoauTjba9qnAtpzNeDXw=";

  doCheck = false;
}
