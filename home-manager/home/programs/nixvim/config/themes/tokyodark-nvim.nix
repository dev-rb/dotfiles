{
  programs.nixvim.extraConfigLua = # lua
    ''
      require('tokyodark').setup()
    '';
}
