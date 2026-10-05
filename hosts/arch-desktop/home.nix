{
  imports = [
    ../../modules/home/platforms/linux.nix
    ../../modules/home/desktop
  ];

  home = {
    username = "devrb";
    homeDirectory = "/home/devrb";
    # Compatibility version from the existing configuration, not a package version.
    stateVersion = "26.05";
  };
}
