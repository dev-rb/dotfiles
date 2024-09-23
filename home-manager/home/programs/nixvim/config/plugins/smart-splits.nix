{
  programs.nixvim = {
    plugins.smart-splits = {
      enable = true;
      settings = {
        multiplexer_integration = "wezterm";
        at_edge = "stop";
      };
    };
  };
}
