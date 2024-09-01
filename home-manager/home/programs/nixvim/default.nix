{ pkgs, lib, ... }:
{
  imports = [ ./config ];

  programs.nixvim = {
    enable = true;
    luaLoader.enable = true;

    performance = {
      byteCompileLua = {
        enable = false;
      };
    };

    extraConfigLuaPre = ''

      local builtin_plugins = {
        "2html_plugin",
        "tohtml",
        "getscript",
        "getscriptPlugin",
        "gzip",
        "logipat",
        "netrw",
        "netrwPlugin",
        "netrwSettings",
        "netrwFileHandlers",
        "matchit",
        "tar",
        "tarPlugin",
        "rrhelper",
        "spellfile_plugin",
        "vimball",
        "vimballPlugin",
        "zip",
        "zipPlugin",
        "tutor",
        "rplugin",
        "syntax",
        "synmenu",
        "optwin",
        "compiler",
        "bugreport",
        "ftplugin",
      }

      for i = 1, #builtin_plugins do 
        vim.g['loaded_' .. builtin_plugins[i]] = true
      end


    '';

    enableMan = true;
    colorscheme = "terafox";

    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    globals = {
      mapleader = " ";
      maplocalleader = " ";
    };

    extraPlugins = with pkgs.vimPlugins; [
      #nvim-web-devicons
      # smart-splits-nvim
      #cmp-tailwind-colors
      #catppuccin
      #everforest-lua
      # telescope-live-grep-args-nvim
      #markdown
    ];

    extraConfigLua = '''';

    extraFiles = {
      "lua/local-term.lua".text = builtins.readFile ./config/lua/local-term/init.lua;
      "lua/lsp-utils/init.lua".text = builtins.readFile ./config/lua/lsp-utils/init.lua;
      "lua/lsp-utils/renamer.lua".text = builtins.readFile ./config/lua/lsp-utils/renamer.lua;
    };

  };

}
