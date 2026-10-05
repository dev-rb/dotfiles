{ self }:
let
  lib = self.inputs.nixpkgs.lib;
  arch = self.homeConfigurations.arch-desktop.config;
  wsl = self.homeConfigurations.wsl-dev.config;
  darwin = self.darwinConfigurations.macbook-pro.config;
  mac = darwin.home-manager.users.devrb;

  failures = lib.runTests {
    testHomeDirectories = {
      expr = map (config: config.home.homeDirectory) [
        arch
        wsl
        mac
      ];
      expected = [
        "/home/devrb"
        "/home/dev-rb"
        "/Users/devrb"
      ];
    };
    testUsernames = {
      expr = map (config: config.home.username) [
        arch
        wsl
        mac
      ];
      expected = [
        "devrb"
        "dev-rb"
        "devrb"
      ];
    };
    testHomeStateVersions = {
      expr = map (config: config.home.stateVersion) [
        arch
        wsl
        mac
      ];
      expected = [
        "26.05"
        "26.05"
        "26.05"
      ];
    };
    testDarwinStateVersion = {
      expr = darwin.system.stateVersion;
      expected = 6;
    };
    testDarwinIntegration = {
      expr = {
        inherit (darwin.home-manager) useGlobalPkgs useUserPackages backupFileExtension;
        primaryUser = darwin.system.primaryUser;
        homeDirectory = darwin.users.users.devrb.home;
      };
      expected = {
        useGlobalPkgs = true;
        useUserPackages = true;
        backupFileExtension = "backup";
        primaryUser = "devrb";
        homeDirectory = "/Users/devrb";
      };
    };
    testLinuxIsolation = {
      expr = map (config: config.targets.genericLinux.enable) [
        arch
        wsl
        mac
      ];
      expected = [
        true
        true
        false
      ];
    };
    testDesktopIsolation = {
      expr = map (config: config.programs.niri.enable or false) [
        arch
        wsl
        mac
      ];
      expected = [
        true
        false
        false
      ];
    };
    testExistingDesktopSettings = {
      expr = {
        niri = arch.programs.niri.enable;
        hyprland = arch.wayland.windowManager.hyprland.enable;
        hyprlock = arch.programs.hyprlock.enable;
        hypridle = arch.services.hypridle.enable;
        waybar = arch.programs.waybar.enable;
      };
      expected = {
        niri = true;
        hyprland = false;
        hyprlock = true;
        hypridle = true;
        waybar = true;
      };
    };
    testManagedPrompt = {
      expr = map (config: toString config.programs.oh-my-posh.configFile) [
        arch
        wsl
        mac
      ];
      expected = lib.replicate 3 "${self.outPath}/pure.omp.json";
    };
    testManagedAssets = {
      expr = {
        niri = toString arch.home.file.".config/niri/".source;
        waybar = toString arch.home.file.".config/waybar/".source;
        scripts = toString arch.home.file.".config/scripts/".source;
        neovim = toString mac.home.file.".config/nvim".source;
      };
      expected = {
        niri = "${self.outPath}/niri";
        waybar = "${self.outPath}/waybar";
        scripts = "${self.outPath}/scripts";
        neovim = "${self.outPath}/nvim";
      };
    };
    testLegacySelectors = {
      expr = [
        (
          self.homeConfigurations.arch.activationPackage.drvPath
          == self.homeConfigurations.arch-desktop.activationPackage.drvPath
        )
        (
          self.homeConfigurations.wsl.activationPackage.drvPath
          == self.homeConfigurations.wsl-dev.activationPackage.drvPath
        )
        (
          self.darwinConfigurations.macos.system.drvPath
          == self.darwinConfigurations.macbook-pro.system.drvPath
        )
      ];
      expected = [
        true
        true
        true
      ];
    };
  };
in
if failures == [ ] then true else throw "Host regression checks failed: ${builtins.toJSON failures}"
