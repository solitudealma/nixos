{
  config,
  lib,
  pkgs,
  ...
}: let
  adaptive-sharpen = pkgs.fetchurl {
    url = "https://gist.githubusercontent.com/igv/8a77e4eb8276753b54bb94c1c50c317e/raw/572f59099cd0e3eb5e321a6da0a3d90a7382e2dc/adaptive-sharpen.glsl";
    hash = "sha256-gn+z1mKsmpG0B16RF/5uHbwcBthZWbpxnNuVTft/uOQ=";
  };
  AMD_FSR = pkgs.fetchurl {
    url = "https://gist.githubusercontent.com/agyild/82219c545228d70c5604f865ce0b0ce5/raw/2623d743b9c23f500ba086f05b385dcb1557e15d/FSR.glsl";
    hash = "sha256-VthZf8a3v20T+MOyvfHNxDsGF11RdGqrRM8dyhaSm54=";
  };
  anime4k = pkgs.fetchFromGitHub {
    owner = "bloc97";
    repo = "Anime4K";
    rev = "7684e9586f8dcc738af08a1cdceb024cc184f426";
    hash = "sha256-F5/n/KmJ7iOiI0qcpwX6q8zvF4ACv6zcJTOxcAv6HSE=";
  };
  FSRCNNX_x2_8_0_4_1 = pkgs.fetchurl {
    url = "https://github.com/igv/FSRCNN-TensorFlow/releases/latest/download/FSRCNNX_x2_8-0-4-1.glsl";
    hash = "sha256-6ADbxcHJUYXMgiFsWXckUz/18ogBefJW7vYA8D6Nwq4=";
  };
  # FSRCNNX_x2_8_0_4_1_LineArt = pkgs.fetchurl {
  #   url = "https://raw.githubusercontent.com/dyphire/mpv-config/refs/heads/master/shaders/igv/FSRCNNX_x2_8-0-4-1_LineArt.glsl";
  #   hash = "";
  # };
  KrigBilateral = pkgs.fetchurl {
    url = "https://gist.githubusercontent.com/igv/a015fc885d5c22e6891820ad89555637/raw/038064821c5f768dfc6c00261535018d5932cdd5/KrigBilateral.glsl";
    hash = "sha256-ikeYq7d7g2Rvzg1xmF3f0UyYBuO+SG6Px/WlqL2UDLA=";
  };
  mpv-lazy = pkgs.fetchFromGitHub {
    owner = "hooke007";
    repo = "MPV_lazy";
    rev = "2fee5ee08b35347f16b97fbf809c223cd64ab8fb";
    hash = "sha256-wklxMBLKDTl+Xam3C2+HxKTzL1vmbIb+HdC0nmD3//E=";
  };
  mpv-prescalers = pkgs.fetchFromGitHub {
    owner = "bjin";
    repo = "mpv-prescalers";
    rev = "b3f0a59d68f33b7162051ea5970a5169558f0ea2";
    hash = "sha256-KfCFU3fa8Fr5G5zVqKS35CJBzTYMY72kep8+Kd0YIu4=";
  };
  SSimDownscaler = pkgs.fetchurl {
    url = "https://gist.githubusercontent.com/igv/36508af3ffc84410fe39761d6969be10/raw/38992bce7f9ff844f800820df0908692b65bb74a/SSimDownscaler.glsl";
    hash = "sha256-9G9HEKFi0XBYudgu2GEFiLDATXvgfO9r8qjEB3go+AQ=";
  };
  SSimSuperRes = pkgs.fetchurl {
    url = "https://gist.githubusercontent.com/igv/2364ffa6e81540f29cb7ab4c9bc05b6b/raw/15d93440d0a24fc4b8770070be6a9fa2af6f200b/SSimSuperRes.glsl";
    hash = "sha256-qLJxFYQMYARSUEEbN14BiAACFyWK13butRckyXgVRg8=";
  };
  bindings = import ./bindings.nix {
    inherit
      adaptive-sharpen
      AMD_FSR
      anime4k
      FSRCNNX_x2_8_0_4_1
      KrigBilateral
      mpv-lazy
      mpv-prescalers
      SSimDownscaler
      SSimSuperRes
      ;
  };
  mpvConfig = import ./config.nix {inherit config;};
  profiles = import ./profiles.nix {};
  scriptOpts = import ./scriptopts.nix {};
