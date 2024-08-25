{
  programs.nixvim = {
    plugins.oil = {
      enable = true;
      settings = {
        view_options = {
          show_hidden = true;
        };
	float = {
	    padding = 5;
	    max_width = 65;
	    max_height = 0;
	    border = "rounded";
	    win_options = {
	      winblend = 0;
	    };
	    preview_split = "auto";
	    override = ''function(conf)
	      return conf
	    end'';
	  };
      };
    };
    keymaps = [
      {
        mode = "n";
        key = "<C-n>";
        action = "<cmd>lua require('oil').toggle_float() <CR>";
        options = {
          desc = "[O]il";
        };
      }
    ];
  };
}
