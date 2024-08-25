{
  programs.nixvim = {
    keymaps = [
      {
        mode = [
          "n"
          "x"
        ];
        key = "s";
        action = "<nop>";
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
        action = "<C-w>h";
        options = {
          desc = "Move focus to the left window";
        };
      }
      {
        mode = "n";
        key = "<C-l>";
        action = "<C-w>l";
        options = {
          desc = "Move focus to the right window";
        };
      }
      {
        mode = "n";
        key = "<C-j>";
        action = "<C-w>j";
        options = {
          desc = "Move focus to the lower window";
        };
      }
      {
        mode = "n";
        key = "<C-k>";
        action = "<C-w>k";
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