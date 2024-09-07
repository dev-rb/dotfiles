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
          completion = {
            completeopt = "menu,menuone";
          };
          window = {
            completion = {
              side_padding = 1;
              # winhighlight = "Normal:CmpItemMenu,CursorLine:CmpSel,Search:PmenuSel";
              scrollbar = false;
              border.__raw = ''
                {
                  { "╭","CmpDocumentationBorder"},
                  { "─","CmpDocumentationBorder"},
                  { "╮","CmpDocumentationBorder"},
                  { "│","CmpDocumentationBorder"},
                  { "╯","CmpDocumentationBorder"},
                  { "─","CmpDocumentationBorder"},
                  { "╰","CmpDocumentationBorder"},
                  { "│","CmpDocumentationBorder"},
                }
              '';

            };
            documentation = {
              winhighlight = "Normal:CmpDocumentation";
              # border.__raw = ''
              #   {
              #     { "╭", "CmpDocumentationBorder" },
              #     { "─","CmpDocumentationBorder"},
              #     { "╮","CmpDocumentationBorder"},
              #     { "│","CmpDocumentationBorder"},
              #     { "╯","CmpDocumentationBorder"},
              #     { "─","CmpDocumentationBorder"},
              #     { "╰","CmpDocumentationBorder"},
              #     { "│","CmpDocumentationBorder"},
              #   }
              # '';
            };
          };
          formatting = {
            fields = [
              "abbr"
              "kind"
              "menu"
            ];
            format.__raw = ''
              function(_, item)
                -- https://github.com/NvChad/ui/blob/v2.5/lua/nvchad/icons/lspkind.lua
                local lspkind = {
                  Namespace = "󰌗",
                  Text = "󰉿",
                  Method = "󰆧",
                  Function = "󰆧",
                  Constructor = "",
                  Field = "󰜢",
                  Variable = "󰀫",
                  Class = "󰠱",
                  Interface = "",
                  Module = "",
                  Property = "󰜢",
                  Unit = "󰑭",
                  Value = "󰎠",
                  Enum = "",
                  Keyword = "󰌋",
                  Snippet = "",
                  Color = "󰏘",
                  File = "󰈚",
                  Reference = "󰈇",
                  Folder = "󰉋",
                  EnumMember = "",
                  Constant = "󰏿",
                  Struct = "󰙅",
                  Event = "",
                  Operator = "󰆕",
                  TypeParameter = "󰊄",
                  Table = "",
                  Object = "󰅩",
                  Tag = "",
                  Array = "[]",
                  Boolean = "",
                  Number = "",
                  Null = "󰟢",
                  Supermaven = "",
                  String = "󰉿",
                  Calendar = "",
                  Watch = "󰥔",
                  Package = "",
                  Copilot = "",
                  Codeium = "",
                  TabNine = "",
                }
                local icons = lspkind
                local icon = icons[item.kind] or ""

                -- if cmp_style == "atom" or cmp_style == "atom_colored" then
                --   icon = " " .. icon .. " "
                --   item.menu = cmp_ui.lspkind_text and "   (" .. item.kind .. ")" or ""
                --   item.kind = icon
                -- else
                  icon = (" " .. icon .. " ") 
                  item.kind = string.format("%s %s", icon, item.kind or "")
                -- end
                return item
              end
            '';

          };
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
