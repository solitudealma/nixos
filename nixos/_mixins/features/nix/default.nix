{hostname, ...}: {
  nix.settings.cores =
    if hostname == "laptop"
    then 18
    else 0;
}
