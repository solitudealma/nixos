{lib, ...}:
with lib; {
  options.modules.social = {
    discord = mkEnableOption "discord";
    qq = mkEnableOption "qq";
    telegram = mkEnableOption "telegram";
  };
}
