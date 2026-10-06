{ mkFeature, config, ... }:
mkFeature {
  name = "development";
  homeManager.imports = with config.flake.modules.homeManager; [
    devtools
    pi
  ];
}
