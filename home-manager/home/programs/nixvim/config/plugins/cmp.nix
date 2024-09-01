{
  programs.nixvim.plugins = {
    luasnip.enable = false;
    cmp = {
      enable = false;
      settings = {
        snippet.expand.__raw = # lua
          ''
            function(args)
              require('luasnip').lsp_expand(args.body)
            end
          '';
        mapping = {
          "<C-n>" = "require('cmp').mapping.select_next_item()";
          "<C-p>" = "require('cmp').mapping.select_prev_item()";
          "<C-Space>" = "require('cmp').mapping.complete()";
          "<C-e>" = "require('cmp').mapping.abort()";
          "<CR>" = "require('cmp').mapping.confirm({ select = true })";
        };
        sources = [
          { name = "nvim_lsp"; }
          { name = "luasnip"; }
          { name = "path"; }
          { name = "buffer"; }
        ];
        #formatting.format.__raw = "require('cmp-tailwind-colors').format";
      };
    };
  };
}
