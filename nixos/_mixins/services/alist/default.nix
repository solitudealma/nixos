{inputs, ...}: {
  imports = [
    inputs.nur-Moraxyc.nixosModules.alist
  ];

  services.alist = {
    enable = false;
    settings = {
      site_url = "http://127.0.0.1:5244";
      jwt_secret = {
        _secret = "/run/agenix/alist-jwt";
      };
      database = {
        type = "sqlite3";
        user = "root";
        name = "alist";
      };
    };
  };
}
