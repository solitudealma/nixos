{inputs, ...}: {
  imports = [
    inputs.fum.homeManagerModules.fum
  ];

  programs.fum = {
    enable = true;
    players = ["ncmpcpp"];
    use_active_player = true;
  };
}
