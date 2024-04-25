{
  pkgs,
  config,
  username,
  host,
  ...
}: let
  inherit (import ./../hosts/${host}/options.nix) gitUsername theShell;
in {
  users.groups = {
    "${username}" = {};
    docker = {};
    wireshark = {};
    # for android platform tools's udev rules
    adbusers = {};
    dialout = {};
    # for openocd (embedded system development)
    plugdev = {};
    # misc
    uinput = {};
  };
  
  users.users = {
    "${username}" = {
      homeMode = "755";
      hashedPassword = "$6$uO/ogoAQCipGpetZ$28Bh7XcfQyZlTBWTDyio2azdph.3Kky1u6rdXun6.lGK7Axp9ae3dpcF6iBKyjdilWTGEE/04U.lGglnPT3WO/";
      isNormalUser = true;
      description = "${gitUsername}";
      extraGroups = [
        "${username}"
        "docker"
        "wireshark"
        "adbusers"
        "networkmanager"
        "wheel"
        "libvirtd"
         "video" 
         "audio"
      ];
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHmxby1Bx5hG/qOJJO8t8BrJyoyfj84RT1DZ1mXdXUlr SolitudeAlma@laptop"
      ];
      shell = pkgs.${theShell};
      ignoreShellProgramCheck = true;
      packages = with pkgs; [];
    };
    # "newuser" = {
    #   homeMode = "755";
    #   You can get this by running - mkpasswd -m sha-512 <password>
    #   hashedPassword = "$6$YdPBODxytqUWXCYL$AHW1U9C6Qqkf6PZJI54jxFcPVm2sm/XWq3Z1qa94PFYz0FF.za9gl5WZL/z/g4nFLQ94SSEzMg5GMzMjJ6Vd7.";
    #   isNormalUser = true;
    #   description = "New user account";
    #   extraGroups = [ "networkmanager" "wheel" "libvirtd" ];
    #   shell = pkgs.${theShell};
    #   ignoreShellProgramCheck = true;
    #   packages = with pkgs; [];
    # };
  };
}
