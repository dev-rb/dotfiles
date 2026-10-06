{ mkFeature, inputs, ... }:

mkFeature {
  name = "herdr";
  homeManager =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      package = inputs.herdr.packages.${pkgs.stdenv.hostPlatform.system}.default;
      defaults = (pkgs.formats.toml { }).generate "herdr-settings-defaults.toml" (import ./settings.nix);
      settingsPath = "${config.xdg.configHome}/herdr/config.toml";
    in
    {
      imports = [ ./extensions/seamless-nav ];
      programs.herdr = {
        enable = true;
        inherit package;
        # Keep settings unset so Herdr and local plugins retain a writable config.
      };

      # Home Manager updates this baseline using its normal file/backup rules.
      # Machines, sessions, and plugin data remain outside Home Manager.
      xdg.configFile."herdr/config.defaults.toml".source = defaults;

      # Resolve overrides available during activation without changing Herdr's
      # runtime environment. Preserve existing active settings and any symlink.
      home.activation.herdrSettingsDefaults = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
        herdrSettingsPath=${lib.escapeShellArg settingsPath}
        if [[ -n ''${HERDR_CONFIG_PATH+x} ]]; then
          herdrSettingsPath=$HERDR_CONFIG_PATH
        elif [[ -n ''${XDG_CONFIG_HOME+x} ]]; then
          herdrSettingsPath="''${XDG_CONFIG_HOME:+$XDG_CONFIG_HOME/}herdr/config.toml"
        fi
        if [[ -n $herdrSettingsPath && ! -e $herdrSettingsPath && ! -L $herdrSettingsPath ]]; then
          # Keep creation inside the dry-run-aware helper. Publish complete TOML
          # atomically from the same directory, even during concurrent activations.
          run ${pkgs.coreutils}/bin/env PATH=${lib.makeBinPath [ pkgs.coreutils ]} \
            ${pkgs.bash}/bin/bash -c '
              set -euo pipefail
              source=$1
              target=$2
              mkdir -p -- "$(dirname -- "$target")"
              temporary=$(mktemp "$target.init.XXXXXX")
              cleanup() { rm -f -- "$temporary"; }
              trap cleanup EXIT
              install -m 600 -- "$source" "$temporary"

              # Hard-link creation cannot overwrite a concurrently created file.
              if ! ln -T -- "$temporary" "$target"; then
                [[ -e $target || -L $target ]] || exit 1
              fi
            ' -- ${defaults} "$herdrSettingsPath"
        fi
      '';
    };
}
