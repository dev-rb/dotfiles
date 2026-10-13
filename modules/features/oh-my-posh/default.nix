{ mkFeature, ... }:
mkFeature {
  name = "oh-my-posh";
  homeManager = {
    programs.oh-my-posh = {
      enable = true;
      enableZshIntegration = true;
      configFile = ./pure.omp.json;
    };
  };
}
