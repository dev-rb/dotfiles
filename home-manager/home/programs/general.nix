{ ... }:

{
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.wezterm.enableZshIntegration = true;

  programs.yazi = {
    enable = true;
    enableZshIntegration = true;

    settings = {
      preview = {
        max_width = 10000;
        max_height = 10000;
      };
    };
  };
}
