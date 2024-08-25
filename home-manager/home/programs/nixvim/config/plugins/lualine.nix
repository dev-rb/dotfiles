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
        lualine_x = [
          "filename"
          "filetype"
        ];
        lualine_b = [ "diff" ];
        lualine_z = [ "location" ];
      };
      sections = {
        lualine_a = [
          {
            name = "mode";
            fmt = "string.lower";
            separator.left = "";
            separator.right = "";
          }
        ];
        lualine_b = [
          {
            name = "branch";
            icon = "";
            separator.left = "";
            separator.right = "";
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
            separator.left = "";
            separator.right = "";
          }
        ];
        lualine_x = [ "" ];
        lualine_y = [
          {
            name = "filetype";
            extraConfig = {
              icon_only = true;
            };
            separator.left = "";
          }
          {
            name = "filename";
            extraConfig = {
              symbols = {
                modified = "";
                readonly = "👁️";
                unnamed = "";
              };
            };
            separator.left = "";
            separator.right = "";
          }
        ];
        lualine_z = [ ];
      };
    };
  };
}
