{
  lib,
  pkgs,
  username,
  ...
}: {
  home = {
    packages = with pkgs; [
      telegram-desktop
      (discord.override {withOpenASAR = true;})
      element-desktop
      qq
      (nur.repos.novel2430.wechat-universal-bwrap.overrideAttrs (old: {
        desktopItems = let
          newDesktopItem = (builtins.elemAt old.desktopItems 0).override (d: {
            exec = "env WECHAT_IME_WORKAROUND=fcitx WECHAT_CUSTOM_BINDS_CONFIG=/home/${username}/.config/wechat-universal/binds.list ${d.exec}";
          });
        in
          lib.imap1 (idx: item:
            if idx == 1
            then newDesktopItem
            else item)
          old.desktopItems;
      }))
    ];
  };

  # xdg.desktopEntries = {
  #   wechat-universal = {
  #     name = "wechat-universal";
  #     genericName = "WeChat Universal";
  #     exec = "env WECHAT_CUSTOM_BINDS_CONFIG=/home/${username}/.config/wechat-universal/binds.list wechat-universal-bwrap %U";
  #     terminal = false;
  #     icon = "wechat";
  #     comment = "WeChat Universal Desktop Edition";
  #     categories = [ "Utility" "Network" "InstantMessaging" "Chat" ];
  #     settings = {
  #       Keywords = "wechat;weixin;wechat-universal";
  #       "Name[zh_CN]" = "微信 Universal";
  #       "Name[zh_TW]" = "微信 Universal";
  #       "Comment[zh_CN]" = "微信桌面版 Universal";
  #       "Comment[zh_TW]" = "微信桌面版 Universal";
  #       Version = "1.4";
  #     };
  #     type = "Application";
  #   };
  # };
}
