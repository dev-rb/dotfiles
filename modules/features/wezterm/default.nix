{ mkFeature, mkConfigFiles, ... }:

mkFeature {
  name = "wezterm";
  homeManager =
    { pkgs, ... }:
    {
      programs.wezterm.enable = pkgs.stdenv.isLinux;
    }
    // mkConfigFiles {
      "wezterm/wezterm.lua" = ./wezterm.lua;
      "wezterm/windows.lua" = ./windows.lua;
    };
}
