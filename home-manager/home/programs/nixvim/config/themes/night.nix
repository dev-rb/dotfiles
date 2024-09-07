{
  programs.nixvim.extraConfigLua = # lua
    ''
      require('night').setup()
    '';
}
