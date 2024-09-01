{
  programs.nixvim = {
    plugins.smart-splits = {
      enable = false;
      settings = {
        multiplexer = "wezterm";
        at_edge = "stop";
      };

    };
  };
}
