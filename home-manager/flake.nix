{
  description = "Home Manager configuration of dev-rb";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nixgl = {
      url = "github:nix-community/nixGL";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
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

    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

  };

  # nix = { settings.experimental-features = [ "nix-command" "flakes" ]; };

  outputs =
    {
      self,
      nixpkgs,
      niri,
      nixgl,
      nix-darwin,
      home-manager,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      inherit (self) outputs;
      pkgs = import nixpkgs {
        inherit system;
        overlays = [
          (import ./overlays.nix)
          nixgl.overlay
        ];
        config.allowUnfree = true;
      };

      HomeConfiguration =
        args:
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [ ./home/home.nix ] ++ args.modules or [ ];
          extraSpecialArgs = {
            inherit (args) nixpkgs;
            inherit nixgl;
          }
          // args.extraSpecialArgs;
        };
    in
    {

      nix.extraOptions = ''
        auto-optimise-store = true
        experimental-features = nix-command flakes
      '';

      homeConfigurations = {
        "arch" = HomeConfiguration {
          extraSpecialArgs = {
            vars = {
              name = "arch";
              username = "devrb";
            };
            inherit inputs outputs;
          };
          services.pipewire.enable = true;
          services.pipewire.audio.enable = true;
          services.pipewire.pulse.enable = true;
          services.pipewire.alsa.enable = true;
          services.pipewire.wireplumber.enable = true;
          modules = [
            {
              targets.genericLinux.nixGL.packages = nixgl.packages;
              targets.genericLinux.nixGL.defaultWrapper = "mesa";
              targets.genericLinux.nixGL.installScripts = [ "mesa" ];
              nixpkgs = {
                config = {
                  allowUnfree = true;
                  allowUnfreePredicate = (pkg: true);
                };
              };
            }
            niri.homeModules.niri
            ./arch/hyprland.nix
            ./arch/hypridle.nix
            ./arch/hyprlock.nix
            ./arch/niri.nix
            ./arch/waybar.nix
            ./arch/scripts.nix
          ];
        };

        "wsl" = HomeConfiguration {
          extraSpecialArgs = {
            vars = {
              name = "wsl";
              username = "dev-rb";
            };
          };
          modules = [ ];
        };
      };

      darwinConfigurations."macos" = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        pkgs = import nixpkgs { system = "aarch64-darwin"; };
        modules = [
          {
            system.stateVersion = 6;
          }
          home-manager.darwinModules.home-manager
          {
            users.users.devrb.home = "/Users/devrb";
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = {
                vars = {
                  name = "macos";
                  username = "devrb";
                };
              };
              backupFileExtension = "backup";

              users.devrb.imports = [ ./home/home.nix ];
            };
          }
        ]

        ;
      };

      inherit home-manager;
      inherit (home-manager) packages;
    };
}
