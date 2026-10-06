#!/usr/bin/env bash
set -euo pipefail

usage() {
  printf 'Usage: %s\n' "$0"
  printf 'Install missing Nix prerequisites. Does not activate dotfiles.\n'
}

if [[ $# -gt 0 ]]; then
  case "$1" in
    -h|--help) usage; exit 0 ;;
    *) usage >&2; exit 2 ;;
  esac
fi

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

if [[ $EUID -eq 0 ]]; then
  printf 'Run init.sh as your normal user, not with sudo.\n' >&2
  exit 1
fi

platform=$(uname -s)
case "$platform" in
  Darwin|Linux) ;;
  *) printf 'Unsupported platform: %s\n' "$platform" >&2; exit 1 ;;
esac

load_nix_environment() {
  local profile
  for profile in \
    /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh \
    "$HOME/.nix-profile/etc/profile.d/nix.sh"; do
    if [[ -r $profile ]]; then
      set +u
      # shellcheck source=/dev/null
      . "$profile"
      set -u
      if command -v nix >/dev/null 2>&1; then
        return
      fi
    fi
  done
}

if ! command -v nix >/dev/null 2>&1; then
  load_nix_environment
fi

if ! command -v nix >/dev/null 2>&1; then
  require_sudo() {
    if ! command -v sudo >/dev/null 2>&1; then
      printf 'Install sudo or arrange administrator access for this setup step.\n' >&2
      exit 1
    fi
  }

  install_mode=--daemon
  if [[ $platform = Linux && ! -d /run/systemd/system ]]; then
    install_mode=--no-daemon
    printf 'No running systemd detected; using single-user Nix.\n'
  fi
  if [[ $install_mode = --daemon ]]; then
    # Match the upstream installer's guard: permissive SELinux is not enforcing.
    if [[ $platform = Linux ]] && {
      { [[ -r /sys/fs/selinux/enforce ]] && [[ $(</sys/fs/selinux/enforce) = 1 ]]; } ||
        { command -v getenforce >/dev/null 2>&1 && [[ $(getenforce) = Enforcing ]]; }
    }; then
      printf 'The upstream Nix daemon installer does not support enforcing SELinux.\n' >&2
      printf 'Use a supported manual Nix installation, then rerun init.sh.\n' >&2
      exit 1
    fi
    require_sudo
  fi

  if [[ $platform = Linux ]]; then
    missing=()
    for tool in curl tar xz; do
      if ! command -v "$tool" >/dev/null 2>&1; then
        missing+=("$tool")
      fi
    done
    if [[ ${#missing[@]} -gt 0 ]]; then
      require_sudo
      printf 'Installing missing installer prerequisites: %s\n' "${missing[*]}"
      if command -v apt-get >/dev/null 2>&1; then
        packages=()
        for tool in "${missing[@]}"; do
          if [[ $tool = xz ]]; then
            packages+=(xz-utils)
          else
            packages+=("$tool")
          fi
        done
        sudo apt-get update
        sudo apt-get install -y "${packages[@]}"
      elif command -v pacman >/dev/null 2>&1; then
        sudo pacman -S --needed "${missing[@]}"
      elif command -v dnf >/dev/null 2>&1; then
        sudo dnf install "${missing[@]}"
      else
        printf 'Install these prerequisites with your distro package manager: %s\n' "${missing[*]}" >&2
        exit 1
      fi
    fi
  elif ! command -v curl >/dev/null 2>&1 || ! command -v tar >/dev/null 2>&1; then
    printf 'The macOS Nix installer requires curl and tar on PATH.\n' >&2
    exit 1
  fi

  printf 'Downloading the upstream Nix installer: https://nixos.org/nix/install\n'
  printf 'Installation mode: %s (the installer can request administrator access).\n' "$install_mode"
  installer=$(mktemp "${TMPDIR:-/tmp}/dotfiles-nix-install.XXXXXX")
  trap 'rm -f -- "$installer"' EXIT
  curl --proto '=https' --tlsv1.2 -fsSL https://nixos.org/nix/install -o "$installer"
  sh "$installer" "$install_mode"
  load_nix_environment
fi

if ! command -v nix >/dev/null 2>&1; then
  printf 'Nix is not on PATH after setup. Restart your terminal and rerun init.sh.\n' >&2
  exit 1
fi

printf 'Nix ready: '
nix --extra-experimental-features 'nix-command flakes' eval --raw --expr builtins.nixVersion
printf '\nSetup complete. No dotfiles were activated.\n'
printf 'Review your host username, home directory, and checkoutPath; then run:\n  %q\n' "$repo_root/switch.sh"
