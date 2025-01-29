{pkgs, ...}: let
  name = "screenshot";
  shellApplication = pkgs.writeShellApplication {
    inherit name;
    runtimeInputs = with pkgs; [
      bc
      coreutils-full
      gojq
    ];
    text = builtins.readFile ./${name}.sh;
  };
in {
  # grimblast is a screenshot grabber and swappy is a screenshot editor
  # This config provide comprehensive screenshot functionality for hyprland
  home = {
    packages = with pkgs; [
      grim
      satty # screenshot editor
      slurp
      shellApplication
    ];
  };
}
