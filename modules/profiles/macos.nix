{ mkFeature, config, ... }:
let
  m = config.flake.modules;
in
mkFeature {
  name = "macos";

  darwin.imports = [
    m.darwin.base
    m.darwin.macos-defaults
    m.darwin.macos-apps
  ];

  homeManager.imports = [
    m.homeManager.darwin
    m.homeManager.macos-apps
  ];
}
