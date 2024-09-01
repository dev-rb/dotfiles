{ pkgs, config, ... }:

let
  plugins = config.programs.nixvim.plugins;
in
{
  programs.nixvim = {
    plugins.lazy = {
      enable = true;
      plugins = with pkgs.vimPlugins; [
        {
          pkg = nvim-cmp;
          dependencies = [
            { pkg = nvim-lspconfig; }
            { pkg = cmp-nvim-lsp; }
          ];
          opts = plugins.cmp.settings;
        }
        {
          pkg = conform-nvim;
          enabled = true;
          opts = {
            formatOnSave = # lua
              ''
                function(bufnr)
                  return { timeout_ms = 1500, lsp_format = "fallback" }
                end
              '';
            formattersByFt = {
              lua = [ "stylua" ];
              rust = [ "rustfmt" ];
              nix = [ "nixfmt" ];
            };
          };
        }
        {
          pkg = nvim-treesitter;
          dependencies = [
            {
              pkg = nvim-ts-autotag;
              event = "VeryLazy";
            }
            {
              pkg = nvim-ts-context-commentstring;
              config = ''
                function() require('ts_context_commentstring').setup({}) end
              '';
            }
          ];
          opts = plugins.treesitter.settings;
          config = ''
            function() 
              require('nvim-ts-autotag').setup({
                enable = true,
                filetypes = {"html", "tsx"}
              }) 
            end'';
        }
        {
          pkg = comment-nvim;
          opts = plugins.comment.settings;
        }
        {
          pkg = smart-splits-nvim;
          lazy = false;
          opts = plugins.smart-splits.settings;
        }
        {
          pkg = telescope-nvim;
          opts = plugins.telescope.settings;
          dependencies = [ { pkg = telescope-live-grep-args-nvim; } ];
        }
        {
          pkg = which-key-nvim;
          opts = plugins.which-key.settings;
        }
        { pkg = nvim-surround; }
        { pkg = nvim-web-devicons; }
        {
          pkg = nvim-tree-lua;
          opts = plugins.nvim-tree.extraOptions;
        }
      ];
    };
  };
}
