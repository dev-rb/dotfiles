#!/usr/bin/env bash
set -euo pipefail

usage() {
  printf 'Usage: %s {home|darwin} HOST [extra switch arguments]\n' "$0" >&2
}

if [[ $# -lt 2 ]]; then
  usage
  exit 2
fi

mode=$1
host=$2
shift 2
repo_root=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)

if [[ ! $host =~ ^[a-zA-Z0-9_-]+$ ]]; then
  printf 'Invalid host selector: %s\n' "$host" >&2
  exit 2
fi
if ! command -v nix >/dev/null 2>&1; then
  printf 'Install Nix with flakes support before running this script.\n' >&2
  exit 1
fi

case "$mode" in
  home)
    exec nix run "$repo_root#home-manager" -- switch --flake "$repo_root#$host" -b backup "$@"
    ;;
  darwin)
    if ! command -v darwin-rebuild >/dev/null 2>&1; then
      printf 'Bootstrap nix-darwin first; darwin-rebuild is not on PATH.\n' >&2
      exit 1
    fi
    exec sudo darwin-rebuild switch --flake "$repo_root#$host" "$@"
    ;;
  *)
    usage
    exit 2
    ;;
esac
