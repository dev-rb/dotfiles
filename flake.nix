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

    wezterm.url = "github:wezterm/wezterm?dir=nix";
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
          options.flake = lib.genAttrs [ "homeConfigurations" "darwinConfigurations" ] (
            _:
            lib.mkOption {
              type = lib.types.lazyAttrsOf lib.types.raw;
              default = { };
            }
          );

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
              };
              formatter = pkgs.nixfmt;
            };
          };
        }
      );
}
