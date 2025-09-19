{
  description = "Home Manager configuration of dev-rb";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

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

    niri.url = "github:sodiboo/niri-flake";

  };

  # nix = { settings.experimental-features = [ "nix-command" "flakes" ]; };

  outputs = { self, nixpkgs, niri, home-manager, ... }@inputs:
    let
      system = "x86_64-linux";
      inherit (self) outputs;
      pkgs = import nixpkgs { inherit system; };

      HomeConfiguration = args:
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [ ./home/home.nix ] ++ args.modules or [ ];
          extraSpecialArgs = {
            inherit (args) nixpkgs;
          } // args.extraSpecialArgs;
        };
    in {

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
            niri.homeModules.niri
            ./arch/hyprland.nix
            ./arch/hypridle.nix
            ./arch/hyprlock.nix
            ./arch/niri.nix
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

      inherit home-manager;
      inherit (home-manager) packages;
    };
}
