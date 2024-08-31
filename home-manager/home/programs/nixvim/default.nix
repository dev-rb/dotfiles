{ pkgs, lib, ... }:
{
  imports = [ ./config ];

  programs.nixvim = {
    enable = true;
    enableMan = true;
    colorscheme = "carbonfox";

    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    globals = {
      mapleader = " ";
      maplocalleader = " ";
    };

    extraPlugins = with pkgs.vimPlugins; [
      nvim-surround
      # smart-splits-nvim
      #cmp-tailwind-colors
      #catppuccin
      #everforest-lua
      telescope-live-grep-args-nvim
      #markdown
    ];

    extraConfigLua = ''
      require("nvim-surround").setup({})
    '';

    extraFiles = {
      "lua/local-term.lua".text = builtins.readFile ./config/lua/local-term/init.lua;
      "lua/lsp-utils/init.lua".text = builtins.readFile ./config/lua/lsp-utils/init.lua;
      "lua/lsp-utils/renamer.lua".text = builtins.readFile ./config/lua/lsp-utils/renamer.lua;
    };

  };

}
