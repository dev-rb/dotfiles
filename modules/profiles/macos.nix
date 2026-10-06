{ mkFeature, config, ... }:
let
  m = config.flake.modules;
in
mkFeature {
  name = "macos";

  darwin.imports = [
    m.darwin.base
    m.darwin.macos-defaults
  ];

  homeManager.imports = [ m.homeManager.darwin ];
}
