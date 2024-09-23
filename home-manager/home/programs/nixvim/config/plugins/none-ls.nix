{
  programs.nixvim = {
    plugins.none-ls = {
      enable = true;
    };
    plugins.none-ls.sources.formatting.prettier.enable = true;
  };
}
