{
  system.stateVersion = 6;
  system.primaryUser = "devrb";
  users.users.devrb.home = "/Users/devrb";

  home-manager.users.devrb.imports = [
    ../../modules/home
    ./home.nix
  ];
}
