{pkgs, ...}: {
  home.packages = with pkgs; [
    dwl
  ];
}
