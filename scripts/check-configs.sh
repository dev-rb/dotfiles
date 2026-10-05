#!/usr/bin/env bash
set -euo pipefail

repo_root=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
cd "$repo_root"

files=()
while IFS= read -r -d '' file; do
  files+=("$file")
done < <(git ls-files -z -- '*.nix')

nix fmt -- --check "${files[@]}"
bash -n init.sh scripts/check-configs.sh
nix flake check --no-build --all-systems --no-update-lock-file
nix eval --json --no-update-lock-file .#homeConfigurations \
  --apply 'builtins.mapAttrs (_: home: home.activationPackage.drvPath)'
nix eval --json --no-update-lock-file .#darwinConfigurations \
  --apply 'builtins.mapAttrs (_: darwin: darwin.system.drvPath)'

printf 'Configuration checks passed; nothing was activated.\n'
