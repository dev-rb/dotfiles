{ inputs }:
let
  lib = inputs.nixpkgs.lib;
  # Inspect constructor arguments without evaluating a complete OS configuration.
  stubInputs = inputs // {
    home-manager = {
      lib.homeManagerConfiguration = args: args;
      darwinModules.home-manager = { };
      nixosModules.home-manager = { };
    };
    nix-darwin.lib.darwinSystem = args: args;
    nixpkgs = inputs.nixpkgs // {
      lib = lib // {
        nixosSystem = args: args;
      };
    };
  };
  helpers = import ../lib {
    inputs = stubInputs;
    inherit lib;
  };
  homeArgs = {
    name = "test-home";
    system = "x86_64-linux";
    user = "test-user";
    stateVersions.home = "26.05";
    modules = [ { programs.git.enable = true; } ];
    extraSpecialArgs.marker = "home-argument";
  };
  home = (helpers.mkHome homeArgs).flake.homeConfigurations.test-home;
  systemArgs = {
    name = "test-system";
    system = "aarch64-darwin";
    user = "test-user";
    stateVersions = {
      home = "26.05";
      system = 6;
    };
    modules = [ { programs.zsh.enable = true; } ];
    homeModules = [ { programs.git.enable = true; } ];
    specialArgs.marker = "system-argument";
    extraSpecialArgs.marker = "home-argument";
  };
  darwin = (helpers.mkDarwin systemArgs).flake.darwinConfigurations.test-system;
  nixos =
    (helpers.mkNixos (
      systemArgs
      // {
        system = "x86_64-linux";
        stateVersions = {
          home = "26.05";
          system = "26.05";
        };
      }
    )).flake.nixosConfigurations.test-system;
  darwinIdentity = builtins.elemAt darwin.modules 2;
  nixosIdentity = builtins.elemAt nixos.modules 2;
  darwinHome = (builtins.elemAt darwin.modules 3).home-manager;
  nixosHome = (builtins.elemAt nixos.modules 3).home-manager;
  feature = helpers.mkFeature {
    name = "test-feature";
    homeManager = {
      programs.git.enable = true;
    };
    darwin = {
      programs.zsh.enable = true;
    };
    nixos = {
      services.openssh.enable = true;
    };
  };
  failures = lib.runTests {
    testFeatureClasses = {
      expr = builtins.attrNames feature.flake.modules;
      expected = [
        "darwin"
        "homeManager"
        "nixos"
      ];
    };
    testFeatureModuleValues = {
      expr = [
        feature.flake.modules.homeManager.test-feature.programs.git.enable
        feature.flake.modules.darwin.test-feature.programs.zsh.enable
        feature.flake.modules.nixos.test-feature.services.openssh.enable
      ];
      expected = [
        true
        true
        true
      ];
    };
    testUnusedClassesAreAbsent = {
      expr =
        builtins.attrNames
          (helpers.mkFeature {
            name = "home-only";
            homeManager = { };
          }).flake.modules;
      expected = [ "homeManager" ];
    };
    testNativeConfigSources = {
      expr = (helpers.mkConfigFiles { "test/config" = ./helpers.nix; }).xdg.configFile."test/config";
      expected = {
        source = ./helpers.nix;
      };
    };
    testStandaloneIdentity = {
      expr = (builtins.elemAt home.modules 1).home;
      expected = {
        username = "test-user";
        homeDirectory = "/home/test-user";
        stateVersion = "26.05";
      };
    };
    testStandaloneArguments = {
      expr = { inherit (home.extraSpecialArgs) checkoutPath marker; };
      expected = {
        checkoutPath = "/home/test-user/dotfiles";
        marker = "home-argument";
      };
    };
    testDarwinIdentity = {
      expr = {
        inherit (darwinIdentity.system) primaryUser stateVersion;
        home = darwinIdentity.users.users.test-user.home;
      };
      expected = {
        primaryUser = "test-user";
        stateVersion = 6;
        home = "/Users/test-user";
      };
    };
    testIntegratedHome = {
      expr = {
        inherit (darwinHome) useGlobalPkgs useUserPackages backupFileExtension;
        home = (builtins.elemAt darwinHome.users.test-user.imports 1).home;
      };
      expected = {
        useGlobalPkgs = true;
        useUserPackages = true;
        backupFileExtension = "backup";
        home = {
          username = "test-user";
          homeDirectory = "/Users/test-user";
          stateVersion = "26.05";
        };
      };
    };
    testIntegratedArguments = {
      expr = [
        darwin.specialArgs.marker
        darwinHome.extraSpecialArgs.marker
        darwinHome.extraSpecialArgs.checkoutPath
      ];
      expected = [
        "system-argument"
        "home-argument"
        "/Users/test-user/dotfiles"
      ];
    };
    testNixosIdentityAndIntegration = {
      expr = [
        nixosIdentity.system.stateVersion
        nixosIdentity.users.users.test-user.home
        nixosHome.extraSpecialArgs.checkoutPath
      ];
      expected = [
        "26.05"
        "/home/test-user"
        "/home/test-user/dotfiles"
      ];
    };
    testHomePathOverrides = {
      expr =
        (helpers.mkHome (
          homeArgs
          // {
            homeDirectory = "/srv/test-user";
            checkoutPath = "/work/config";
          }
        )).flake.homeConfigurations.test-home.extraSpecialArgs.checkoutPath;
      expected = "/work/config";
    };
    testModuleReferencesStayExplicit = {
      expr = [
        (builtins.head home.modules).programs.git.enable
        (builtins.head darwin.modules).programs.zsh.enable
        (builtins.head darwinHome.users.test-user.imports).programs.git.enable
      ];
      expected = [
        true
        true
        true
      ];
    };
  };
in
if failures == [ ] then
  true
else
  throw "Helper regression checks failed: ${builtins.toJSON failures}"
