{
  programs.nixvim = {
    autoGroups = {
      restore_session = {
        clear = true;
      };
    };
    autoCmd = [
      {
        desc = "Highlight on yank";
        event = [ "TextYankPost" ];
        callback.__raw = # lua
          ''
            function()
              vim.highlight.on_yank()
            end
          '';
      }
      {
        group = "restore_session";
        desc = "Loaded persisted session";
        event = [ "UIEnter" ];
        nested = true;
        callback.__raw = ''
          function()
            if vim.fn.getcwd() ~= vim.env.HOME then
              require("persistence").load()
            end
          end
        '';

      }
    ];
  };
}
