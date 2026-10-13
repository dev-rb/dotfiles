{ mkFeature, ... }:
mkFeature {
  name = "base";
  homeManager = {
    programs.home-manager.enable = true;
    home.sessionVariables.EDITOR = "nvim";
  };
  darwin = {
    nix.settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
    programs.zsh.enable = true;
  };
}
