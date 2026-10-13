{ mkFeature, inputs, ... }:

mkFeature {
  name = "pi";
  homeManager =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      package = inputs.pi.packages.${pkgs.stdenv.hostPlatform.system}.default;
      defaults = (pkgs.formats.json { }).generate "pi-settings-defaults.json" (import ./settings.nix);
      settingsPath = "${config.home.homeDirectory}/.pi/agent/settings.json";
    in
    {
      programs.pi-coding-agent = {
        enable = true;
        inherit package;
        # Keep settings unset: Home Manager would otherwise make them read-only.
      };

      # Deploy reusable resources, never auth.json, sessions, or package installs.
      home.file = {
        ".pi/agent/settings.defaults.json".source = defaults;
        ".pi/agent/themes/dotfiles-workbench-dark.json".source = ./themes/dotfiles-workbench-dark.json;

        ".pi/agent/skills/commit-message/SKILL.md".source = ./skills/commit-message/SKILL.md;
        ".pi/agent/skills/decision-log/SKILL.md".source = ./skills/decision-log/SKILL.md;
        ".pi/agent/skills/feature-planning/SKILL.md".source = ./skills/feature-planning/SKILL.md;
      };

      # Initialize a writable settings file once. Later activations leave local
      # preferences and package declarations alone, including existing symlinks.
      home.activation.piSettingsDefaults = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
        if [[ ! -e ${lib.escapeShellArg settingsPath} && ! -L ${lib.escapeShellArg settingsPath} ]]; then
          # Run the whole transaction through Home Manager's dry-run-aware helper.
          run ${pkgs.coreutils}/bin/env PATH=${lib.makeBinPath [ pkgs.coreutils ]} \
            ${pkgs.bash}/bin/bash -c '
              set -euo pipefail
              source=$1
              target=$2
              temporary=$(mktemp "$target.init.XXXXXX")
              lock="$target.lock"
              locked=0
              cleanup() {
                rm -f -- "$temporary"
                if [[ $locked = 1 ]]; then rmdir -- "$lock"; fi
              }
              trap cleanup EXIT
              install -m 600 -- "$source" "$temporary"

              # Pi uses this lock directory. Skip initialization if Pi is busy.
              if ! mkdir -- "$lock" 2>/dev/null; then
                printf "Pi settings are busy; first-run initialization skipped.\\n" >&2
                exit 0
              fi
              locked=1

              # Publish complete JSON atomically, without replacing a file or link
              # created since the initial check. Both paths share one filesystem.
              if [[ ! -e $target && ! -L $target ]]; then
                if ! ln -T -- "$temporary" "$target"; then
                  [[ -e $target || -L $target ]] || exit 1
                fi
              fi
            ' -- ${defaults} ${lib.escapeShellArg settingsPath}
        fi
      '';
    };
}
