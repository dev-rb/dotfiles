# My Dotfiles

Nix configurations for Linux, WSL, and macOS, organized by host and feature.

## Hosts

| Host | Platform | Configuration |
| --- | --- | --- |
| `arch-desktop` | Arch Linux | Home Manager + Niri |
| `wsl-dev` | WSL | Home Manager |
| `macbook-pro` | Apple Silicon macOS | nix-darwin + Home Manager |

## Usage

```sh
./init.sh                  # install prerequisites; no activation
./switch.sh                # select a compatible host and confirm activation
./switch.sh macbook-pro     # select a host directly; still confirms
./scripts/check-configs.sh  # validate; no activation
nix --extra-experimental-features 'nix-command flakes' develop  # development tools
```

Run setup and switching as your normal user. Before first activation, back up existing dotfiles and verify the host's username, home directory, and `checkoutPath`. Pass activation-tool arguments after `--`.

## Layout

- `hosts/`: machine settings and module selection.
- `modules/features/`: app modules and their configuration assets.
- `modules/profiles/`: shared feature groups.
- `lib/`: feature and host declaration helpers.

## Local settings

Neovim links to the live checkout for writable settings; generation rollbacks do not restore its contents. Other native configurations are store-backed.

Pi and Herdr seed writable settings only when absent. Existing settings remain untouched; later changes to managed defaults require manual adoption. Authentication, sessions, installed extensions, and runtime data remain local.
