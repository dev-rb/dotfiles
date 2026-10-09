{ mkFeature, config, ... }:
mkFeature {
  name = "common";
  homeManager = {
    imports = with config.flake.modules.homeManager; [
      base
      cli
      fonts
      git
      zsh
      oh-my-posh
      neovim
      wezterm
      tmux
    ];
  };
}