in {
  home = {
    file = {
      ".config/mpv-handler/config.toml".text = ''
        mpv = "${lib.getExe config.programs.mpv.package}"
        ytdl = "${lib.getExe pkgs.yt-dlp}"
      '';
      ".config/mpv-handler/cookies/www.bilibili.com.txt".text = ''
        .bilibili.com	TRUE	/	FALSE	1764826798	buvid3	B4042932-3492-395C-A240-A855D708DAF642169infoc
        .bilibili.com	TRUE	/	FALSE	1760086342	b_nut	1728550342
        .bilibili.com	TRUE	/	FALSE	1773739772	theme_style	light
        .bilibili.com	TRUE	/	FALSE	1760086343	_uuid	DC3661052-6FEC-C24C-D5C6-ACCCE27121071043300infoc
        .bilibili.com	TRUE	/	FALSE	1770715766	CURRENT_FNVAL	4048
        .bilibili.com	TRUE	/	FALSE	1744102404	sid	874vzm7r
        .bilibili.com	TRUE	/	FALSE	1773739768	buvid4	E52C4155-B9E1-0A2B-13A4-C8030D532E3843199-024101008-k0KW6YeDQXi7tfksoHgUXg%3D%3D
        .bilibili.com	TRUE	/	FALSE	1765518823	buvid_fp	811d1ad3f25a1992b614e122f3d3d938
        .bilibili.com	TRUE	/	FALSE	1764826798	rpdid	|(k|mYuk|)Rl0J'u~k)ll|JRR
        .bilibili.com	TRUE	/	TRUE	1744102404	SESSDATA	c1a2ab15%2C1744102404%2C74e51%2Aa1CjCrw5XAQahRabf3Q2ckbXqDVoviKn9gspahwIEwsjFwEOnytERLUJklflRmwXzKL4ISVnhnSDFRd3VYVkxnd3FMVVBoVnhodU9yTDQ2TzdqSVpwcVNGamNJQkV4TER2MDY3VHZoc1FuU3RPQzdWdWp3bDFGc0Z0LTAzMEhiT2JHQXB6emUzamJnIIEC
        .bilibili.com	TRUE	/	FALSE	1744102404	bili_jct	1b7a48cc769d6bf22b5114f942eb80cd
        .bilibili.com	TRUE	/	FALSE	1744102404	DedeUserID	20577412
        .bilibili.com	TRUE	/	FALSE	1744102404	DedeUserID__ckMd5	382a491a15dfe383
        .bilibili.com	TRUE	/	FALSE	1770648580	header_theme_version	CLOSE
        .bilibili.com	TRUE	/	FALSE	1770648580	enable_web_push	DISABLE
        .bilibili.com	TRUE	/	FALSE	1770648580	home_feed_column	5
        .bilibili.com	TRUE	/	FALSE	1770648580	browser_resolution	1641-887
        .bilibili.com	TRUE	/	FALSE	1761309382	CURRENT_QUALITY	80
        .bilibili.com	TRUE	/	FALSE	1763104838	fingerprint	08eb112dfcbfcea4471f3582237607e9
        .bilibili.com	TRUE	/	FALSE	1762305857	buvid_fp_plain	undefined
        .bilibili.com	TRUE	/	FALSE	1760160934	hit-dyn-v2	1
        .bilibili.com	TRUE	/	FALSE	1761603543	is-2022-channel	1
        .bilibili.com	TRUE	/	FALSE	1761603570	CURRENT_BLACKGAP	0
        .bilibili.com	TRUE	/	FALSE	1766151532	LIVE_BUVID	AUTO4417315915324773
        .bilibili.com	TRUE	/	FALSE	1770648580	enable_feed_channel	DISABLE
        .bilibili.com	TRUE	/	FALSE	1739285884	bili_ticket	eyJhbGciOiJIUzI1NiIsImtpZCI6InMwMyIsInR5cCI6IkpXVCJ9.eyJleHAiOjE3MzkyODU4ODMsImlhdCI6MTczOTAyNjYyMywicGx0IjotMX0.JbT0IIAgf8rhgY2uX8XMNBksQCXXuR23I8Q30bPjfW4
        .bilibili.com	TRUE	/	FALSE	1739285884	bili_ticket_expires	1739285823
        www.bilibili.com	FALSE	/	FALSE	0	bmg_af_switch	1
        .bilibili.com	TRUE	/	FALSE	0	b_lsid	F78FF384_194EEE7B592
        www.bilibili.com	FALSE	/	FALSE	0	bmg_src_def_domain	i2.hdslb.com
        .bilibili.com	TRUE	/	FALSE	0	bsource	search_google
      '';
    };
    packages = with pkgs; [
      mpv-handler
      trash-cli # for uosc to move file to trash
    ];
  };
  programs.mpv = {
    inherit
      bindings
      profiles
      scriptOpts
      ;
    config = mpvConfig;
    # defaultProfiles = ["gpu-hq"];
    enable = true;
    package = pkgs.mpv-unwrapped.wrapper {
      mpv = pkgs.mpv-unwrapped.override {
        vapoursynthSupport = true;
      };
      # youtubeSupport = true;
      scripts = with pkgs.mpvScripts;
        [
          mpris
          mpv-notify-send
          thumbfast
          (uosc.overrideAttrs (old: rec {
            version = "5.7.0";
            src = pkgs.fetchFromGitHub {
              owner = "tomasklaen";
              repo = "uosc";
              rev = "370588a9676817df0585eacb5b8ac7ecda3c9007";
              hash = "sha256-NveOFs56NycLZq2+BTdv9GIwgVQxtFm3ZKdbHGkW6sY=";
            };
            tools = pkgs.buildGoModule {
              pname = "uosc-bin";
              inherit version src;
              vendorHash = "sha256-oRXChHeVQj6nXvKOVV125sM8wD33Dxxv0r/S7sl6SxQ=";
            };
          }))
        ]
        ++ (with pkgs; [
          mpv-leader
          mpv-M-x
          mpv-M-x-rofi
          mpv-recent
        ]);
    };
  };
}
