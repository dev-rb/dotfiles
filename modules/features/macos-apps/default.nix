{ mkFeature, ... }:
mkFeature {
  name = "macos-apps";
  homeManager = { pkgs, ... }: {
    home.packages = [ pkgs.brave ];
  };
  darwin = { lib, ... }: {
    # Homebrew itself remains an explicit prerequisite; init.sh only sets up Nix.
    homebrew = {
      enable = lib.mkDefault true;

      # Preserve the versioned macOS toolchains and current GnuPG installation.
      # Signing configuration, key material, and agent settings stay unmanaged.
      brews = [
        "gnupg"
        "pinentry"
        "llvm@20"
        "lld@20"
        "llvm@21"
        "lld@21"
      ];

      casks = [
        "alt-tab"
        "chatgpt"
        "cursor"
        "orbstack"
        "raycast"
        "tailscale-app"
      ];

      # Install missing declarations without upgrading or removing existing apps.
      # Hosts can opt into stricter cleanup or upgrades after migration.
      onActivation = {
        autoUpdate = lib.mkDefault false;
        upgrade = lib.mkDefault false;
        cleanup = lib.mkDefault "none";
      };
    };
  };
}
