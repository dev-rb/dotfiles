#!/usr/bin/env bash
# Select and activate a compatible host from this checkout's flake.
# Validate the platform, account, and home directory before activating a host.
# Activation requires terminal confirmation, or an explicit HOST with --yes.
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

# Prompts use the controlling terminal rather than consuming piped stdin.
have_tty() {
  ( : </dev/tty ) 2>/dev/null
}

# Find the real checkout when invoked elsewhere or through symlink chains.
# Resolve relative symlink targets against each link's containing directory.
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

# Accept one host selector. Everything after -- is passed unchanged to the
# activation tool; --yes skips confirmation but cannot select a host for you.
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

# Restrict selectors to names safe to embed in Nix attribute references.
if [[ -n $host && ! $host =~ ^[a-zA-Z0-9_-]+$ ]]; then
  fail "Invalid host selector: $host. Use a name from the configuration list."
fi
if [[ $yes -eq 1 && -z $host ]]; then
  usage
  exit 2
fi

# Reuse an installed Nix even if this shell has not loaded its profile yet.
# Prerequisite installation belongs to init.sh, not this activation script.
if ! command -v nix >/dev/null 2>&1; then
  for nix_profile in /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh "$HOME/.nix-profile/etc/profile.d/nix.sh"; do
    if [[ -f $nix_profile ]]; then
      # The installed Nix profile sets PATH; it does not change user configuration.
      # Installed profiles can reference unset variables while initializing.
      set +u
      # shellcheck source=/dev/null
      . "$nix_profile"
      set -u
      command -v nix >/dev/null 2>&1 && break
    fi
  done
fi
command -v nix >/dev/null 2>&1 || fail 'Nix is not on PATH. Run init.sh first or load the installed Nix shell profile.'

# Evaluate without updating flake.lock or reading interactive input.
# Experimental features apply to this command, not the user's config file.
nix_eval() {
  nix --extra-experimental-features 'nix-command flakes' eval --no-update-lock-file --raw "$@" </dev/null
}

# Match the native OS and architecture to Nix's system names.
# WSL uses the same Linux platform identifiers as other Linux installations.
case "$(uname -s):$(uname -m)" in
  Darwin:arm64|Darwin:aarch64) platform=aarch64-darwin ;;
  Darwin:x86_64) platform=x86_64-darwin ;;
  Linux:x86_64) platform=x86_64-linux ;;
  Linux:aarch64|Linux:arm64) platform=aarch64-linux ;;
  *) fail "Unsupported native platform: $(uname -s) $(uname -m)." ;;
esac

# Constructors expose plain identity records, without evaluating host modules.
# One query loads the menu; TSV preserves spaces without requiring jq at setup.
# Reject delimiters inside fields so parsing cannot truncate an identity.
host_metadata=$(nix_eval --apply '
  hosts: let
    format = h: let fields = [ h.name h.mode h.system h.user h.homeDirectory ];
      in assert builtins.all (v: builtins.isString v && builtins.match "[^\t\n\r]+" v != null) fields;
        builtins.concatStringsSep "\t" fields;
    ordered = builtins.sort (a: b: a.name < b.name || (a.name == b.name && a.mode < b.mode)) hosts;
  in builtins.concatStringsSep "\n" (map format ordered)
' "$repo_root#hostMetadata")
# Parallel arrays store each candidate's name, activation mode, and account.
names=()
modes=()
platforms=()
users=()
homes=()
unsupported_mode=''

# Filter declared platforms before selection, without forcing configurations.
# NixOS metadata is reserved for future activation support.
while IFS=$'\t' read -r name mode system user home_dir; do
  [[ -n $name ]] || continue
  if [[ -n $host && $host != "$name" ]]; then
    continue
  fi
  case $mode in
    home|darwin) ;;
    *)
      if [[ -n $host && $host = "$name" ]]; then
        unsupported_mode=$mode
      fi
      continue
      ;;
  esac
  [[ $name =~ ^[a-zA-Z0-9_-]+$ ]] || fail "Unsupported configuration name: $name. Use letters, digits, underscores, or hyphens."
  if [[ $system != "$platform" ]]; then
    if [[ $host = "$name" ]]; then
      fail "Host $name ($mode) targets $system, but this machine is $platform. Select a compatible host."
    fi
    continue
  fi
  names+=("$name")
  modes+=("$mode")
  platforms+=("$system")
  users+=("$user")
  homes+=("$home_dir")
