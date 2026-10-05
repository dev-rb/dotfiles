{ inputs, ... }:
{
  imports = [
    inputs.niri.homeModules.niri
    ./hyprland.nix
    ./hypridle.nix
    ./hyprlock.nix
    ./niri.nix
    ./waybar.nix
    ./scripts.nix
  ];

  targets.genericLinux.nixGL = {
    packages = inputs.nixgl.packages;
    defaultWrapper = "mesa";
    installScripts = [ "mesa" ];
  };
}
