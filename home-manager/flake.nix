{
  description = "Home Manager configuration of dev-rb";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    none-ls-extras = {
      url = "github:nvimtools/none-ls-extras.nvim";
      flake = false;
    };
    vesper-nvim = {
      url = "github:datsfilipe/vesper.nvim";
      flake = false;
    };

    night-nvim = {
      url = "github:NightCS/night.nvim";
      flake = false;
    };
    everblush-nvim = {
      url = "github:Everblush/nvim";
      flake = false;
    };
    horizon-nvim = {
      url = "github:LunarVim/horizon.nvim";
      flake = false;
    };
    nvim-noirbuddy = {
      url = "github:jesseleite/nvim-noirbuddy";
      flake = false;
    };
    tokyodark-nvim = {
      url = "github:tiagovla/tokyodark.nvim";
      flake = false;
    };
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      nixvim,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        overlays = [ (import ./overlays.nix inputs) ];
      };
    in
    {

      nix.extraOptions = ''
        auto-optimise-store = true
        experimental-features = nix-command flakes
      '';

      homeConfigurations."dev-rb" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        # Specify your home configuration modules here, for example,
        # the path to your home.nix.
        modules = [
          nixvim.homeManagerModules.nixvim
          ./home/home.nix
        ];

        # Optionally use extraSpecialArgs
        # to pass through arguments to home.nix
      };
    };
}
