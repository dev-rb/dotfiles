# My Dotfiles

One Nix flake for Linux, WSL, and macOS, with explicit host declarations and feature-local configuration.

```text
flake.nix / flake.lock       # dependencies, composition, CLI tooling
lib/                        # feature and host declaration functions
hosts/<machine>/            # ordinary module selection and machine facts
modules/features/<app>/     # top-level feature modules and native assets
modules/profiles/           # common, development, and desktop composition
overlays/                   # explicitly selected package patches
scripts/                    # repository validation tooling only
```

Feature files publish Home Manager, nix-darwin, or NixOS modules through flake-parts. Hosts select ordinary module references; there is no string-based feature selector or automatic discovery. `mkHome`, `mkDarwin`, and `mkNixos` construct and register named outputs, so host files do not repeat output assignments.

| Host | Platform | Configuration |
| --- | --- | --- |
| `arch-desktop` | x86_64 Arch Linux | Standalone Home Manager + Niri desktop |
| `wsl-dev` | x86_64 WSL | Standalone Home Manager |
| `macbook-pro` | Apple Silicon macOS | nix-darwin + Home Manager |

The macOS profile combines system fundamentals, shared macOS preferences, and the macOS user environment. `modules/features/macos-defaults/` captures explicit appearance, keyboard, scrolling, Dock, Finder, and trackpad preferences; unset preferences remain unmanaged. Hosts can override the shared defaults.

Native Neovim, Niri, Waybar, WezTerm, tmux, prompt, and desktop-script assets live beside their owning feature modules. Niri display facts live under `hosts/arch-desktop/`. Windows-specific WezTerm settings are isolated in `modules/features/wezterm/windows.lua`.

Neovim uses a live checkout link for immediate editing and writable NvChad settings. All other native configurations use store-backed deployment. Live Neovim changes are not restored by a Nix generation rollback. Older `.zsh/` assets remain legacy and are not activated.

## Commands

```sh
./init.sh                                     # install missing prerequisites; no activation
./switch.sh                                   # select a host and confirm activation
./switch.sh macbook-pro -- --show-trace         # select a host directly; still confirms
./scripts/check-configs.sh                     # validate; no activation
```

`init.sh` installs Nix only when missing, plus missing Linux installer prerequisites (`curl`, `tar`, `xz`). It uses multi-user Nix on macOS and systemd Linux, and single-user Nix otherwise. Enforcing SELinux needs a supported manual daemon installation. Setup does not install Homebrew or external toolchains, change your login shell, or activate dotfiles.

`switch.sh` selects from compatible flake configurations and uses pinned Home Manager or nix-darwin tools. Pass activation-tool arguments after `--`; only one host selector is accepted. Nix commands explicitly enable flakes; neither script patches your user Nix configuration.

Run both scripts as your normal user; administrator access is requested only where required. Back up existing dotfiles before first activation, and check each host's username, home directory, and `checkoutPath`.
