{
  description = "Dotfiles for dev-rb's Linux, WSL, and macOS hosts";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
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
    {
      self,
      nixpkgs,
      home-manager,
      nix-darwin,
      ...
    }@inputs:
    let
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
      ];

      mkHome =
        {
          system,
          hostModule,
          overlays ? [ ],
        }:
        home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
            inherit system overlays;
            config.allowUnfree = true;
          };
          extraSpecialArgs = { inherit inputs; };
          modules = [
            ./modules/home
            hostModule
          ];
        };

      homes = {
        arch-desktop = mkHome {
          system = "x86_64-linux";
          hostModule = ./hosts/arch-desktop/home.nix;
          overlays = [
            self.overlays.hyprlock-pam
            inputs.nixgl.overlay
          ];
        };
        wsl-dev = mkHome {
          system = "x86_64-linux";
          hostModule = ./hosts/wsl-dev/home.nix;
        };
      };

      darwinHosts = {
        macbook-pro = nix-darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          specialArgs = { inherit inputs; };
          modules = [
            home-manager.darwinModules.home-manager
            ./modules/darwin
            ./hosts/macbook-pro
          ];
        };
      };
    in
    {
      overlays.hyprlock-pam = import ./overlays/hyprlock-pam.nix;

      homeConfigurations = homes // {
        # Preserve selectors while callers move to machine-named outputs.
        arch = homes.arch-desktop;
        wsl = homes.wsl-dev;
      };
      darwinConfigurations = darwinHosts // {
        macos = darwinHosts.macbook-pro;
      };

      packages = nixpkgs.lib.genAttrs systems (system: {
        home-manager = home-manager.packages.${system}.home-manager;
        default = self.packages.${system}.home-manager;
      });
      formatter = nixpkgs.lib.genAttrs systems (system: nixpkgs.legacyPackages.${system}.nixfmt);

      checks = {
        x86_64-linux = {
          arch-desktop = homes.arch-desktop.activationPackage;
          wsl-dev = homes.wsl-dev.activationPackage;
        };
        aarch64-darwin.macbook-pro = darwinHosts.macbook-pro.system;
      };
    };
}
