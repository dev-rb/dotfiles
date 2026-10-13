{ lib, pkgs, ... }:
let
  inline = lib.generators.mkLuaInline;
  spacedIcon = icon: inline ''string.rep(" ", 2) .. wezterm.nerdfonts.${icon} .. string.rep(" ", 2)'';
  closeIcon = ''string.rep(" ", 2) .. wezterm.nerdfonts.fae_thin_close .. string.rep(" ", 2)'';
in
{
  programs.wezterm.settings = {
    # Reloading and history.
    automatically_reload_config = lib.mkDefault true;
    scrollback_lines = lib.mkDefault 3500;

    # Font.
    font = lib.mkDefault (inline ''wezterm.font("IosevkaTerm Nerd Font Mono")'');
    # Read managed fonts directly when CoreText has not discovered them.
    font_dirs = lib.mkIf pkgs.stdenv.hostPlatform.isDarwin (
      lib.mkDefault [ (inline ''wezterm.home_dir .. "/Library/Fonts/HomeManager"'') ]
    );
    font_size = lib.mkDefault 12;
    line_height = lib.mkDefault 1.1;
    freetype_load_flags = lib.mkDefault "NO_HINTING";
    cell_width = lib.mkDefault 1.0;

    # Window appearance.
    color_scheme = lib.mkDefault "Argonaut (Gogh)";
    window_padding = lib.mkDefault {
      top = 0;
      left = 0;
      bottom = 0;
      right = 0;
    };
    window_background_image_hsb = lib.mkDefault { };
    window_background_opacity = lib.mkDefault 0.88;
    window_decorations = lib.mkDefault "INTEGRATED_BUTTONS | RESIZE";
    adjust_window_size_when_changing_font_size = lib.mkDefault false;

    # Rendering.
    front_end = lib.mkDefault "OpenGL";

    # Tabs.
    use_fancy_tab_bar = lib.mkDefault false;
    enable_tab_bar = lib.mkDefault true;
    tab_bar_style = lib.mkDefault {
      window_hide = spacedIcon "fae_minimize";
      window_hide_hover = spacedIcon "fae_minimize";
      window_maximize = spacedIcon "fae_maximize";
      window_maximize_hover = spacedIcon "fae_maximize";
      window_close = inline closeIcon;
      window_close_hover = inline ''wezterm.format({ { Background = { Color = "red" } }, { Text = ${closeIcon} } })'';
    };

    colors = lib.mkDefault {
      tab_bar = {
        background = "black";
        active_tab = {
          fg_color = inline ''wezterm.color.parse("#1DA0D8"):lighten(0.8)'';
          bg_color = inline ''wezterm.color.parse("#1D61D9"):lighten(0.03)'';
        };
        new_tab = {
          bg_color = "black";
          fg_color = "#ffffff";
        };
        new_tab_hover = {
          bg_color = "#151515";
          fg_color = "#ffffff";
        };
      };
    };

    # Title bar.
    window_frame = lib.mkDefault {
      active_titlebar_bg = "transparent";
      inactive_titlebar_bg = "transparent";
    };
  };
}
