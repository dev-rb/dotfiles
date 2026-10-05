{ lib }:
{
  # Publish ordinary modules; importing a feature does not enable the feature.
  mkFeature =
    {
      name,
      homeManager ? null,
      darwin ? null,
      nixos ? null,
    }:
    assert name != "";
    assert homeManager != null || darwin != null || nixos != null;
    {
      flake.modules =
        lib.optionalAttrs (homeManager != null) { homeManager.${name} = homeManager; }
        // lib.optionalAttrs (darwin != null) { darwin.${name} = darwin; }
        // lib.optionalAttrs (nixos != null) { nixos.${name} = nixos; };
    };

  # Store-backed native files and directories, relative to XDG_CONFIG_HOME.
  mkConfigFiles = sources: {
    xdg.configFile = lib.mapAttrs (_: source: { inherit source; }) sources;
  };
}
