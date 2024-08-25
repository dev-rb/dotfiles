{
  programs.nixvim = {
    plugins = {
      treesitter = {
        enable = true;
        settings = {
          highlight.enable = true;
          indent.enable = true;
          context_commentstring.enable = true;
          autotag.enable = true;
        };
        languageRegister = {
          markdown = "mdx";
        };
      };
    };
    filetype = {
      extension = {
        mdx = "mdx";
      };
    };
  };
}
