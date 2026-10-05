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
      expected = lib.replicate 3 "${self.outPath}/modules/features/oh-my-posh/pure.omp.json";
    };
    testManagedAssets = {
      expr = {
        waybar = toString arch.xdg.configFile.waybar.source;
        scripts = toString arch.xdg.configFile.scripts.source;
        wezterm = toString mac.home.file.".wezterm.lua".source;
        windows = toString mac.xdg.configFile."wezterm/windows.lua".source;
        tmux = toString mac.home.file.".tmux.conf".source;
      };
      expected = {
        waybar = "${self.outPath}/modules/features/waybar/config";
        scripts = "${self.outPath}/modules/features/desktop-scripts/scripts";
        wezterm = "${self.outPath}/modules/features/wezterm/wezterm.lua";
        windows = "${self.outPath}/modules/features/wezterm/windows.lua";
        tmux = "${self.outPath}/modules/features/tmux/tmux.conf";
      };
    };
    testLiveNeovimPolicy = {
      expr =
        map
          (config: {
            inherit (config.home.file.".config/nvim") force recursive onChange;
          })
          [
            arch
            wsl
            mac
          ];
      expected = lib.replicate 3 {
        force = false;
        recursive = false;
        onChange = "";
      };
    };
    testNeovimDoesNotGenerateFilesInsideLiveTree = {
      expr =
        map
          (config: [
            config.programs.neovim.sideloadInitLua
            config.xdg.configFile."nvim/init.lua".enable
          ])
          [
            arch
            wsl
            mac
          ];
      expected = lib.replicate 3 [
        true
        false
      ];
    };
    testNeovimCheckoutValidation = {
      expr =
        map
          (
            config:
            lib.hasInfix "${config.home.homeDirectory}/dotfiles/modules/features/neovim/config/init.lua" config.home.activation.checkNeovimTarget.data
          )
          [
            arch
            wsl
            mac
          ];
      expected = [
        true
        true
        true
      ];
    };
    testNiriHostFragment = {
      expr = arch.xdg.configFile."niri/config.kdl".text;
      expected =
        builtins.readFile (self + "/modules/features/niri/config.kdl")
        + "\n"
        + builtins.readFile (self + "/hosts/arch-desktop/niri.kdl");
    };
    testHardwareIsNotShared = {
      expr =
        map (needle: lib.hasInfix needle (builtins.readFile (self + "/modules/features/niri/config.kdl")))
          [
            "DP-1"
            "DP-2"
            "2560x1440@164.956"
          ];
      expected = [
        false
        false
        false
      ];
    };
    testHyprlandHardwareIsNotShared = {
      expr =
        map
          (needle: lib.hasInfix needle (builtins.readFile (self + "/modules/features/hyprland/default.nix")))
          [
            "1920x1200"
            "nvidia"
            "/dev/dri/card"
          ];
      expected = [
        false
        false
        false
      ];
    };
    testNiriIdleCommands = {
      expr = [
        arch.services.hypridle.settings.general.after_sleep_cmd
        (builtins.elemAt arch.services.hypridle.settings.listener 1).on-timeout
      ];
      expected = [
        "niri msg action power-on-monitors"
        "niri msg action power-off-monitors"
      ];
    };
    testWindowsTerminalSettingsAreSeparated = {
      expr =
        let
          shared = builtins.readFile (self + "/modules/features/wezterm/wezterm.lua");
          windows = builtins.readFile (self + "/modules/features/wezterm/windows.lua");
        in
        [
          (lib.hasInfix "WSL:Ubuntu" shared)
          (lib.hasInfix "D:/Desktop" shared)
          (lib.hasInfix "WSL:Ubuntu" windows)
          (lib.hasInfix "windows" shared)
        ];
      expected = [
        false
        false
        true
        true
      ];
    };
    testWeztermPackageOwnership = {
      expr = map (config: config.programs.wezterm.enable) [
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
    testDesktopRuntimeDependencies = {
      expr =
        let
          names = map (package: package.pname or (lib.getName package)) arch.home.packages;
        in
        map (name: lib.elem name names) [
          "brillo"
          "dunst"
          "libnotify"
          "wireplumber"
          "awww"
          "pavucontrol"
          "pulseaudio"
          "playerctl"
          "vicinae"
          "tofi"
          "brave"
          "glib"
          "bash-interactive"
          "findutils"
        ];
      expected = lib.replicate 14 true;
    };
    testOnlyRuntimeScriptsAreDeployed = {
      expr = builtins.pathExists (self + "/modules/features/desktop-scripts/scripts/check-configs.sh");
      expected = false;
    };
    testTmuxDoesNotRequireUnmanagedTpm = {
      expr = lib.hasInfix "run '~/.tmux/plugins/tpm/tpm'" (
        builtins.readFile (self + "/modules/features/tmux/tmux.conf")
      );
      expected = false;
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
