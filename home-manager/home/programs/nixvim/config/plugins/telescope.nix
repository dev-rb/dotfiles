{ lib, ... }:
{
  programs.nixvim = {
    plugins.telescope = {
      enable = true;
      settings = {

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
      };

      extensions = {
        frecency = {
          enable = true;
        };
        undo = {
          enable = true;
        };
        ui-select = {
          enable = true;
          settings.__raw = ''
            {
               require('telescope.themes').get_cursor {},
               specific_opts = {
                 codeactions = true
               }
            } '';
          # settings.__raw = "";
        };

      };

      keymaps = {
        "<leader>fh" = {
          mode = "n";
          action = "help_tags";
          options = {
            desc = "[F]ind [H]elp";
          };
        };
        "<leader>fk" = {
          mode = "n";
          action = "keymaps";
          options = {
            desc = "[F]ind [K]eymaps";
          };
        };
        "<leader>fr" = {
          mode = "n";
          action = "resume";
          options = {
            desc = "[F]ind [R]esume";
          };
        };
      };
    };
    keymaps = [
      {
        mode = "n";
        key = "<leader>ff";
        action = "<cmd>Telescope find_files<CR>";
        options = {
          desc = "[F]ind [F]iles";
        };
      }
      {
        mode = "n";
        key = "<leader>rf";
        action.__raw = "require('telescope').extensions['recent-files'].recent_files";
        options = {
          desc = "Find [R]ecent [F]iles";
        };
      }
      {
        mode = "n";
        key = "<leader>fw";
        action.__raw = "require('telescope').extensions.live_grep_args.live_grep_args";
        options = {
          desc = "[F]ind by [G]rep";
        };
      }
      {
        mode = "n";
        key = "<leader>fr";
        action = "<cmd>Telescope resume<CR>";
        options = {
          desc = "[F]ind [R]esume";
        };
      }
      {
        mode = "n";
        key = "<leader>fa";
        action.__raw = "function() require('telescope.builtin').find_files({ hidden = true }) end";
        options = {
          desc = "[F]ind [A]ll";
        };
      }
      {
        mode = "n";
        key = "<leader>fu";
        action = "<cmd>Telescope undo<CR>";
        options = {
          desc = "[F]ind [U]ndo";
        };
      }
      {
        mode = "n";
        key = "<leader>fc";
        action = "<cmd>Telescope frecency workspace=CWD<CR>";
        options = {
          desc = "Find by frecency";
        };
      }
    ];
  };

}
