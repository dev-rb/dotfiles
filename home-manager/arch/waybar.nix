{ ... }:

{
  home.file = {
    ".config/waybar/" = {
      source = ../../waybar;
      recursive = true;
    };
  };

  programs.waybar.enable = true;
}
