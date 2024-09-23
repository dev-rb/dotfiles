{
  programs.nixvim.extraConfigLua = # lua
    ''
      require('tokyodark').setup({
        transparent_background = false, -- set background to transparent
        gamma = 1.00, -- adjust the brightness of the theme
        styles = {
          comments = { italic = false }, -- style for comments
          keywords = { italic = false }, -- style for keywords
          identifiers = { italic = false }, -- style for identifiers
          functions = { italic = false }, -- style for functions
          variables = { italic = false }, -- style for variables
        },
        terminal_colors = true, -- enable terminal colors
      })
    '';
}
