{ ... }:

{
  programs.neovim.enable = true;

  home.file = {
    ".config/nvim" = {
      source = ../../../nvim;
      recursive = true;
      force = true;
      onChange = ''
        rm -f "$HOME/.config/nvim/lua/chadrc.lua"
        cp "${../../../nvim}/lua/chadrc.lua" "$HOME/.config/nvim/lua/chadrc.lua"
        chmod u+w "$HOME/.config/nvim/lua/chadrc.lua"
      '';
    };
  };
}
