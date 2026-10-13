{ mkFeature, inputs, ... }:
mkFeature {
  name = "nixgl";
  homeManager = {
    targets.genericLinux.nixGL = {
      packages = inputs.nixgl.packages;
      defaultWrapper = "mesa";
      installScripts = [ "mesa" ];
    };
  };
}
