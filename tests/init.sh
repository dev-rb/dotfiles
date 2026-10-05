#!/usr/bin/env bash
set -euo pipefail

repo_root=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT
mkdir "$work/bin" "$work/elsewhere"

# Stub activation tools so the wrapper test cannot activate a real configuration.
for tool in nix darwin-rebuild sudo; do
  printf '#!/usr/bin/env bash\nprintf "%%s\\n" "$(basename "$0")" "$@" > "$CALL_LOG"\n' > "$work/bin/$tool"
  chmod +x "$work/bin/$tool"
done
export PATH="$work/bin:$PATH"
export CALL_LOG="$work/call"
cd "$work/elsewhere"

"$repo_root/init.sh" home wsl-dev --show-trace
printf '%s\n' nix run "$repo_root#home-manager" -- switch --flake "$repo_root#wsl-dev" -b backup --show-trace > "$work/expected"
cmp "$work/expected" "$CALL_LOG"

"$repo_root/init.sh" darwin macbook-pro --show-trace
printf '%s\n' sudo darwin-rebuild switch --flake "$repo_root#macbook-pro" --show-trace > "$work/expected"
cmp "$work/expected" "$CALL_LOG"

# Resolve both file symlinks and symlinked parent directories outside the repo.
mkdir "$work/links"
ln -s "$repo_root/init.sh" "$work/bin/dotfiles-init"
ln -s ../bin/dotfiles-init "$work/links/relative-init"
ln -s "$work/links/relative-init" "$work/links/chain-init"
ln -s "$repo_root" "$work/repo-link"
printf '%s\n' nix run "$repo_root#home-manager" -- switch --flake "$repo_root#wsl-dev" -b backup --show-trace > "$work/expected"
for wrapper in dotfiles-init "$work/links/relative-init" "$work/links/chain-init" "$work/repo-link/init.sh"; do
  "$wrapper" home wsl-dev --show-trace
  cmp "$work/expected" "$CALL_LOG"
done
for args in '' 'invalid host' 'home bad.host'; do
  rm -f "$CALL_LOG"
  # Deliberately split fixed test cases to exercise invalid argument handling.
  if "$repo_root/init.sh" $args > "$work/error" 2>&1; then
    printf 'Expected argument rejection: %s\n' "$args" >&2
    exit 1
  fi
  if [[ -e "$CALL_LOG" ]]; then
    printf 'An invalid argument invoked an activation tool.\n' >&2
    exit 1
  fi
done

printf 'Activation wrapper checks passed with stubbed tools.\n'
