{
  description = "Dotfiles for dev-rb's Linux, WSL, and macOS hosts";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixgl = {
      url = "github:nix-community/nixGL";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland = {
      type = "git";
      url = "https://github.com/hyprwm/hyprland";
      submodules = true;
      inputs.nixpkgs.follows = "nixpkgs";
    };

    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprlock = {
      url = "github:hyprwm/hyprlock";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    pi = {
      url = "github:earendil-works/pi/v1.0.3";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Keep the release's Rust/Ghostty build dependencies pinned upstream.
    herdr.url = "github:herdrdev/herdr/v0.9.1";
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake
      {
        inherit inputs;
        specialArgs = import ./lib {
          inherit inputs;
          lib = inputs.nixpkgs.lib;
        };
      }
      (
        { lib, self, ... }: {
          imports = [
            inputs.flake-parts.flakeModules.modules
            ./modules
            ./hosts
          ];

          # Keep host configurations opaque and lazy when their outputs are merged.
          options.flake =
            lib.genAttrs [ "homeConfigurations" "darwinConfigurations" ] (
              _:
              lib.mkOption {
                type = lib.types.lazyAttrsOf lib.types.raw;
                default = { };
              }
            )
            // {
              # Constructors publish plain records for fast, dependency-light menus.
              hostMetadata = lib.mkOption {
                type = lib.types.listOf lib.types.raw;
                default = [ ];
              };
            };

          config = {
            systems = [
              "x86_64-linux"
              "aarch64-linux"
              "aarch64-darwin"
            ];

            perSystem = { pkgs, system, ... }: {
              packages = {
                home-manager = inputs.home-manager.packages.${system}.home-manager;
                default = self.packages.${system}.home-manager;
                pi = inputs.pi.packages.${system}.default;
                herdr = inputs.herdr.packages.${system}.default;
              }
              // lib.optionalAttrs pkgs.stdenv.isDarwin {
                darwin-rebuild = inputs.nix-darwin.packages.${system}.darwin-rebuild;
              };
              formatter = pkgs.nixfmt;

              # Repository tooling only; entering the shell does not activate a host.
              devShells.default = pkgs.mkShellNoCC {
                packages = with pkgs; [
                  # Shell and repository checks.
                  bashInteractive
                  git
                  shellcheck

                  # Nix and Lua configuration tooling.
                  nixfmt
                  lua
                  stylua
                ];
              };
            };
          };
        }
      );
}
