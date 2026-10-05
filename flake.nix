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
      mkHostChecks =
        system: configs:
        assert import ./tests/hosts.nix { inherit self; };
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        pkgs.runCommand "host-settings" { nativeBuildInputs = [ pkgs.zsh ]; } ''
          ${nixpkgs.lib.concatMapStringsSep "\n" (
            config: "zsh -n ${nixpkgs.lib.escapeShellArg (toString config.home.file."./.zshrc".source)}"
          ) configs}
          touch "$out"
        '';
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
          host-settings = mkHostChecks "x86_64-linux" [
            homes.arch-desktop.config
            homes.wsl-dev.config
          ];
        };
        aarch64-darwin = {
          macbook-pro = darwinHosts.macbook-pro.system;
          host-settings = mkHostChecks "aarch64-darwin" [
            darwinHosts.macbook-pro.config.home-manager.users.devrb
          ];
        };
      };
    };
}
