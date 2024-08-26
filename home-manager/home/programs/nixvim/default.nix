{ pkgs, lib, ... }:
{
  imports = [ ./config ];

  programs.nixvim = {
    enable = true;
    enableMan = true;
    colorscheme = "tokyonight";

    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    globals = {
      mapleader = " ";
      maplocalleader = " ";
    };

    extraPlugins = with pkgs.vimPlugins; [
      # smart-splits-nvim
      #cmp-tailwind-colors
      #catppuccin
      #everforest-lua
      telescope-live-grep-args-nvim
      #markdown
    ];

  };

}
