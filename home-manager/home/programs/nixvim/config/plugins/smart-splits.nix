{
  programs.nixvim = {
    plugins.smart-splits = {
      enable = true;
      settings = {
        multiplexer = "wezterm";
      };

    };
  };
}
