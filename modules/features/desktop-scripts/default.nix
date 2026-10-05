{ mkFeature, mkConfigFiles, ... }:
mkFeature {
  name = "desktop-scripts";
  homeManager = { pkgs, ... }: {
    imports = [ (mkConfigFiles { scripts = ./scripts; }) ];
    # These packages provide CLI tools only; no audio/notification daemon is enabled here.
    home.packages = with pkgs; [
      brillo
      dunst
      libnotify
      wireplumber
      awww
      coreutils
      gnused
      gnugrep
      gawk
    ];
  };
}
