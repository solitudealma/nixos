{pkgs, ...}: {
  programs.imv = {
    enable = true;
    package = pkgs.imv;
    settings = {
      options = {
        overlay = false;
      };
      binds = {
        "<Ctrl+c>" = ''exec echo -n "$imv_current_file" | wl-copy'';
        i = "overlay";
        w = ''exec swww img "$imv_current_file" --resize crop --fill-color 000000 ''; # --filter Lanczos3 --transition-type random --transition-step 255 --transition-duration 2.4 --transition-fps 255 --transition-angle 45 --transition-pos center --transition-bezier .1,1,.1,.4 --transition-wave 20,20'';
        z = "zoom actual";
      };
    };
  };
}
