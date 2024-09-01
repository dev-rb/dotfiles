{
  programs.nixvim = {
    plugins.nvim-autopairs = {
      enable = false;
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
