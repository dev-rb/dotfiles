{ mkFeature, config, ... }:
mkFeature {
  name = "development";
  homeManager.imports = [ config.flake.modules.homeManager.devtools ];
}
