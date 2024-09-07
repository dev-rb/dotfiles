{
  programs.nixvim = {
    extraConfigLua = ''
      cmp.setup.cmdline({ '/', '?' }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = 'buffer' }
        }
      })
    '';

    plugins = {
      luasnip.enable = true;
      cmp = {
        enable = true;
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
            "<Tab>" = ''
              function(fallback)
                if cmp.visible() then
                  cmp.select_next_item()
                else
                  fallback()
                end 
              end'';
          };
          autoEnableSources = true;
          sources = [
            { name = "nvim_lsp"; }
            { name = "luasnip"; }
            { name = "path"; }
            { name = "buffer"; }
            { name = "cmdline"; }
          ];
          #formatting.format.__raw = "require('cmp-tailwind-colors').format";
        };
      };
    };
  };
}
