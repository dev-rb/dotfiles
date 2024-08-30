{
  imports = [
    ./plugins
    ./options.nix
    ./autocmd.nix
    ./keymaps.nix
    ./theme.nix
  ];
  # programs.nixvim.extraConfigLua = builtins.readFile ./lua/local-term/init.lua;
}
