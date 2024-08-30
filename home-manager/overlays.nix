inputs: self: super: {
  vimPlugins = super.vimPlugins.extend (
    self': super': {
      local-term = super.vimUtils.buildVimPlugin {
        name = "local-term";
        src = inputs.local-term;
      };
    }
  );
}
