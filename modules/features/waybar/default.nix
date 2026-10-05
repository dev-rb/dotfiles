{ mkFeature, mkConfigFiles, ... }:
mkFeature {
  name = "waybar";
  homeManager = { pkgs, ... }: {
    imports = [ (mkConfigFiles { waybar = ./config; }) ];
    programs.waybar.enable = true;
    home.packages = with pkgs; [
      pavucontrol
      pulseaudio
      playerctl
      swaynotificationcenter
      wttrbar
      bluez
      bash
    ];
  };
}
