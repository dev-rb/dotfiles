{ pkgs, config, ... }:

{
  programs.niri.enable = true;

  home.file = {
    ".config/niri/" = {
      source = ../../niri;
      recursive = true;
      force = true;
    };
  };

}
