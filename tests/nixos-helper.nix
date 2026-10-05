{ self }:
let
  inputs = self.inputs;
  lib = inputs.nixpkgs.lib;
  helpers = import ../lib { inherit inputs lib; };
  probe =
    (helpers.mkNixos {
      name = "constructor-test";
      system = "x86_64-linux";
      user = "test-user";
      stateVersions = {
        home = "26.05";
        system = "26.05";
      };
      modules = [
        {
          users.users.test-user.isNormalUser = true;
          services.openssh.enable = true;
        }
      ];
      homeModules = [
        self.modules.homeManager.base
        self.modules.homeManager.git
      ];
    }).flake.nixosConfigurations.constructor-test.config;
in
assert probe.services.openssh.enable;
assert probe.system.stateVersion == "26.05";
assert probe.home-manager.useGlobalPkgs;
assert probe.home-manager.users.test-user.home.username == "test-user";
assert probe.home-manager.users.test-user.home.homeDirectory == "/home/test-user";
assert probe.home-manager.users.test-user.home.stateVersion == "26.05";
assert probe.home-manager.users.test-user.programs.git.enable;
true
