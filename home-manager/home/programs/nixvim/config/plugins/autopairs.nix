{
  programs.nixvim = {
    plugins.nvim-autopairs = {
      enable = true;
      settings = {
        fast_wrap = { };
        disable_filetype = [
          "TelescopePrompt"
          "vim"
        ];
      };
    };
  };
}
