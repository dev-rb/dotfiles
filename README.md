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

Native Neovim, Niri, Waybar, WezTerm, tmux, prompt, and desktop-script assets live beside their owning feature modules. Niri display facts live under `hosts/arch-desktop/`. Windows-specific WezTerm settings are isolated in `modules/features/wezterm/windows.lua`.

Neovim uses a live checkout link for immediate editing and writable NvChad settings. All other native configurations use store-backed deployment. Live Neovim changes are not restored by a Nix generation rollback. Older `.zsh/` assets remain legacy and are not activated.

## Commands

```sh
./scripts/check-configs.sh                     # validate; no activation
./init.sh home arch-desktop                    # explicitly activate Arch
./init.sh home wsl-dev                         # explicitly activate WSL
./init.sh darwin macbook-pro                   # explicitly activate macOS
```

Install Nix first; the macOS wrapper also requires `darwin-rebuild`.

Back up existing dotfiles before first activation. Neovim uses the checkout path configured in each host.
