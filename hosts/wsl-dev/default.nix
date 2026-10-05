{ mkHome, config, ... }:
let
  m = config.flake.modules;
in
mkHome {
  name = "wsl-dev";
  system = "x86_64-linux";
  user = "dev-rb";
  checkoutPath = "/home/dev-rb/dotfiles";
  stateVersions.home = "26.05";

  modules = [
    m.homeManager.common
    m.homeManager.development
    m.homeManager.linux
    m.homeManager.wsl
  ];
}
