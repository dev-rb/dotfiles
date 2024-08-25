{
  programs.nixvim = {
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
        desc = "Loaded persisted session";
        event = [ "VimEnter" ];
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
