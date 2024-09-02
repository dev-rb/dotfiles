{ pkgs, config, ... }:

let
  plugins = config.programs.nixvim.plugins;
in
{
  programs.nixvim = {
    plugins.lazy = {
      enable = true;
      plugins = with pkgs.vimPlugins; [
        { pkg = plenary-nvim; }
        {
          pkg = nvim-autopairs;
          opts = {
            fast_wrap = { };
            disable_filetype = [
              "TelescopePrompt"
              "vim"
            ];
          };

        }
        {
          pkg = nvim-cmp;
          dependencies = [
            {
              pkg = nvim-lspconfig;
              event = [
                "BufRead"
                "BufWinEnter"
                "BufNewFile"
              ];
            }
            { pkg = cmp-nvim-lsp; }
          ];
          config = ''
            function()
              require('cmp').setup({
                completion = {
                  completeopt = "menu,menuone"
                },
                snippet = {
                  expand=function(args)
                        require('luasnip').lsp_expand(args.body)
                      end
                },
                mapping = require('cmp').mapping.preset.insert({
                    ['<C-n>'] = require('cmp').mapping.select_next_item(),
                    ['<C-p>'] = require('cmp').mapping.select_prev_item(),
                    ['<C-Space>'] = require('cmp').mapping.complete(),
                    ['<C-e>'] = require('cmp').mapping.abort(),
                    ['<CR>'] = require('cmp').mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
                  }),
                
                sources = {
                  { name = "nvim_lsp" },
                  { name = "luasnip" },
                  { name = "path" },
                  { name = "buffer" },
                }
              })
            end

          '';
        }
        {
          pkg = conform-nvim;
          enabled = true;
          opts = {
            notify_on_error = true;
            format_on_save.__raw = # lua
              ''
                function(bufnr)
                  return { timeout_ms = 1500, lsp_format = "fallback" }
                end
              '';
            formatters_by_ft = {
              lua = [ "stylua" ];
              rust = [ "rustfmt" ];
              nix = [ "nixfmt" ];
              javascript = [
                "biome"
                "prettier"
              ];
              javascriptreact = [
                "biome"
                "prettier"
              ];
              typescript = [
                "biome"
                "prettier"
              ];
              typescriptreact = [
                "biome"
                "prettier"
              ];
            };
          };
        }
        {
          pkg = nvim-treesitter;
          event = [
            "BufRead"
            "BufWinEnter"
            "BufNewFile"
          ];
          cmd = [
            "TSInstall"
            "TSBufEnable"
            "TSBufDisable"
            "TSModuleInfo"
          ];
          dependencies = [
            { pkg = nvim-ts-autotag; }
            {
              pkg = nvim-ts-context-commentstring;
              config = ''
                function() require('ts_context_commentstring').setup({}) end
              '';
            }
          ];
          opts = {
            highlight = {
              enable = true;
              use_languagetree = true;
            };
            indent = {
              enable = true;
            };
            ensure_installed = "all";
          };
          config = ''
            function() 
              require('nvim-ts-autotag').setup({
                enable = true,
                filetypes = {"html", "tsx"}
              }) 
              vim.treesitter.language.register('markdown', 'mdx')
            end'';
        }
        {
          pkg = comment-nvim;
          opts = {

            pre_hook.__raw = ''
              function(ctx)
                -- Only calculate commentstring for tsx filetypes
                if vim.bo.filetype == "typescriptreact" then
                  local U = require "Comment.utils"

                  -- Determine whether to use linewise or blockwise commentstring
                  local type = ctx.ctype == U.ctype.linewise and "__default" or "__multiline"

                  -- Determine the location where to calculate commentstring from
                  local location = nil
                  if ctx.ctype == U.ctype.blockwise then
                    location = require("ts_context_commentstring.utils").get_cursor_location()
                  elseif ctx.cmotion == U.cmotion.v or ctx.cmotion == U.cmotion.V then
                    location = require("ts_context_commentstring.utils").get_visual_start_location()
                  end

                  return require("ts_context_commentstring.internal").calculate_commentstring ({
                    key = type,
                    location = location,
                   })
                end
              end
            '';

          };
        }
        {
          pkg = telescope-nvim;
          config = ''
            function(_, opts)
              opts = vim.tbl_deep_extend("force", opts, {
                extensions = {
                  ["ui-select"] = {
                    require('telescope.themes').get_cursor {}
                  }
                }
              })

              require('telescope').setup(opts)
                  require('telescope').load_extension("ui-select")
            end
          '';
          opts = {
            pickers = {
              find_files = {
                hidden = false;
              };
            };
            defaults = {
              prompt_prefix = "   ";
              selection_caret = "  ";
              entry_prefix = "  ";
              initial_mode = "insert";
              selection_strategy = "reset";
              sorting_strategy = "ascending";
              layout_strategy = "horizontal";
              layout_config = {
                horizontal = {
                  prompt_position = "top";
                  preview_width = 0.55;
                  results_width = 0.8;
                };
                vertical = {
                  mirror = false;
                };
                width = 0.87;
                height = 0.8;
                preview_cutoff = 120;
              };
              #file_sorter = "require(' telescope.sorters ').get_fuzzy_file";
              #file_ignore_patterns = { "node_modules" };
              #generic_sorter = "require(' telescope.sorters ').get_generic_fuzzy_sorter";
              #path_display = { "truncate" };
              winblend = 0;
              border = { };
              borderchars = [
                "─"
                "│"
                "─"
                "│"
                "╭"
                "╮"
                "╯"
                "╰"
              ];
              color_devicons = true;
              # set_env.COLORTERM = "truecolor";
              set_env = {
                "COLORTERM" = "truecolor";
              };
              #file_previewer = "require(' telescope.previewers ').vim_buffer_cat.new";
              #grep_previewer = "require(' telescope.previewers ').vim_buffer_vimgrep.new";
              #qflist_previewer = "require(' telescope.previewers ').vim_buffer_qflist.new";
              #buffer_previewer_maker = "require(' telescope.previewers ').buffer_previewer_maker";
              #mappings = {
              #n = { ["q"] = require("telescope.actions").close };
              #};
            };
            # keymaps = {
            #   "<leader>fh" = {
            #     mode = "n";
            #     action = "help_tags";
            #     options = {
            #       desc = "[F]ind [H]elp";
            #     };
            #   };
            #   "<leader>fk" = {
            #     mode = "n";
            #     action = "keymaps";
            #     options = {
            #       desc = "[F]ind [K]eymaps";
            #     };
            #   };
            #   "<leader>fr" = {
            #     mode = "n";
            #     action = "resume";
            #     options = {
            #       desc = "[F]ind [R]esume";
            #     };
            #   };
            # };
          };
          dependencies = [
            { pkg = telescope-live-grep-args-nvim; }
            { pkg = telescope-ui-select-nvim; }
          ];
        }
        {
          pkg = which-key-nvim;
          opts = plugins.which-key.settings;
        }
        { pkg = nvim-surround; }
        { pkg = nvim-web-devicons; }
        {
          pkg = nvim-tree-lua;
          opts = {

            view = {
              side = "right";
              float = {
                enable = true;
                open_win_config.__raw = ''
                  function()
                    local screen_w = vim.opt.columns:get()
                    local screen_h = vim.opt.lines:get() - vim.opt.cmdheight:get()
                    local window_w = screen_w * WIDTH_RATIO
                    local window_h = screen_h * HEIGHT_RATIO
                    local window_w_int = math.floor(window_w)
                    local window_h_int = math.floor(window_h)
                    local center_x = (screen_w - window_w) / 2
                    local center_y = ((vim.opt.lines:get() - window_h) / 2) - vim.opt.cmdheight:get()
                    return {
                      border = "rounded";
                      relative = "editor";
                      row = center_y;
                      col = center_x;
                      width = window_w_int;
                      height = window_h_int;
                    }
                  end
                '';
              };

              width.__raw = ''
                function()
                 return math.floor(vim.opt.columns:get() * WIDTH_RATIO)
                end'';
            };
            git = {
              enable = false;
            };
            update_focused_file = {
              enable = true;
            };
            filters = {
              dotfiles = false;
            };
          };

        }
      ];
    };
  };
}
