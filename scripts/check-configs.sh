#!/usr/bin/env bash
# Validate repository formatting, shell syntax, and every declared host.
# Do not build host generations or activate user/system configuration.
set -euo pipefail

# Run from the checkout root regardless of the caller's working directory.
repo_root=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
cd "$repo_root"
# Enable flakes per command without changing the user's Nix configuration.
nix_command=(nix --extra-experimental-features 'nix-command flakes')

# Only tracked Nix files are checked. Stage new files first so Git's file
# list and Nix's Git-backed flake source both include them.
# NUL delimiters preserve filenames containing whitespace.
files=()
while IFS= read -r -d '' file; do
  files+=("$file")
done < <(git ls-files -z -- '*.nix')

# Check formatting without rewriting files, then parse the entry-point
# scripts without executing setup or activation.
"${nix_command[@]}" fmt -- --check "${files[@]}"
bash -n init.sh switch.sh scripts/check-configs.sh

# Evaluate flake outputs on all declared systems without building checks
# or updating flake.lock. Nix can still fetch inputs or realize the formatter.
"${nix_command[@]}" flake check --no-build --all-systems --no-update-lock-file

# Force each host's activation/system derivation to evaluate; listing host
# names alone does not expose errors hidden by Nix's lazy evaluation.
"${nix_command[@]}" eval --json --no-update-lock-file .#homeConfigurations \
  --apply 'builtins.mapAttrs (_: home: home.activationPackage.drvPath)'
"${nix_command[@]}" eval --json --no-update-lock-file .#darwinConfigurations \
  --apply 'builtins.mapAttrs (_: darwin: darwin.system.drvPath)'

printf 'Configuration checks passed; nothing was activated.\n'
