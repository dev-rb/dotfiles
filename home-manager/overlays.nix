inputs: self: super: {
  vimPlugins = super.vimPlugins.extend (
    self': super': {
      none-ls-extras = super.vimUtils.buildVimPlugin {
        name = "none-ls-extras";
        src = inputs.none-ls-extras;
      };
      # local-term = super.vimUtils.buildVimPlugin {
      #   name = "local-term";
      #   src = inputs.local-term;
      # };
    }
  );
}
