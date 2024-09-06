{
  programs.nixvim.extraConfigLua = # lua
    ''
      require('noirbuddy').setup()
    '';
}
