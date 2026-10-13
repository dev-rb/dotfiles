{ mkDarwin, config, ... }:
let
  m = config.flake.modules;
in
mkDarwin {
  name = "macbook-pro";
  system = "aarch64-darwin";
  user = "devrb";
  checkoutPath = "/Users/devrb/dotfiles";
  stateVersions = {
    home = "26.05";
    system = 6;
  };

  modules = [ m.darwin.macos ];
  homeModules = [
    m.homeManager.common
    m.homeManager.development
    m.homeManager.macos
  ];
}
