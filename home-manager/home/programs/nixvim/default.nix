{ pkgs, lib, ... }:
{
  imports = [ ./config ];

  programs.nixvim = {
    enable = true;
    enableMan = true;
    colorscheme = "catppuccin";

    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    globals = {
      mapleader = " ";
      maplocalleader = " ";
    };

    extraPlugins = with pkgs.vimPlugins; [
      #cmp-tailwind-colors
      #catppuccin
      #everforest-lua
      telescope-live-grep-args-nvim
      #markdown
    ];

  };

}
