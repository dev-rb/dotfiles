{
  programs.nixvim.colorschemes.cyberdream = {
    enable = true;
    settings = {
      variant = "dark";
      transparent = true;
      extensions = {
        cmp = true;
        gitsigns = true;
        treesitter = true;
        notify = true;
      };
    };
  };
}
