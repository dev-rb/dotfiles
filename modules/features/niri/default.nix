{ mkFeature, inputs, ... }:
mkFeature {
  name = "niri";
  homeManager = { pkgs, ... }: {
    imports = [ inputs.niri.homeModules.niri ];
    programs.niri.enable = true;
    xdg.configFile."niri/config.kdl".text = builtins.readFile ./config.kdl;
    home.packages = with pkgs; [
      awww
      vicinae
      tofi
      brave
      glib
      gsettings-desktop-schemas
      adw-gtk3
      qt6Packages.qt6ct
      bash
      findutils
    ];
    # Make the schema available to the native gsettings startup commands.
    home.sessionVariablesExtra = ''
      export XDG_DATA_DIRS="${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}:''${XDG_DATA_DIRS:-/usr/local/share:/usr/share}"
    '';
  };
}
