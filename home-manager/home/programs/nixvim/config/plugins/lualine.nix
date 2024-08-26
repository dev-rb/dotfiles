{ config, ... }:
{
  programs.nixvim = {
    plugins.lualine = {
      enable = true;
      globalstatus = true;
      disabledFiletypes = {
        statusline = [
          "dashboard"
          "alpha"
          "starter"
        ];
      };
      componentSeparators = {
        left = "";
        right = "";
      };
      sectionSeparators = {
        left = "";
        right = "";
      };
      #theme = {
      # normal = {
      #   a = {
      #     bg = "nil";
      #   };
      #   b = {
      #     bg = "nil";
      #   };
      #   c = {
      #     bg = "nil";
      #   };
      #   z = {
      #     bg = "nil";
      #   };
      #   y = {
      #     bg = "nil";
      #   };
      # };
      #};
      inactiveSections = {
        lualine_a = [ ];
        lualine_b = [ "diff" ];
        lualine_c = [ ];
        lualine_x = [
          "filename"
          "filetype"
        ];
        lualine_y = [
          "filetype"
          "filename"
        ];
        lualine_z = [ "location" ];
      };
      sections = {
        lualine_a = [
          {
            name = "mode";
            fmt = "string.lower";
            separator.left = "";
          }
        ];
        lualine_b = [
          {
            name = "branch";
            icon = "";
          }
        ];
        lualine_c = [
          {
            name = "diagnostic";
            extraConfig = {
              symbols = {
                error = " ";
                warn = " ";
                info = " ";
                hint = "󰝶 ";
              };
            };
          }
        ];
        lualine_x = [ "" ];
        lualine_y = [
          {
            name = "lsp";
            padding = 0;
            fmt = ''
              function()
                for _, client in ipairs(vim.lsp.get_clients()) do
                  if client.attached_buffers[vim.api.nvim_win_get_buf(vim.g.statusline_winid or 0)] then
                    return (vim.o.columns > 100 and "  ".. client.name .. " ") or "   LSP "
                  end
                end

                return ""
              end

            '';

          }
          {
            name = "filetype";
            padding = 0;
            extraConfig = {
              icon_only = true;
            };
            separator.left = "|";
          }
          {
            name = "filename";
            padding = 0;
            extraConfig = {
              symbols = {
                modified = "";
                readonly = "👁️";
                unnamed = "";
              };
            };
            separator.left = "";
            separator.right = "";
          }
        ];

        lualine_z = [ "" ];
      };
    };
  };
}
