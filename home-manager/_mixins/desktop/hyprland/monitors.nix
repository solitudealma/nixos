{username, ...}: {
  laptop = {
    monitor = [
      "eDP-1, 1920x1080@144Hz, 0x0, 1"
    ];
    workspace = [
      "1, name:Terminal, monitor:eDP-1"
      "2, name:Terminal, monitor:eDP-1"
      "3, name:Terminal, monitor:eDP-1"
      "4, name:OBS, monitor:eDP-1, on-created-empty:[] obs"
      "5, name:Firefox, monitor:eDP-1, on-created-empty:[] firefox"
      "6, name:Music, monitor:eDP-1, on-created-empty:[] music_player"
      "7, name:QQ, monitor:eDP-1, on-created-empty:[] qq"
      "8, name:WeChat, monitor:eDP-1, on-created-empty:[] WECHAT_IME_WORKAROUND=fcitx5 WECHAT_CUSTOM_BINDS_CONFIG=/home/${username}/.config/wechat-universal/binds.list wechat-universal-bwrap"
      "9, name:Stream, monitor:eDP-1, on-created-empty:[] steam"
      "10,name:Stream, monitor:eDP-1"
    ];
    # workspace = 6, on-created-empty:[] music
  };
}
