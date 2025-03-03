{
  pkgs,
  username,
  ...
}: {
  programs.firefox = {
    enable = true;
    profiles = {
      ${username} = {
        id = 0;
        name = "${username}";
        path = "${username}.default";
        isDefault = true;
        settings = {
          "browser.cache.jsbc_compression_level" = 3;
          "dom.enable_web_task_scheduling" = true;
          "gfx.canvas.accelerated" = true;
          "gfx.canvas.accelerated.cache-item" = 4096;
          "gfx.canvas.accelerated.cache-size" = 512;
          "gfx.content.skia-font-cache-size" = 20;
          "image.mem.decode_bytes_at_a_time" = 32768;
          "media.cache_readahead_limit" = 7200;
          "media.cache_resume_threshold" = 3600;
          "media.memory_cache_max_size" = 65536;
          "network.dnsCacheExpiration" = 3600;
          "network.dns.disablePrefetch" = true;
          "network.dns.disablePrefetchFromHTTPS" = true;
          "network.http.max-connections" = 1800;
          "network.http.max-persistent-connections-per-server" = 10;
          "network.http.max-urgent-start-excessive-connections-per-host" = 5;
          "network.http.pacing.requests.enabled" = false;
          "network.predictor.enabled" = false;
          "network.prefetch-next" = false;
          "network.ssl_tokens_cache_capacity" = 10240;

          # Disable builtin MPRIS support in favor of Plasma Integration's one
          "media.hardwaremediakeys.enabled" = false;
          # Force enable account containers
          "privacy.userContext.enabled" = true;
          "privacy.userContext.ui.enabled" = true;
          # Enable SVG context-propertes
          "svg.context-properties.content.enabled" = true;
          # Enable customChrome.css
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;

          "uc.tweak.hide-tabs-bar" = true;
          "uc.tweak.hide-forward-button" = true;
          "uc.tweak.rounded-corners" = true;
          "uc.tweak.floating-tabs" = true;
        };
        userChrome = ''
          @import "${pkgs.EdgyArc}/EdgyAr/userChrome.css";
        '';
        userContent = ''
          @import "${pkgs.EdgyArc}/EdgyAr/userContent.css";
        '';
      };
    };
  };
}
