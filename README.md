# My Dotfiles

One Nix flake for Linux, WSL, and macOS, with shared Home Manager configuration.

```text
flake.nix / flake.lock   # outputs and pinned dependencies
hosts/                  # machine identity and module selection
modules/home/           # shared programs, packages, and fonts
  platforms/            # Linux, WSL, and macOS user settings
  desktop/              # opt-in Linux graphical session
modules/darwin/         # macOS system settings
overlays/               # host-specific package patches
```

| Host | Platform | Configuration |
| --- | --- | --- |
| `arch-desktop` | x86_64 Arch Linux | Standalone Home Manager + desktop |
| `wsl-dev` | x86_64 WSL | Standalone Home Manager |
| `macbook-pro` | Apple Silicon macOS | nix-darwin + Home Manager |

Native configs such as `nvim/`, `niri/`, and `waybar/` remain in their existing directories and are linked by modules. Older root dotfiles and `.zsh/` are legacy, not automatically activated.

## Commands

```sh
./scripts/check-configs.sh                     # validate; no activation
./init.sh home arch-desktop                    # explicitly activate Arch
./init.sh home wsl-dev                         # explicitly activate WSL
./init.sh darwin macbook-pro             # explicitly activate macOS
```

Install Nix first; the macOS wrapper also requires `darwin-rebuild`.

- [Setup, migration, and adding a host](docs/usage.md)
- [Architecture decision](docs/decisions/2026-10-05-hosts-and-modules.md)
