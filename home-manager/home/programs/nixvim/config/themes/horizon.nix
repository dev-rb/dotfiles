{
  programs.nixvim.extraConfigLua = # lua
    ''
      require('horizon').setup()
    '';
}
