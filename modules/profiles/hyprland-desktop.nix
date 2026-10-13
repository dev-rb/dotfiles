{ mkFeature, config, ... }:
mkFeature {
  name = "hyprland-desktop";
  homeManager.imports = with config.flake.modules.homeManager; [
    nixgl
    hyprland
    hypridle
    hyprlock
    waybar
    desktop-scripts
  ];
}
