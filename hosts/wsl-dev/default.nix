{ mkHome, ... }:
mkHome {
  name = "wsl-dev";
  system = "x86_64-linux";
  user = "dev-rb";
  stateVersions.home = "26.05";

  modules = [
    ../../modules/home
    ./home.nix
  ];
}
