{ ... }:

{
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.wezterm.enableZshIntegration = true;
}
