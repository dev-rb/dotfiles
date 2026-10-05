{ mkHome, inputs, ... }:
mkHome {
  name = "arch-desktop";
  system = "x86_64-linux";
  user = "devrb";
  stateVersions.home = "26.05";

  modules = [
    ../../modules/home
    ./home.nix
  ];

  overlays = [
    (import ../../overlays/hyprlock-pam.nix)
    inputs.nixgl.overlay
  ];
}
