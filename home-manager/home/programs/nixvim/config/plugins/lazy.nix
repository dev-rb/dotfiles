{ pkgs, config, ... }:

{
  programs.nixvim = {
    plugins.lazy = {
      enable = true;
      plugins = with pkgs.vimPlugins; [
        nvim-treesitter
        nvim-autopairs
        {
          pkg = nvim-cmp;
          event = [ "InsertEnter" ];
          dependencies = [
            nvim-lspconfig
            cmp-nvim-lsp
          ];
        }
        smart-splits-nvim
        {
          pkg = nvim-tree-lua;

          cmd = [
            "NvimTreeToggle"
            "NvimTreeFocus"
          ];
        }
        oil-nvim
        indent-blankline-nvim
        conform-nvim
        comment-nvim
        nvim-ts-context-commentstring
        {
          pkg = which-key-nvim;
          keys = [
            "<leader>"
            "\""
            "'"
            "`"
            "c"
            "v"
            "g"
          ];

        }
        {
          pkg = telescope-nvim;
          cmd = [ "Telescope" ];
        }

        {
          pkg = persistence-nvim;
          event = [ "BufReadPre" ];
        }

      ];
    };
  };
}
