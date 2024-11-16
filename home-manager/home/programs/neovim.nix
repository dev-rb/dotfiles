{ pkgs, ... }:

{
  programs.neovim.enable = true;

  home.file = {
    ".config/nvim" = {
      source = ../../../nvim;
      recursive = true;
      force = true;
      onChange = "install -Dm777 ~/dotfiles/nvim/lua/chadrc.lua ~/.config/nvim/lua/chadrc.lua";
    };
  };
}
