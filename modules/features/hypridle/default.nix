{ mkFeature, ... }:
mkFeature {
  name = "hypridle";
  homeManager =
    { config, pkgs, ... }:
    let
      niri = config.programs.niri.enable or false;
      monitorOn = if niri then "niri msg action power-on-monitors" else "hyprctl dispatch dpms on";
      monitorOff = if niri then "niri msg action power-off-monitors" else "hyprctl dispatch dpms off";
    in
    {
      home.packages = [ pkgs.procps ];
      services.hypridle = {
        enable = true;
        settings = {
          general = {
            lock_cmd = "pidof hyprlock || hyprlock";
            before_sleep_cmd = "loginctl lock-session";
            after_sleep_cmd = monitorOn;
          };
          listener = [
            {
              timeout = 300;
              on-timeout = "loginctl lock-session";
            }
            {
              timeout = 330;
              on-timeout = monitorOff;
              on-resume = monitorOn;
            }
            {
              timeout = 1800;
              on-timeout = "systemctl suspend";
            }
          ];
        };
      };
    };
}
