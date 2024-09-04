{ pkgs, config, ... }:

{
  programs.nixvim = {
    plugins.lazy = {
      enable = true;
      plugins = with pkgs.vimPlugins; [
        nvim-treesitter
        smart-splits-nvim
        nvim-tree-lua
        oil-nvim
      ];
    };
  };
}
