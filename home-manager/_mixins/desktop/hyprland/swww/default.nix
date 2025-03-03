{pkgs, ...}: let
  name = "swww-randomize";
  shellApplication = pkgs.writeShellApplication {
    inherit name;
    runtimeInputs = with pkgs; [
      bc
      coreutils-full
      swww
    ];
    text = builtins.readFile ./${name}.sh;
  };
in {
  home.packages = with pkgs; [
    swww
    shellApplication
  ];
}
