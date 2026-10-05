{ inputs }:
let
  homeIdentity = user: homeDirectory: stateVersion: {
    home = {
      username = user;
      inherit homeDirectory stateVersion;
    };
  };

  integratedHome =
    {
      user,
      homeDirectory,
      stateVersion,
      checkoutPath,
      homeModules,
      extraSpecialArgs,
    }:
    {
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        backupFileExtension = "backup";
        extraSpecialArgs = {
          inherit inputs checkoutPath;
        }
        // extraSpecialArgs;
        users.${user} = {
          imports = homeModules ++ [ (homeIdentity user homeDirectory stateVersion) ];
        };
      };
    };
in
{
  # Each constructor returns a flake-parts module with a named output.
  mkHome =
    {
      name,
      system,
      user,
      stateVersions,
      homeDirectory ? "/home/${user}",
      checkoutPath ? "${homeDirectory}/dotfiles",
      modules ? [ ],
      overlays ? [ ],
      extraSpecialArgs ? { },
    }:
    {
      flake.homeConfigurations.${name} = inputs.home-manager.lib.homeManagerConfiguration {
        pkgs = import inputs.nixpkgs {
          inherit system overlays;
          config.allowUnfree = true;
        };
        extraSpecialArgs = {
          inherit inputs checkoutPath;
        }
        // extraSpecialArgs;
        modules = modules ++ [ (homeIdentity user homeDirectory stateVersions.home) ];
      };
    };

  mkDarwin =
    {
      name,
      system,
      user,
      stateVersions,
      homeDirectory ? "/Users/${user}",
      checkoutPath ? "${homeDirectory}/dotfiles",
      modules ? [ ],
      homeModules ? [ ],
      overlays ? [ ],
      specialArgs ? { },
      extraSpecialArgs ? { },
    }:
    {
      flake.darwinConfigurations.${name} = inputs.nix-darwin.lib.darwinSystem {
        inherit system;
        specialArgs = {
          inherit inputs;
        }
        // specialArgs;
        modules = modules ++ [
          inputs.home-manager.darwinModules.home-manager
          {
            nixpkgs = {
              inherit overlays;
              config.allowUnfree = true;
            };
            system.stateVersion = stateVersions.system;
            system.primaryUser = user;
            users.users.${user}.home = homeDirectory;
          }
          (integratedHome {
            inherit
              user
              homeDirectory
              checkoutPath
              homeModules
              extraSpecialArgs
              ;
            stateVersion = stateVersions.home;
          })
        ];
      };
    };

  # Available for future NixOS hosts; hardware and account creation stay explicit.
  mkNixos =
    {
      name,
      system,
      user,
      stateVersions,
      homeDirectory ? "/home/${user}",
      checkoutPath ? "${homeDirectory}/dotfiles",
      modules ? [ ],
      homeModules ? [ ],
      overlays ? [ ],
      specialArgs ? { },
      extraSpecialArgs ? { },
    }:
    {
      flake.nixosConfigurations.${name} = inputs.nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit inputs;
        }
        // specialArgs;
        modules = modules ++ [
          inputs.home-manager.nixosModules.home-manager
          {
            nixpkgs = {
              inherit overlays;
              config.allowUnfree = true;
            };
            system.stateVersion = stateVersions.system;
            users.users.${user}.home = homeDirectory;
          }
          (integratedHome {
            inherit
              user
              homeDirectory
              checkoutPath
              homeModules
              extraSpecialArgs
              ;
            stateVersion = stateVersions.home;
          })
        ];
      };
    };
}
