{
  isInstall,
  lib,
  pkgs,
  username,
  ...
}: let
  setFor = ["nixosvmtest"];
in {
  environment = lib.mkIf isInstall {systemPackages = with pkgs; [ssh-to-age];};
  programs = {
    mosh.enable = isInstall;
    ssh.startAgent = true;
  };
  services = {
    openssh = {
      enable = true;
      # Don't open the firewall on for SSH on laptops; Tailscale will handle it.
      openFirewall = true;
      settings = {
        PasswordAuthentication = lib.elem username setFor;
        PermitRootLogin = lib.mkDefault "prohibit-password";
      };
    };
    sshguard = {
      enable = true;
      whitelist = [
      ];
    };
  };
}
