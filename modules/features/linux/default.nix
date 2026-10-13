{ mkFeature, ... }:
mkFeature {
  name = "linux";
  homeManager = {
    targets.genericLinux.enable = true;
    fonts.fontconfig.enable = true;
  };
}
