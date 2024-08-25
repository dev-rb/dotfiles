{ pkgs, ... }:

{
  programs.zoxide.enable = true;

  programs.wezterm.enableZshIntegration = true;
}
