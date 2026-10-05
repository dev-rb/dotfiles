{ mkDarwin, ... }:
mkDarwin {
  name = "macbook-pro";
  system = "aarch64-darwin";
  user = "devrb";
  stateVersions = {
    home = "26.05";
    system = 6;
  };

  modules = [ ../../modules/darwin ];
  homeModules = [
    ../../modules/home
    ./home.nix
  ];
}
