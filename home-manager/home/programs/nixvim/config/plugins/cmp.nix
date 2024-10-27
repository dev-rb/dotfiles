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
              function(entry, item)
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

                -- print(item.kind, vim.inspect(entry:get_completion_item().documentation))
                --
                --
                -- if (item.kind == 'Color' or item.kind == 'Constant') and entry.completion_item.documentation then
                --   local _, _, r, g, b = string.find(entry.completion_item.documentation, '^rgb%((%d+),? (%d+),? (%d+)')
                --   print(r, g, b)
                --   if r then
                --     local color = string.format('%02x', r) .. string.format('%02x', g) ..string.format('%02x', b)
                --     local group = 'Tw_' .. color
                --     if vim.fn.hlID(group) < 1 then
                --       vim.api.nvim_set_hl(0, group, {fg = '#' .. color})
                --     end
                --     item.kind = "■" -- or "⬤" or anything
                --     item.kind_hl_group = group
                --     return item
                --   end
                -- end

                -- if cmp_style == "atom" or cmp_style == "atom_colored" then
                --   icon = " " .. icon .. " "
                --   item.menu = cmp_ui.lspkind_text and "   (" .. item.kind .. ")" or ""
                --   item.kind = icon
                -- else
                  icon = (" " .. icon .. " ") 
                  item.kind = string.format("%s %s", icon, item.kind or "")
                -- end
                
                return require("nvim-highlight-colors").format(entry, item)
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
