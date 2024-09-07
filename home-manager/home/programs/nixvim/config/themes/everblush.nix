{
  programs.nixvim.extraConfigLua = # lua
    ''
      require('everblush').setup({

      })
    '';
}
