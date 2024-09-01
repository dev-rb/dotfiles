{
  programs.nixvim.colorschemes.cyberdream = {
    enable = false;
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
