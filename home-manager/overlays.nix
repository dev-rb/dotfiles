inputs: self: super: {
  vimPlugins = super.vimPlugins.extend (
    self': super': {
      none-ls-extras = super.vimUtils.buildVimPlugin {
        name = "none-ls-extras";
        src = inputs.none-ls-extras;
      };
      vesper-nvim = super.vimUtils.buildVimPlugin {
        name = "vesper-nvim";
        src = inputs.vesper-nvim;
      };

      night-nvim = super.vimUtils.buildVimPlugin {
        name = "night-nvim";
        src = inputs.night-nvim;
      };
      everblush-nvim = super.vimUtils.buildVimPlugin {
        name = "everblush-nvim";
        src = inputs.everblush-nvim;
      };
      horizon-nvim = super.vimUtils.buildVimPlugin {
        name = "horizon-nvim";
        src = inputs.horizon-nvim;
      };
      nvim-noirbuddy = super.vimUtils.buildVimPlugin {
        name = "nvim-noirbuddy";
        src = inputs.nvim-noirbuddy;
      };
      tokyodark-nvim = super.vimUtils.buildVimPlugin {
        name = "tokyodark-nvim";
        src = inputs.tokyodark-nvim;
      };
      telescope-recent-files = super.vimUtils.buildVimPlugin {
        name = "telescope-recent-files";
        src = inputs.telescope-recent-files;
      };
      # local-term = super.vimUtils.buildVimPlugin {
      #   name = "local-term";
      #   src = inputs.local-term;
      # };
    }
  );
}
