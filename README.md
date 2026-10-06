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

Neovim, Niri, Waybar, tmux, prompt, and desktop-script assets live beside their owning feature modules. Niri display facts live under `hosts/arch-desktop/`. WezTerm static settings live in `modules/features/wezterm/settings.nix`, and callbacks and navigation live in `behavior.lua`.

WezTerm uses `~/.config/wezterm/wezterm.lua`, where its native directory watcher detects Home Manager symlink replacements. When migrating from the old managed `~/.wezterm.lua` location, activate the new generation and restart WezTerm once.

Hosts can override `programs.wezterm.settings` in their Home Manager modules, including fonts, opacity, and `background` layers. Repository wallpaper paths such as `source.File = "${./wallpaper.jpg}"` become store-backed; absolute path strings refer to images outside the repository. Linux uses Home Manager's config writer and package; macOS generates the same configuration while retaining its existing app installation. `extraConfig` runs after settings and can override them.

Neovim uses a live checkout link for immediate editing and writable NvChad settings. Its live changes are not restored by a Nix generation rollback. Pi keeps writable local settings initialized from managed defaults; other native configurations use store-backed deployment. Older `.zsh/` assets remain legacy and are not activated.

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

## Development

The default development shell provides pinned Bash, Git, ShellCheck, nixfmt, Lua, and StyLua from `flake.lock`. It requires an existing Nix installation and does not activate hosts or replace system packages.

```sh
# Enter the shell, then run checks or edit configurations.
nix --extra-experimental-features 'nix-command flakes' develop

# Alternatively, run validation without opening an interactive shell.
nix --extra-experimental-features 'nix-command flakes' develop \
  --command ./scripts/check-configs.sh
```

## Pi coding agent

The development profile includes Pi from its official flake, pinned to `v1.0.3`. The `pi` package output also supports `nix run .#pi`. Pi's wrapper supplies its own Node runtime without changing fnm's ownership of your other Node versions.

`modules/features/pi/settings.nix` supplies non-secret startup defaults. Activation creates writable `~/.pi/agent/settings.json` only if it does not already exist; existing settings and package declarations are never overwritten or merged. The generated baseline is available at `~/.pi/agent/settings.defaults.json`. Later changes to the baseline must be adopted manually through Pi or your editor.

The feature also deploys three standalone skills and the current theme palette as `dotfiles-workbench-dark`, avoiding a name collision with the existing extension package's theme. Authentication, sessions, installed extensions, caches, and machine-local package sources remain outside the repository. No terminal integration hooks are added.

The existing npm installation is not removed automatically. After activation, check `type -a pi`; an fnm-managed global install can take precedence over the Nix package. Verify the Nix CLI before deciding whether to remove the old npm install. Update the release tag and Pi lock entry to upgrade the Nix-managed CLI; `pi update` cannot upgrade it.
