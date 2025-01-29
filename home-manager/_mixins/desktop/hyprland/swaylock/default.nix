{
  config,
  lib,
  pkgs,
  ...
}:
{
  programs.swaylock = {
    enable = true;
    package = pkgs.unstable.swaylock;
    settings = {
      bs-hl-color="2f7b0995";

      caps-lock-key-hl-color="ffd20455";
      caps-lock-bs-hl-color="dedede55";

      font="Maple Mono NF CN";
      # font-size=120;

      key-hl-color="AE5E4595";
      
      ignore-empty-password = true;

      image="~/Pictures/Wallpapers/79028211_p0.png";
      
      indicator-caps-lock = true;
      indicator-radius=265;
      indicator-x-position=400;
      indicator-y-position=550;

      inside-color="00000000";
      inside-clear-color="00000000";
      inside-caps-lock-color="00000000";
      inside-ver-color="00000000";
      inside-wrong-color="00000000";
      
      line-color="00000000";
      line-clear-color="00000000";
      line-caps-lock-color="00000000";
      line-ver-color="00000000";
      line-wrong-color="00000000";

      ring-color="4A6C7555";
      ring-clear-color="4A6C7555";
      ring-caps-lock-color="4A6C7555";
      ring-ver-color="4A6C7555";
      ring-wrong-color="4A6C7555";
      
      text-caps-lock-color="009ddc55";
      text-clear-color="2f7b09D9";
      text-color="452324";
      text-ver-color="a07404ff";
      text-wrong-color="e82020cf";

      scaling="fill";
      show-failed-attempts = true;
      show-keyboard-layout = true;
    };
  };
}
