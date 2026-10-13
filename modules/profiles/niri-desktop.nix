{ mkFeature, config, ... }:
mkFeature {
  name = "niri-desktop";
  homeManager.imports = with config.flake.modules.homeManager; [
    nixgl
    niri
    hypridle
    hyprlock
    waybar
    desktop-scripts
  ];
}
