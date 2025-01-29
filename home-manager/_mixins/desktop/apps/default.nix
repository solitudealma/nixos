{
  config,
  desktop,
  lib,
  pkgs,
  username,
  ...
}: let
  inherit (builtins) listToAttrs;
  inherit (pkgs.stdenv) isLinux;
  inherit (lib.attrsets) mapAttrsToList nameValuePair;
  inherit (lib.lists) flatten;
  inherit (lib.options) mkOption;

  mkOpt = type: default: mkOption {inherit type default;};

  mkOpt' = type: default: description:
    mkOption {inherit type default description;};

  cfg = config._custom.globals.mimeApps;
  applications = let
    inherit
      (cfg.applications)
      audioPlayer
      browser
      documentViewer
      editor
      fileManager
      imageViewer
      pdfViewer
      terminal
      torrentCli
      videoPlayer
      ;
  in {
    audio = [audioPlayer];
    browser = [browser];
    compression = [fileManager];
    directory = [fileManager];
    document = [documentViewer];
    editor = editor;
    image = [imageViewer];
    magnet = [torrentCli];
    mail = [browser];
    pdf = [pdfViewer];
    text = editor;
    terminal = [terminal];
    video = [videoPlayer];
  };
in {
  imports =
    [
      ./audio-production
      ./fastfetch
      ./fcitx5
      ./firefox
      ./game-dev
      ./gitkraken
      ./heynote
      ./imv
      ./internet-chat
      ./jan
      ./meld
      ./mpd
      ./mpv
      ./music
      ./neovim
      ./obs-studio
      ./st
      ./vaults
      ./vscode
      ./yazi
      ./zathura
      ./zed-editor
      ./zsh
    ]
    ++ lib.optional (desktop == "river") ./waybar;

  options._custom.globals.mimeApps = let
    inherit (lib.options) mkEnableOption;
    inherit (lib.types) bool str listOf;
  in {
    enable = mkOption {
      type = bool;
      default = true;
    }; # mkEnableOption "default system applications";
    applications = {
      audioPlayer = mkOpt str "org.gnome.Decibels.desktop";
      browser = mkOpt str "firefox.desktop";
      documentViewer = mkOpt str "org.gnome.Papers.desktop";
      editor = mkOpt (listOf str) ["nvim.desktop" "code.desktop" "code-insiders.desktop"];
      fileManager = mkOpt str "thunar.desktop";
      imageViewer = mkOpt str "imv.desktop";
      pdfViewer = mkOpt str "org.pwmt.zathura-pdf-mupdf.desktop";
      videoPlayer = mkOpt str "mpv.desktop";
      terminal = mkOpt str "st.desktop";
      torrentCli = mkOpt str "transmission-gtk.desktop";
    };
  };

  config = lib.mkIf cfg.enable {
    home = {
      packages = with pkgs;
        lib.optionals isLinux [
          imv # image viewer
          decibels # audio player
          gnome-calculator # calcualtor
          papers # document viewer

          xdg-utils # provides cli tools such as `xdg-mime` `xdg-open`
          xdg-user-dirs
        ];
    };
    xdg = lib.mkIf isLinux {
      cacheHome = "/home/${username}/.cache";
      configHome = "/home/${username}/.config";

      configFile."mimeapps.list".force = true;
      dataHome = "/home/${username}/.local/share";

      enable = true;
      mime.enable = true;
      mimeApps = {
        enable = true;
        associations.added = let
          mimeMap = {
            audio = builtins.map (x: "audio/" + x) [
              #audio/3gpp;audio/3gpp2;audio/aac;audio/ac3;audio/AMR;audio/AMR-WB;audio/basic;audio/dv;audio/eac3;audio/flac;audio/m4a;audio/midi;audio/mp1;audio/mp2;audio/mp3;audio/mp4;audio/mpeg;audio/mpegurl;audio/mpg;audio/ogg;audio/opus;audio/prs.sid;audio/scpls;audio/vnd.rn-realaudio;audio/wav;audio/webm;audio/x-aac;audio/x-aiff;audio/x-ape;audio/x-flac;audio/x-gsm;audio/x-it;audio/x-m4a;audio/x-matroska;audio/x-mod;audio/x-mp1;audio/x-mp2;audio/x-mp3;audio/x-mpg;audio/x-mpeg;audio/x-mpegurl;audio/x-ms-asf;audio/x-ms-asx;audio/x-ms-wax;audio/x-ms-wma;audio/x-musepack;audio/x-pn-aiff;audio/x-pn-au;audio/x-pn-realaudio;audio/x-pn-realaudio-plugin;audio/x-pn-wav;audio/x-pn-windows-acm;audio/x-realaudio;audio/x-real-audio;audio/x-s3m;audio/x-sbc;audio/x-scpls;audio/x-shorten;audio/x-speex;audio/x-stm;audio/x-tta;audio/x-wav;audio/x-wavpack;audio/x-vorbis;audio/x-vorbis+ogg;audio/x-xm;
              "mpeg"
              "wav"
              "x-aac"
              "x-aiff"
              "x-ape"
              "x-flac"
              "x-m4a"
              "x-m4b"
              "x-mp1"
              "x-mp2"
              "x-mp3"
              "x-mpg"
              "x-mpeg"
              "x-mpegurl"
              "x-opus+ogg"
              "x-pn-aiff"
              "x-pn-au"
              "x-pn-wav"
              "x-speex"
              "x-vorbis"
              "x-vorbis+ogg"
              "x-wavpack"
              "3gpp"
              "3gpp2"
              "acc"
              "ac3"
              "amr"
              "amr-wb"
              "basic"
              "dv"
              "eac3"
              "flac"
              "m4a"
              "midi"
              "mp1"
              "mp2"
              "mp3"
              "mp4"
              "mpegurl"
              "mpg"
              "ogg"
              "opus"
              "scpls"
              "vnd.dolby.heaac.1"
              "vnd.dolby.heaac.2"
              "vnd.dolby.mlp"
              "vnd.dts"
              "vnd.dts.hd"
              "vnd.rn-realaudio"
              "wav;audio/webm"
              "x-gsm"
              "x-it"
              "x-matroska"
              "x-mod"
              "x-ms-asf"
              "x-ms-wma"
              "x-musepack"
              "x-pn-realaudio"
              "x-real-audio"
              "x-realaudio"
              "x-s3m"
              "x-scpls"
              "x-shorten"
              "x-tta"
              "x-wav"
              "x-xm"
            ];
            browser =
              builtins.map (x: "x-scheme-handler/" + x) [
                "about"
                "ftp"
                "http"
                "https"
                "unknown"
              ]
              ++ builtins.map (x: "application/" + x) [
                "x-extension-htm"
                "x-extension-html"
                "x-extension-shtml"
                "x-extension-xht"
                "x-extension-xhtml"
                "xhtml+xml"
                "xml"
                "xhtml_xml"
                "rdf+xml"
                "rss+xml"
              ]
              ++ ["text/html"];
            # calendar = [ "text/calendar" "x-scheme-handler/webcal" ];
            compression = builtins.map (x: "application/" + x) [
              "x-7z-compressed"
              "x-7z-compressed-tar"
              "x-bzip"
              "x-bzip-compressed-tar"
              "x-compress"
              "x-compressed-tar"
              "x-cpio"
              "x-gzip"
              "x-lha"
              "x-lzip"
              "x-lzip-compressed-tar"
              "x-lzma"
              "x-lzma-compressed-tar"
              "x-tar"
              "x-tarz"
              "x-xar"
              "x-xz"
              "x-xz-compressed-tar"
              "zip"
              "gzip"
              "bzip2"
              "vnd.rar"
            ];
            directory = ["inode/directory" "inode/mount-point"];
            document =
              builtins.map (x: "application/" + x) [
                "vnd.comicbook-rar"
                "vnd.comicbook+zip"
                "x-cb7"
                "x-cbr"
                "x-cbt"
                "x-cbz"
                "x-ext-cb7"
                "x-ext-cbr"
                "x-ext-cbt"
                "x-ext-cbz"
                "x-ext-djv"
                "x-ext-djvu"
                "x-bzpdf"
                "x-ext-pdf"
                "x-gzpdf"
                "x-xzpdf"
                "postscript"
                "x-bzpostscript"
                "x-gzpostscript"
                "x-ext-eps"
                "x-ext-ps"
                "vnd.ms-xpsdocument"
                "illustrator"
              ]
              ++ builtins.map (x: "image/" + x) [
                "x-bzeps"
                "x-eps"
                "x-gzeps"
                "vnd.djvu"
              ];
            image = builtins.map (x: "image/" + x) [
              "bmp"
              "gif"
              "jpeg"
              "jpg"
              "png"
              "svg+xml"
              "tiff"
              "vnd.microsoft.icon"
              "webp"
              "pjpeg"
              "x-tga"
              "vnd-ms.dds"
              "x-dds"
              "bmp"
              "x-bmp"
              "vnd.microsoft.icon"
              "vnd.radiance"
              "x-exr"
              "x-pcx"
              "x-png"
              "x-portable-bitmap"
              "x-portable-graymap"
              "x-portable-pixmap"
              "x-portable-anymap"
              "x-qoi;image/svg+xml"
              "x-xbitmap"
              "svg+xml-compressed"
              "avif"
              "heic"
              "heif"
              "jxl"
            ];
            editor = [
              "text/plain"
              "application/x-wine-extension-ini"
            ];
            pdf = ["application/pdf" "application/epub+zip" "application/x-fictionbook" "application/oxps"];
            video =
              builtins.map (x: "video/" + x) [
                "mp2t"
                "mp4"
                "mpeg"
                "ogg"
                "webm"
                "x-flv"
                "x-matroska"
                "x-msvideo"
                "3gp"
                "3gpp"
                "3gpp2"
                "divx"
                "fli"
                "flv"
                "mp2t"
                "mp4"
                "mp4v-es"
                "mpeg"
                "mpeg-system"
                "msvideo"
                "ogg"
                "quicktime"
                "vnd.mpegurl"
                "vnd.rn-realvideo"
                "webm"
                "x-avi"
                "x-flc"
                "x-fli"
                "x-flv"
                "x-m4v"
                "x-matroska"
                "x-mpeg"
                "x-mpeg-system"
                "x-mpeg2"
                "x-ms-asf"
                "x-ms-wm"
                "x-ms-wmv"
                "x-ms-wmx"
                "x-msvideo"
                "x-nsv"
                "x-ogm+ogg"
                "x-theora"
                "x-theora+ogg"
                "dv"
                "vivo"
                "vnd.divx"
                "vnd.vivo"
                "x-anim"
                "x-flic"
                "x-ms-asf-plugin"
                "x-ms-asx"
                "x-ms-wvx"
                "x-totem-stream"
              ]
              ++ builtins.map (x: "application/" + x) [
                "mxf"
                "mpeg4-iod"
                "mpeg4-muxcodetable"
                "ogg"
                "ram"
                "streamingmedia"
                "sdp"
                "smil"
                "smil+xml"
                "vnd.apple.mpegurl"
                "vnd.ms-asf"
                "vnd.ms-wpl"
                "vnd.rn-realmedia"
                "vnd.rn-realmedia-vbr"
                "x-extension-mp4"
                "x-extension-m4a"
                "x-flac"
                "x-flash-video"
                "x-matroska"
                "x-netshow-channel"
                "x-ogg"
                "x-quicktime-media-link"
                "x-quicktimeplayer"
                "x-shorten"
                "x-smil"
                "x-streamingmedia"
                "xspf+xml"
              ]
              ++ builtins.map (x: "x-scheme-handler/" + x) [
                "pnm"
                "net"
                "uvox"
                "icy"
                "icyx"
                "mms"
                "mmsh"
                "rtmp"
                "rtp"
                "rtsp"
              ]
              ++ builtins.map (x: "x-content/" + x) [
                "audio-cdda"
                "audio-player"
                "video-dvd"
                "video-vcd"
                "video-svcd"
              ]
              ++ [
                "ideo/dv"
              ];
          };
        in
          listToAttrs (flatten (mapAttrsToList (key: types:
            map (type: nameValuePair type (applications."${key}")) types)
          mimeMap));
        defaultApplications = let
          mimeMap = {
            audio = builtins.map (x: "audio/" + x) [
              "aac"
              "mpeg"
              "ogg"
              "opus"
              "wav"
              "webm"
              "x-matroska"
            ];
            browser = builtins.map (x: "x-scheme-handler/" + x) [
              "about"
              "ftp"
              "http"
              "https"
              "unknown"
            ];
            # calendar = [ "text/calendar" "x-scheme-handler/webcal" ];
            compression = builtins.map (x: "application/" + x) [
              "bzip2"
              "gzip"
              "vnd.rar"
              "x-7z-compressed"
              "x-7z-compressed-tar"
              "x-bzip"
              "x-bzip-compressed-tar"
              "x-compress"
              "x-compressed-tar"
              "x-cpio"
              "x-gzip"
              "x-lha"
              "x-lzip"
              "x-lzip-compressed-tar"
              "x-lzma"
              "x-lzma-compressed-tar"
              "x-tar"
              "x-tarz"
              "x-xar"
              "x-xz"
              "x-xz-compressed-tar"
              "zip"
            ];
            directory = ["inode/directory" "inode/mount-point"];
            image = builtins.map (x: "image/" + x) [
              "bmp"
              "gif"
              "jpeg"
              "jpg"
              "png"
              "svg+xml"
              "tiff"
              "vnd.microsoft.icon"
              "webp"
            ];
            magnet = ["x-scheme-handler/magnet"];
            mail = ["x-scheme-handler/mailto"];
            pdf = ["application/pdf"];
            text = ["text/plain"];
            terminal = ["x-scheme-handler/terminal"];
            video = builtins.map (x: "video/" + x) [
              "mp2t"
              "mp4"
              "mpeg"
              "ogg"
              "webm"
              "x-flv"
              "x-matroska"
              "x-msvideo"
            ];
          };
        in
          listToAttrs (flatten (mapAttrsToList (key: types:
            map (type: nameValuePair type (applications."${key}")) types)
          mimeMap));
        # {

        #   "x-scheme-handler/vscode" = ["code-url-handler.desktop"]; # open `vscode://` url with `code-url-handler.desktop`
        #   "x-scheme-handler/vscode-xsiders" = ["code-insiders-url-handler.desktop"]; # open `vscode-insiders://` url with `code-insiders-url-handler.desktop`
        #   # "x-scheme-handler/unknown" = editor;
        #   "x-scheme-handler/element" = ["element-desktop.desktop"];
        #   "x-scheme-handler/discord" = ["discord.desktop"];
        #   "x-scheme-handler/tg" = ["org.telegram.desktop.desktop"];
        # };
      };
      stateHome = "/home/${username}/.local/state";
    };
  };
}
