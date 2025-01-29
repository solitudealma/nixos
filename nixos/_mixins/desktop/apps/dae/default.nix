{
  config,
  inputs,
  pkgs,
  ...
}: let
  inherit (config._custom.globals) configDirectory;
in {
  imports = [
    inputs.daeuniverse.nixosModules.dae
  ];

  services.dae = {
    configFile = "${configDirectory}/nixos/_mixins/desktop/apps/dae/config.dae";
    disableTxChecksumIpGeneric = false;
    enable = true;
    openFirewall = {
      enable = true;
      port = 12345;
    };
    package = inputs.daeuniverse.packages.${pkgs.system}.dae;
    # assetsPath = toString (
    #   pkgs.symlinkJoin {
    #     name = "dae-assets-nixy";
    #     paths = [
    #       # "${inputs.nixyDomains}/assets"
    #       "${pkgs.v2ray-geoip}/share/v2ray"
    #     ];
    #   }
    # );
    assets = with pkgs; [
      v2ray-rules-dat
    ];
  };

  # manual launch(geoip.dat,geosite.dat,config.dae needs to be in the same directory):
  # `wget https://cdn.jsdelivr.net/gh/Loyalsoldier/geoip@release/geoip.dat`
  # `wget wget https://cdn.jsdelivr.net/gh/Loyalsoldier/v2ray-rules-dat@release/geosite.dat`
  # `dae run --disable-timestamp -c /path/to/config.dae`
}
