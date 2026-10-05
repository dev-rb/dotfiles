{
  inputs,
  self,
  lib,
  ...
}:
let
  mkHostChecks =
    pkgs: configs:
    assert import ../tests/hosts.nix { inherit self; };
    pkgs.runCommand "host-settings" { nativeBuildInputs = [ pkgs.zsh ]; } ''
      ${lib.concatMapStringsSep "\n" (
        config: "zsh -n ${lib.escapeShellArg (toString config.home.file."./.zshrc".source)}"
      ) configs}
      touch "$out"
    '';
in
{
  # Keep configurations opaque and lazy when several hosts define outputs.
  options.flake = lib.genAttrs [ "homeConfigurations" "darwinConfigurations" ] (
    _:
    lib.mkOption {
      type = lib.types.lazyAttrsOf lib.types.raw;
      default = { };
    }
  );
  config.flake = {
    overlays.hyprlock-pam = import ../overlays/hyprlock-pam.nix;

    # Compatibility selectors remain aliases, not additional host declarations.
    homeConfigurations = {
      arch = self.homeConfigurations.arch-desktop;
      wsl = self.homeConfigurations.wsl-dev;
    };
    darwinConfigurations.macos = self.darwinConfigurations.macbook-pro;
  };

  config.perSystem = { pkgs, system, ... }: {
    packages = {
      home-manager = inputs.home-manager.packages.${system}.home-manager;
      default = self.packages.${system}.home-manager;
    };
    formatter = pkgs.nixfmt;
    checks = {
      helpers =
        assert import ../tests/helpers.nix { inherit inputs; };
        pkgs.runCommand "helper-settings" { } "touch $out";
    }
    // lib.optionalAttrs (system == "x86_64-linux") {
      arch-desktop = self.homeConfigurations.arch-desktop.activationPackage;
      wsl-dev = self.homeConfigurations.wsl-dev.activationPackage;
      host-settings = mkHostChecks pkgs [
        self.homeConfigurations.arch-desktop.config
        self.homeConfigurations.wsl-dev.config
      ];
    }
    // lib.optionalAttrs (system == "aarch64-darwin") {
      macbook-pro = self.darwinConfigurations.macbook-pro.system;
      host-settings = mkHostChecks pkgs [
        self.darwinConfigurations.macbook-pro.config.home-manager.users.devrb
      ];
    };
  };
}
