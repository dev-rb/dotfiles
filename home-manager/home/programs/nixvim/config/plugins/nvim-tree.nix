{
  programs.nixvim = {
    extraConfigLuaPre = ''
      local WIDTH_RATIO = 0.3 -- You can change this too
      local HEIGHT_RATIO = 0.5 -- You can change this
    '';
    plugins.nvim-tree = {
      enable = true;
      extraOptions = {
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
    };
    keymaps = [
      {
        mode = "n";
        key = "<C-n>";
        action = "<cmd>NvimTreeToggle<CR>";
        options = {
          desc = "Nvim-tree [T]oggle";
        };
      }
    ];

  };
}
