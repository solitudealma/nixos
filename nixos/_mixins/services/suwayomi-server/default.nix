{
  pkgs,
  username,
  ...
}: {
  services.suwayomi-server = {
    enable = false;
    dataDir = "/home/${username}/suwayomi"; # Default is "/var/lib/suwayomi-server"
    # openFirewall = true;
    # package = pkgs.nur.repos.xddxdd.suwayomi-server; # man hua reader server
    settings = {
      server = {
        extensionRepos = [
          "https://raw.githubusercontent.com/keiyoushi/extensions/repo/index.min.json"
          # "https://raw.githubusercontent.com/tachiyomiorg/extensions/repo/index.min.json"
          # "https://raw.githubusercontent.com/stevenyomi/copymanga/repo/index.min.json"
          # "https://raw.githubusercontent.com/suwayomi/tachiyomi-extension/repo/index.min.json"
        ];
        ip = "0.0.0.0";
        port = 4567;
        systemTrayEnabled = true;
      };
    };
    user = username;
  };
}
