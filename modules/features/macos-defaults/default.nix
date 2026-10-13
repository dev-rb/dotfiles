{ mkFeature, ... }:
mkFeature {
  name = "macos-defaults";
  darwin = { lib, ... }: {
    # Capture explicit preferences only; leave unset macOS defaults unmanaged.
    # Hosts can override these shared preferences without mkForce.
    system.defaults = lib.mkDefault {
      NSGlobalDomain = {
        AppleInterfaceStyle = "Dark";
        KeyRepeat = 2;
        InitialKeyRepeat = 25;
        NSAutomaticCapitalizationEnabled = true;
        NSAutomaticPeriodSubstitutionEnabled = true;
        "com.apple.swipescrolldirection" = false;
      };

      dock = {
        autohide = true;
        tilesize = 28;
      };

      finder.FXPreferredViewStyle = "Nlsv";

      # Built-in and Bluetooth trackpads have matching current preferences.
      trackpad = {
        Clicking = false;
        TrackpadRightClick = true;
        TrackpadThreeFingerDrag = false;
        TrackpadThreeFingerTapGesture = 0;
      };
    };
  };
}
