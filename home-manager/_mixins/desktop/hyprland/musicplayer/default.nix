{pkgs, ...}: let
  name = "music_player";
  shellApplication = pkgs.writeShellApplication {
    inherit name;
    runtimeInputs = with pkgs; [
      bc
      coreutils-full
      xorg.xrandr
    ];
    text = builtins.readFile ./${name}.sh;
  };
in {
  home.packages = with pkgs; [
    shellApplication
    ncmpcpp
  ];
}
