#!/usr/bin/env bash
set -euo pipefail

repo_root=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
cd "$repo_root"
nix_command=(nix --extra-experimental-features 'nix-command flakes')

files=()
while IFS= read -r -d '' file; do
  files+=("$file")
done < <(git ls-files -z -- '*.nix')

"${nix_command[@]}" fmt -- --check "${files[@]}"
bash -n init.sh switch.sh scripts/check-configs.sh
"${nix_command[@]}" flake check --no-build --all-systems --no-update-lock-file
"${nix_command[@]}" eval --json --no-update-lock-file .#homeConfigurations \
  --apply 'builtins.mapAttrs (_: home: home.activationPackage.drvPath)'
"${nix_command[@]}" eval --json --no-update-lock-file .#darwinConfigurations \
  --apply 'builtins.mapAttrs (_: darwin: darwin.system.drvPath)'

printf 'Configuration checks passed; nothing was activated.\n'
