#!/usr/bin/env bash
set -euo pipefail

usage() {
  printf 'Usage: %s [--yes] [HOST] [-- switch arguments...]\n' "$0" >&2
  printf 'Without HOST, select a compatible configuration from the menu. --yes requires HOST.\n' >&2
  printf 'Use -- before any activation-tool arguments.\n' >&2
}
fail() {
  printf '%s\n' "$*" >&2
  exit 1
}

have_tty() {
  ( : </dev/tty ) 2>/dev/null
}

script=${BASH_SOURCE[0]}
while [[ -L $script ]]; do
  script_dir=$(cd -P -- "$(dirname -- "$script")" && pwd)
  target=$(readlink "$script")
  if [[ $target = /* ]]; then
    script=$target
  else
    script=$script_dir/$target
  fi
done
repo_root=$(cd -P -- "$(dirname -- "$script")" && pwd)

host=''
yes=0
forwarded=()
while [[ $# -gt 0 ]]; do
  case $1 in
    --help|-h) usage; exit 0 ;;
    --yes) yes=1; shift ;;
    --) shift; forwarded+=("$@"); break ;;
    *)
      if [[ -z $host && $1 != -* ]]; then
        host=$1
      else
        printf 'Unexpected argument: %s. Pass one HOST and use -- before activation-tool arguments.\n' "$1" >&2
        usage
        exit 2
      fi
      shift
      ;;
  esac
done
if [[ -n $host && ! $host =~ ^[a-zA-Z0-9_-]+$ ]]; then
  fail "Invalid host selector: $host. Use a name from the configuration list."
fi
if [[ $yes -eq 1 && -z $host ]]; then
  usage
  exit 2
fi
if ! command -v nix >/dev/null 2>&1; then
  for nix_profile in /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh "$HOME/.nix-profile/etc/profile.d/nix.sh"; do
    if [[ -f $nix_profile ]]; then
      # The installed Nix profile sets PATH; it does not change user configuration.
      set +u
      # shellcheck source=/dev/null
      . "$nix_profile"
      set -u
      command -v nix >/dev/null 2>&1 && break
    fi
  done
fi
command -v nix >/dev/null 2>&1 || fail 'Nix is not on PATH. Run init.sh first or load the installed Nix shell profile.'

nix_eval() {
  nix --extra-experimental-features 'nix-command flakes' eval --no-update-lock-file --raw "$@" </dev/null
}

case "$(uname -s):$(uname -m)" in
  Darwin:arm64|Darwin:aarch64) platform=aarch64-darwin ;;
  Darwin:x86_64) platform=x86_64-darwin ;;
  Linux:x86_64) platform=x86_64-linux ;;
  Linux:aarch64|Linux:arm64) platform=aarch64-linux ;;
  *) fail "Unsupported native platform: $(uname -s) $(uname -m)." ;;
esac

home_names=$(nix_eval --apply 'c: builtins.concatStringsSep "\n" (builtins.attrNames c)' "$repo_root#homeConfigurations")
darwin_names=$(nix_eval --apply 'c: builtins.concatStringsSep "\n" (builtins.attrNames c)' "$repo_root#darwinConfigurations")

names=()
modes=()
platforms=()
users=()
homes=()
collect() {
  local mode=$1 name_list=$2 name ref system user home_dir
  while IFS= read -r name; do
    [[ -n $name ]] || continue
    if [[ -n $host && $host != "$name" ]]; then
      continue
    fi
    [[ $name =~ ^[a-zA-Z0-9_-]+$ ]] || fail "Unsupported configuration name: $name. Use letters, digits, underscores, or hyphens."
    ref="$repo_root#${mode}Configurations.\"${name}\""
    if [[ $mode = home ]]; then
      system=$(nix_eval --apply 'h: h.activationPackage.system' "$ref")
    else
      system=$(nix_eval --apply 'd: d.system.system' "$ref")
    fi
    if [[ $system != "$platform" ]]; then
      if [[ $host = "$name" ]]; then
        fail "Host $name ($mode) targets $system, but this machine is $platform. Select a compatible host."
      fi
      continue
    fi
    if [[ $mode = home ]]; then
      user=$(nix_eval --apply 'h: h.config.home.username' "$ref")
      home_dir=$(nix_eval --apply 'h: h.config.home.homeDirectory' "$ref")
    else
      user=$(nix_eval --apply 'd: d.config.system.primaryUser' "$ref")
      # shellcheck disable=SC2016 # Interpolation belongs to Nix, not Bash.
      home_dir=$(nix_eval --apply 'd: d.config.users.users.${d.config.system.primaryUser}.home' "$ref")
    fi
    names+=("$name")
    modes+=("$mode")
    platforms+=("$system")
    users+=("$user")
    homes+=("$home_dir")
  done <<< "$name_list"
}
collect home "$home_names"
collect darwin "$darwin_names"

if [[ ${#names[@]} -eq 0 ]]; then
  if [[ -n $host ]]; then
    fail "Host $host is not in homeConfigurations or darwinConfigurations. Check the host name."
  fi
  fail "No configurations target $platform. Check the flake host declarations."
fi

selection=0
if [[ -z $host ]]; then
  printf 'Compatible configurations for %s:\n' "$platform" >&2
  for ((i=0; i<${#names[@]}; i++)); do
    printf '%d) %s  %s  %s  %s  %s\n' "$((i+1))" "${names[i]}" "${modes[i]}" "${platforms[i]}" "${users[i]}" "${homes[i]}" >&2
  done
  have_tty || fail 'Interactive selection requires a terminal. Pass HOST and --yes for noninteractive activation.'
  printf 'Select a number: ' >&2
  IFS= read -r choice </dev/tty || fail 'No selection received.'
  [[ $choice =~ ^[1-9][0-9]*$ ]] || fail 'Enter a listed number.'
  (( choice >= 1 && choice <= ${#names[@]} )) || fail 'Enter a listed number.'
  selection=$((choice-1))
else
  for ((i=0; i<${#names[@]}; i++)); do
    if [[ ${names[i]} = "$host" ]]; then
      selection=$i
      break
    fi
  done
fi

actual_user=$(id -un)
selected_user=${users[selection]}
selected_home=${homes[selection]}
[[ $actual_user = "$selected_user" ]] || fail "Account mismatch: ${names[selection]} requires $selected_user, but you are $actual_user. Sign in as $selected_user before activation."
if [[ $platform = *-darwin ]]; then
  account_info=$(dscl . -read "/Users/$actual_user" NFSHomeDirectory) || fail "Cannot look up $actual_user's home directory with dscl. Check the local account."
  actual_home=${account_info#NFSHomeDirectory: }
else
  account_info=$(getent passwd "$actual_user") || fail "Cannot look up $actual_user's home directory with getent. Check the local account."
  actual_home=$(printf '%s\n' "$account_info" | cut -d: -f6)
fi
[[ $actual_home = "$selected_home" ]] || fail "Home directory mismatch: ${names[selection]} requires $selected_home, but $actual_user has $actual_home. Correct the host declaration or use the matching account."
[[ $HOME = "$selected_home" ]] || fail "Home directory mismatch: HOME is $HOME, but ${names[selection]} requires $selected_home. Set HOME to your account's home directory before activation."

if [[ $yes -eq 0 ]]; then
  have_tty || fail 'Activation requires confirmation on a terminal. Pass HOST and --yes for noninteractive activation.'
  printf 'Activate %s (%s) for %s at %s? [y/N] ' "${names[selection]}" "${modes[selection]}" "$selected_user" "$selected_home" >&2
  IFS= read -r answer </dev/tty || fail 'No confirmation received.'
  [[ $answer = y || $answer = Y || $answer = yes || $answer = YES ]] || fail 'Activation cancelled.'
fi

# Bash 3.2 treats empty arrays as unset under nounset.
set -- ${forwarded[@]+"${forwarded[@]}"}

if [[ ${modes[selection]} = home ]]; then
  # Home Manager also invokes Nix internally, including its flake-support check.
  export NIX_CONFIG="${NIX_CONFIG:+$NIX_CONFIG$'\n'}extra-experimental-features = nix-command flakes"
  exec nix --extra-experimental-features 'nix-command flakes' run --no-update-lock-file "$repo_root#home-manager" -- switch --flake "$repo_root#${names[selection]}" -b backup --no-update-lock-file --extra-experimental-features 'nix-command flakes' "$@"
else
  # Build as the account owner; the pinned CLI includes Nix in its own PATH.
  cli_package=$(nix --extra-experimental-features 'nix-command flakes' build --no-update-lock-file --no-link --print-out-paths "$repo_root#darwin-rebuild")
  exec sudo "$cli_package/bin/darwin-rebuild" switch --flake "$repo_root#${names[selection]}" --no-update-lock-file "$@"
fi
