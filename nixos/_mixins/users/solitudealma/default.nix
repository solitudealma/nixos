{
  config,
  username,
  ...
}: let
  inherit (config._custom.globals) _git;
in {
  users.users = {
    "${username}" = {
      description = _git.userName;
      hashedPassword = "$6$uO/ogoAQCipGpetZ$28Bh7XcfQyZlTBWTDyio2azdph.3Kky1u6rdXun6.lGK7Axp9ae3dpcF6iBKyjdilWTGEE/04U.lGglnPT3WO/";
      ignoreShellProgramCheck = true;
    };
  };
  systemd.tmpfiles.rules = ["d /mnt/snapshot/${username} 0755 ${username} users"];
}
