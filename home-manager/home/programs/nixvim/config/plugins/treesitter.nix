{ pkgs, ... }:
{
  programs.nixvim = {
    plugins = {
      treesitter = {
        enable = true;
        settings = {
          highlight.enable = true;
          indent.enable = true;
          ensureInstalled = [
            "css"
            "html"
            "javascript"
            "lua"
            "python"
            "scss"
            "tsx"
            "typescript"
          ];
        };
        languageRegister = {
          markdown = "mdx";
        };
        nixvimInjections = true;
        grammarPackages = pkgs.vimPlugins.nvim-treesitter.allGrammars;
      };
    };
    filetype = {
      extension = {
        mdx = "mdx";
      };
    };
  };
}
