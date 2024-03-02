{lib, ...}:
with lib; {
  options.modules.terminal = {
    shells = mkOption {
      type = types.listOf types.str;
      default = ["nushell"];
      description = "The shells to install in the terminal";
      example = ["nushell" "bash"];
    };
    defaultShell = mkOption {
      type = types.str;
      default = "nushell";
      description = "The default shell to use";
      example = "nushell";
    };
    yazi = mkEnableOption "yazi";
    zellij = mkEnableOption "zellij";
  };
}
