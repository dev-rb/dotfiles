{
  programs.nixvim = {
    plugins.indent-blankline = {
      enable = true;
      settings = {
        exclude.filetypes = [
          "help"
          "terminal"
          "lazy"
          "lspinfo"
          "TelescopePrompt"
          "TelescopeResults"
          ""
        ];
        scope.enabled = false;
        indent.char = "▏";
      };

    };
  };
}
