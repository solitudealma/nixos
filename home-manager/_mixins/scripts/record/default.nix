{pkgs, ...}: let
  name = builtins.baseNameOf (builtins.toString ./.);
  shellApplication = pkgs.writeShellApplication {
    inherit name;
    runtimeInputs = with pkgs; [
      bc
      coreutils-full
      libnotify
      slurp
      wf-recorder
    ];
    text = builtins.readFile ./${name}.sh;
  };
in {
  home.packages = with pkgs; [shellApplication];
  programs.zsh.shellAliases = {
  };
}
