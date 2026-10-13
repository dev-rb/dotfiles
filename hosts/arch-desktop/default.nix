{
  mkHome,
  config,
  inputs,
  lib,
  ...
}:
let
  m = config.flake.modules;
in
mkHome {
  name = "arch-desktop";
  system = "x86_64-linux";
  user = "devrb";
  checkoutPath = "/home/devrb/dotfiles";
  stateVersions.home = "26.05";

  modules = [
    m.homeManager.common
    m.homeManager.development
    m.homeManager.linux
    m.homeManager.niri-desktop
    {
      xdg.configFile."niri/config.kdl".text = lib.mkAfter (builtins.readFile ./niri.kdl);
      # Preserve inactive Hyprland hardware assumptions under this host only.
      wayland.windowManager.hyprland.settings = {
        monitor = ",1920x1200,auto,1,bitdepth,8";
        env = [
          "LIBVA_DRIVER_NAME,nvidia"
          "__GLX_VENDOR_LIBRARY_NAME,nvidia"
          "AQ_DRM_DEVICES,/dev/dri/card0:/dev/dri/card1"
        ];
      };
    }
  ];

  overlays = [
    (import ../../overlays/hyprlock-pam.nix)
    inputs.nixgl.overlay
  ];
}
