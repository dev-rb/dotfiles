{ mkFeature, ... }:

mkFeature {
  name = "neovim";
  homeManager =
    {
      config,
      lib,
      checkoutPath,
      ...
    }:
    let
      target = "${checkoutPath}/modules/features/neovim/config";
    in
    {
      programs.neovim = {
        enable = true;
        # Keep wrapper initialization outside the live native configuration tree.
        sideloadInitLua = true;
      };

      home.file.".config/nvim".source = config.lib.file.mkOutOfStoreSymlink target;

      home.activation.checkNeovimTarget = lib.hm.dag.entryBefore [ "checkLinkTargets" ] ''
        if [ ! -f ${lib.escapeShellArg "${target}/init.lua"} ]; then
          echo "Neovim configuration target is missing init.lua: ${target}" >&2
          exit 1
        fi
      '';
    };
}