done <<< "$host_metadata"

if [[ ${#names[@]} -eq 0 ]]; then
  if [[ -n $host ]]; then
    [[ -z $unsupported_mode ]] || fail "Host $host uses unsupported activation mode $unsupported_mode."
    fail "Host $host is not in the flake's host metadata. Check the host name."
  fi
  fail "No configurations target $platform. Check the flake host declarations."
fi

# Menu selection is terminal-only. Explicit HOST bypasses the menu but
# still validates the account. Only --yes bypasses activation confirmation.
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

# Only the selected host gets full evaluation. Recheck the compiled identity
# so module overrides cannot bypass platform, account, or home validation.
ref="$repo_root#${modes[selection]}Configurations.\"${names[selection]}\""
if [[ ${modes[selection]} = home ]]; then
  identity_fields='h: [ h.activationPackage.system h.config.home.username h.config.home.homeDirectory ]'
else
  # shellcheck disable=SC2016 # Interpolation belongs to Nix, not Bash.
  identity_fields='d: [ d.system.system d.config.system.primaryUser d.config.users.users.${d.config.system.primaryUser}.home ]'
fi
selected_identity=$(nix_eval --apply "host:
  let fields = ($identity_fields) host;
  in assert builtins.all (v: builtins.isString v && builtins.match \"[^\\t\\n\\r]+\" v != null) fields;
    builtins.concatStringsSep \"\\t\" fields
" "$ref")
IFS=$'\t' read -r selected_system selected_user selected_home <<< "$selected_identity"
[[ $selected_system = "$platform" ]] || fail "Host ${names[selection]} evaluates to $selected_system, but this machine is $platform."
[[ $selected_system = "${platforms[selection]}" && $selected_user = "${users[selection]}" && $selected_home = "${homes[selection]}" ]] || fail "Host metadata for ${names[selection]} differs from its evaluated configuration. Check the host declaration and identity overrides."
# Check the actual account record as well as HOME, which can be overridden.
# Refuse activation into another account or a different home directory.
actual_user=$(id -un)
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

# Default to cancellation; only an explicit affirmative answer activates.
# Noninteractive runs must supply both HOST and --yes.
if [[ $yes -eq 0 ]]; then
  have_tty || fail 'Activation requires confirmation on a terminal. Pass HOST and --yes for noninteractive activation.'
  printf 'Activate %s (%s) for %s at %s? [y/N] ' "${names[selection]}" "${modes[selection]}" "$selected_user" "$selected_home" >&2
  IFS= read -r answer </dev/tty || fail 'No confirmation received.'
  [[ $answer = y || $answer = Y || $answer = yes || $answer = YES ]] || fail 'Activation cancelled.'
fi

# Preserve quoting and argument boundaries when forwarding tool arguments.
# Bash 3.2 treats empty arrays as unset under nounset.
set -- ${forwarded[@]+"${forwarded[@]}"}

# Use activation tools pinned by this flake, not whichever CLI is on PATH.
# exec hands control to the tool; its exit status becomes this script's status.
if [[ ${modes[selection]} = home ]]; then
  # Home Manager also invokes Nix internally, including its flake-support check.
  export NIX_CONFIG="${NIX_CONFIG:+$NIX_CONFIG$'\n'}extra-experimental-features = nix-command flakes"
  # Back up conflicting unmanaged dotfiles with the backup suffix instead
  # of overwriting them; existing backup collisions still stop activation.
  exec nix --extra-experimental-features 'nix-command flakes' run --no-update-lock-file "$repo_root#home-manager" -- switch --flake "$repo_root#${names[selection]}" -b backup --no-update-lock-file --extra-experimental-features 'nix-command flakes' "$@"
else
  # Build as the account owner; the pinned CLI includes Nix in its own PATH.
  cli_package=$(nix --extra-experimental-features 'nix-command flakes' build --no-update-lock-file --no-link --print-out-paths "$repo_root#darwin-rebuild")
  # Only Darwin system activation uses sudo; CLI realization above stays
  # unprivileged. The Darwin host also activates its integrated Home Manager.
  exec sudo "$cli_package/bin/darwin-rebuild" switch --flake "$repo_root#${names[selection]}" --no-update-lock-file "$@"
fi
