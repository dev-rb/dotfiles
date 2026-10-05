#!/usr/bin/env bash
set -euo pipefail

repo_root=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
cd "$repo_root"

files=()
while IFS= read -r -d '' file; do
  files+=("$file")
done < <(git ls-files -z -- '*.nix')

nix fmt -- --check "${files[@]}"
bash -n init.sh scripts/check-configs.sh tests/init.sh
bash tests/init.sh
nix flake check --no-build --all-systems --no-update-lock-file
system=$(nix eval --impure --raw --expr builtins.currentSystem)
nix build ".#checks.$system.host-settings" --no-link --no-update-lock-file

printf 'Configuration checks passed; nothing was activated.\n'
