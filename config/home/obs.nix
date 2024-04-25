{
  config,
  pkgs,
  ...
}: let
  obsThemes = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "obs";
    rev = "9a78d89";
    sha256 = "sha256-8DjAjpYsC9lEHe6gt/B7YCyfqVPaA5Qg1hbIMyyx/ho=";
  };
in {
  programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [
      # screen capture
      # wlrobs
      # # obs-ndi
      # obs-vaapi
      # obs-nvfbc
      # obs-teleport
      # # obs-hyperion
      # droidcam-obs
      # obs-vkcapture
      # obs-gstreamer
      # obs-3d-effect
      # input-overlay
      # obs-multi-rtmp
      # obs-source-clone
      # obs-shaderfilter
      # obs-source-record
      # obs-livesplit-one
      # looking-glass-obs
      # obs-vintage-filter
      # obs-command-source
      # obs-move-transition
      # obs-backgroundremoval
      # advanced-scene-switcher
      # obs-pipewire-audio-capture
    ];
  };
  home.file = {
    ".config/obs-studio/themes".source = "${obsThemes}/themes";
  };
}
