{
  programs.nixvim = {
    plugins.gitsigns = {
      enable = true;
      settings = {
        signcolumn = true;
        signs = {
          add = {
            text = "│";
          };
          change = {
            text = "│";
          };
          delete = {
            text = "󰍵";
          };
          topdelete = {
            text = "‾";
          };
          changedelete = {
            text = "~";
          };
          untracked = {
            text = "│";
          };
        };

      };
    };
  };
}
