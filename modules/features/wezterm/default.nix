{ mkFeature, mkConfigFiles, ... }:

mkFeature {
  name = "wezterm";
  homeManager =
    { pkgs, ... }:
    {
      programs.wezterm.enable = pkgs.stdenv.isLinux;

      home.file.".wezterm.lua".source = ./wezterm.lua;
    }
    // mkConfigFiles { "wezterm/windows.lua" = ./windows.lua; };
}
