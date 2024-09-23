{ pkgs, ... }:
{
  programs.nixvim = {
    plugins = {
      treesitter = {
        enable = true;
        settings = {
          highlight.enable = true;
          indent.enable = true;
          ensure_installed = [
            "css"
            "html"
            "javascript"
            "lua"
            "python"
            "scss"
            "nix"
            "tsx"
            "typescript"
          ];
        };
        languageRegister = {
          markdown = "mdx";
        };
        nixvimInjections = true;
      };
    };
    filetype = {
      extension = {
        mdx = "mdx";
      };
    };
  };
}
