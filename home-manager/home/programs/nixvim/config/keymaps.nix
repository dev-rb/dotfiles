{
  programs.nixvim = {
    keymaps = [
      {
        mode = "n";
        key = "<C-n>";
        action = "<cmd>NvimTreeToggle<CR>";
        options = {
          desc = "Nvim-tree [T]oggle";
        };
      }
      # {
      #   mode = "n";
      #   key = "<leader>tt";
      #   action.__raw = ''
      #     function() 
      #       TOGGLED_TRANSPARENT = false
      #       require('nightfox').compile()
      #     end'';
      #   options = {
      #     desc = "[T]oggle [T]ransparent";
      #   };
      # }
      {
        mode = [
          "n"
          "x"
        ];
        key = "s";
        action = "<nop>";
      }
      {
        mode = [ "n" ];
        key = "<leader>cf";
        action = "<cmd> foldclose <CR>";
      }
      {
        mode = [ "n" ];
        key = "<leader>of";
        action = "<cmd> foldopen <CR>";
      }
      {
        mode = "n";
        key = "<Esc>";
        action = "<cmd>nohlsearch<CR>";
        options = {
          desc = "Remove search highlights when pressing <Esc>";
        };
      }
      {
        mode = "n";
        key = "<C-s>";
        action = "<cmd>w<CR>";
        options = {
          desc = "Save file remap";
        };
      }
      {
        mode = "n";
        key = "K";
        action.__raw = "vim.lsp.buf.hover";
        options = {
          desc = "LSP Rename";
        };
      }
      {
        mode = "n";
        key = "<leader>ra";
        action.__raw = "function() require('lsp-utils.renamer')()end";
        options = {
          desc = "LSP Rename";
        };
      }

      {
        mode = "n";
        key = "<leader>f";
        action.__raw = "function() vim.diagnostic.open_float { border = 'rounded' } end";
        options = {
          desc = "[F]loating diagnostic";
        };
      }

      # [[ Custom terminal ]]
      {
        mode = [
          "n"
          "t"
        ];
        key = "<A-i>";
        action.__raw = "function() require('local-term').toggle({pos = 'float', id = 'floatTerm'}) end";
        options = {
          desc = "Toggle floating terminal";
        };
      }
      {
        mode = [
          "n"
          "t"
        ];
        key = "<A-h>";
        action.__raw = "function() require('local-term').toggle({pos = 'sp', id = 'horizontal'}) end";
        options = {
          desc = "Toggle floating terminal";
        };
      }
      # [[ Comment.nvim ]]
      {
        mode = "n";
        key = "<leader>/";
        action.__raw = ''
          function()
            require("Comment.api").toggle.linewise.current()
          end
        '';
        options = {
          desc = "Toggle comment";
        };
      }
      {
        mode = "v";
        key = "<leader>/";
        action = "<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>";
        options = {
          desc = "Toggle comment";
        };
      }
      # [[ movement ]]
      {
        mode = "n";
        key = "<C-d>";
        action = "<C-d>zz";
        options = {
          desc = "Scroll down and keep cursor in the center";
        };
      }
      {
        mode = "n";
        key = "<C-u>";
        action = "<C-u>zz";
        options = {
          desc = "Scroll up and keep cursor in the center";
        };
      }
      {
        mode = "n";
        key = "n";
        action = "nzzzv";
        options = {
          desc = "Find next and keep cursor in the center";
        };
      }
      {
        mode = "n";
        key = "N";
        action = "Nzzzv";
        options = {
          desc = "Find previous and keep cursor in the center";
        };
      }
      {
        mode = [
          "n"
          "x"
        ];
        key = "k";
        action = "gk";
        options = {
          desc = "Navigate with line wrap";
        };
      }
      {
        mode = [
          "n"
          "x"
        ];
        key = "j";
        action = "gj";
        options = {
          desc = "Navigate with line wrap";
        };
      }
      # [[ visual ]]
      {
        mode = "v";
        key = "K";
        action = ":m '<-2<CR>gv=gv";
        options = {
          desc = "Move selected lines up";
          silent = true;
        };
      }
      {
        mode = "v";
        key = "J";
        action = ":m '>+1<CR>gv=gv";
        options = {
          desc = "Move selected lines down";
          silent = true;
        };
      }
      {
        mode = "x";
        key = "<leader>p";
        action = "\"_dP";
        options = {
          desc = "Paste without overriding the buffer";
        };
      }
      {
        mode = "x";
        key = "rw";
        action = "y:%s/<C-r>0/<C-r>0/gc<left><left><left>";
        options = {
          desc = "Replace Selection";
        };
      }
      {
        mode = "x";
        key = "/";
        action = "\"sy:/\\V<C-r>s<CR>N";
        options = {
          desc = "Search for selection";
        };
      }
      # [[ windows ]]
      {
        mode = "n";
        key = "<C-h>";
        action.__raw = "function() require('smart-splits').move_cursor_left() end";
        options = {
          desc = "Move focus to the left window";
        };
      }
      {
        mode = "n";
        key = "<C-l>";
        action.__raw = "function() require('smart-splits').move_cursor_right() end";
        options = {
          desc = "Move focus to the right window";
        };
      }
      {
        mode = "n";
        key = "<C-j>";
        action.__raw = "function() require('smart-splits').move_cursor_down() end";
        options = {
          desc = "Move focus to the lower window";
        };
      }
      {
        mode = "n";
        key = "<C-k>";
        action.__raw = "function() require('smart-splits').move_cursor_up() end";
        options = {
          desc = "Move focus to the upper window";
        };
      }
      {
        mode = "n";
        key = "<leader>[";
        action.__raw = "vim.diagnostic.goto_prev";
        options = {
          desc = "Go to previous [D]iagnostic message";
        };
      }
      {
        mode = "n";
        key = "<leader>]";
        action.__raw = "vim.diagnostic.goto_next";
        options = {
          desc = "Go to next [D]iagnostic message";
        };
      }
      {
        mode = "n";
        key = "<leader>de";
        action.__raw = "vim.diagnostic.open_float";
        options = {
          desc = "Show diagnostic [E]rror messages";
        };
      }
      {
        mode = "n";
        key = "<leader>df";
        action.__raw = "vim.diagnostic.setloclist";
        options = {
          desc = "Open diagnostic [Q]uickfix list";
        };
      }
    ];
  };
}
