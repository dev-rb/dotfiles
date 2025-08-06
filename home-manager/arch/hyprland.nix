{ pkgs, ... }:

{
  home.file = {
    ".config/hypr/" = {
      source = ../../hyprland;
      recursive = true;
      force = true;
    };
  };

  wayland.windowManager.hyprland = {
    enable = true;
    package = pkgs.hyprland;
    settings = {
      monitor = ",1920x1200,auto,1,bitdepth,8";
      xwayland = { force_zero_scaling = true; };

      # Set programs that you use
      "$terminal " = "wezterm";
      "$browser " = "firefox";
      "$fileManager " = "dolphin";
      "$appMenu " = "rofi -show drun";

      env = [
        "XCURSOR_SIZE,10"
        "HYPRCURSOR_SIZE,10"
        "LIBVA_DRIVER_NAME,nvidia"
        "__GLX_VENDOR_LIBRARY_NAME,nvidia"
        # Force all apps to use Wayland
        "GDK_BACKEND,wayland"
        "QT_QPA_PLATFORM,wayland"
        "QT_STYLE_OVERRIDE,kvantum"
        "SDL_VIDEODRIVER,wayland"
        "MOZ_ENABLE_WAYLAND,1"
        "ELECTRON_OZONE_PLATFORM_HINT,wayland"
        "OZONE_PLATFORM,wayland"

        # Make Chromium use XCompose and all Wayland
        ''
          CHROMIUM_FLAGS,"--enable-features=UseOzonePlatform --ozone-platform=wayland --gtk-version=4"''

      ];

      misc = {
        # Set to 0 or 1 to disable the anime mascot wallpapers
        force_default_wallpaper = 0;
        # If true disables the random hyprland logo / anime girl background. :(
        disable_hyprland_logo = true;
        initial_workspace_tracking = 1;
      };

      input = {
        kb_layout = "us";
        kb_variant = "";
        kb_model = "";
        kb_options = "";
        kb_rules = "";

        follow_mouse = 1;
        # -1.0 - 1.0, 0 means no modification.
        sensitivity = 0;

        touchpad = { natural_scroll = true; };
      };

      gestures = {
        workspace_swipe = true;
        workspace_swipe_distance = 100;
        workspace_swipe_forever = true;
        workspace_swipe_fingers = 4;
      };

      general = {
        gaps_in = 4;
        gaps_out = "8, 4, 4, 4";

        border_size = 0;

        # https://wiki.hyprland.org/Configuring/Variables/#variable-types for info about colors
        "col.active_border" = "rgba(FFFFFF40)";
        "col.inactive_border" = "rgba(59595940)";

        # Set to true enable resizing windows by clicking and dragging on borders and gaps
        resize_on_border = true;

        # Please see https://wiki.hyprland.org/Configuring/Tearing/ before you turn this on
        allow_tearing = false;

        layout = "dwindle";

        no_focus_fallback = true;
      };

      # https://wiki.hyprland.org/Configuring/Variables/#decoration
      decoration = {
        rounding = 8;
        rounding_power = 1;

        # Change transparency of focused and unfocused windows
        active_opacity = 1.0;
        inactive_opacity = 1.0;

        dim_inactive = true;
        dim_strength = 0.15;

        shadow = {
          enabled = false;
          range = 4;
          render_power = 3;
          color = "rgba(1a1a1aee)";
        };

        # https://wiki.hyprland.org/Configuring/Variables/#blur
        blur = {
          enabled = false;
          size = 4;
          passes = 1;
        };
      };

      # https://wiki.hyprland.org/Configuring/Variables/#animations
      animations = {
        enabled = true;

        # Default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more

        bezier = [
          "easeOutQuint,0.23,1,0.32,1"
          "easeInOutCubic,0.65,0.05,0.36,1"
          "linear,0,0,1,1"
          "almostLinear,0.5,0.5,0.75,1.0"
          "quick,0.15,0,0.1,1"
        ];

        animation = [

          "global, 1, 10, default"
          "border, 1, 5.39, easeOutQuint"
          "windows, 1, 4.79, easeOutQuint"
          "windowsIn, 1, 4.1, easeOutQuint, popin 87%"
          "windowsOut, 1, 1.49, linear, popin 87%"
          "fadeIn, 1, 1.73, almostLinear"
          "fadeOut, 1, 1.46, almostLinear"
          "fade, 1, 3.03, quick"
          "layers, 1, 3.81, easeOutQuint"
          "layersIn, 1, 4, easeOutQuint, fade"
          "layersOut, 1, 1.5, linear, fade"
          "fadeLayersIn, 1, 1.79, almostLinear"
          "fadeLayersOut, 1, 1.39, almostLinear"
          "workspaces, 1, 1.94, almostLinear, fade"
          "workspacesIn, 1, 1.21, almostLinear, fade"
          "workspacesOut, 1, 1.94, almostLinear, fade"
        ];

      };

      dwindle = {
        # Master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
        pseudotile = true;
        preserve_split = true;
      };

      # See https://wiki.hyprland.org/Configuring/Master-Layout/ for more
      master = { new_status = "master"; };

      exec-once = [
        "hypridle"
        "swww-daemon &"
        "./wallpapers.sh"
        "waybar "
        "dunst"

        # Bluetooth autoconnect
        "bluetoothctl trust D0:56:FB:42:9F:5A"
        "bluetoothctl power on"
        "bluetoothctl connect D0:56:FB:42:9F:5A"

      ];

      # Sets "Windows" key as main modifier
      "$mainMod" = "SUPER";
      # Sets "Alt" key as secondary modifier
      "$secondaryMod" = "Alt";

      binds = {
        workspace_back_and_forth = true;
        allow_workspace_cycles = true;
      };
      bind = [

        "$mainMod, Q, exec, $terminal"
        "$mainMod, T, exec, $terminal start btop"
        "$mainMod, B, exec, $browser"
        "$mainMod, C, killactive"
        "$mainMod, Escape, exec, hyprlock"
        "$mainMod, M, exit"
        "$mainMod, E, exec, $fileManager"
        "$mainMod, V, togglefloating"
        "$mainMod, V, centerwindow, 1"
        "ALT, space, exec, $appMenu"
        "$mainMod, P, pseudo, # dwindle"
        "$mainMod, J, togglesplit, # dwindle"

        # Move focus with mainMod + arrow keys
        "$secondaryMod, h, movefocus, l"
        "$secondaryMod, j, movefocus, d"
        "$secondaryMod, k, movefocus, u"
        "$secondaryMod, l, movefocus, r"

        "$mainMod, h, movewindow, l"
        "$mainMod, l, movewindow, r"
        "$mainMod, j, movewindow, d"
        "$mainMod, k, movewindow, u"

        # Switch workspaces with mainMod + [0-9]
        "$mainMod, 1, workspace, 1"
        "$mainMod, 2, workspace, 2"
        "$mainMod, 3, workspace, 3"
        "$mainMod, 4, workspace, 4"
        "$mainMod, 5, workspace, 5"
        "$mainMod, 6, workspace, 6"
        "$mainMod, 7, workspace, 7"
        "$mainMod, 8, workspace, 8"
        "$mainMod, 9, workspace, 9"
        "$mainMod, 0, workspace, 10"

        # Move active window to a workspace with mainMod + SHIFT + [0-9]
        "$mainMod SHIFT, 1, movetoworkspacesilent, 1"
        "$mainMod SHIFT, 2, movetoworkspacesilent, 2"
        "$mainMod SHIFT, 3, movetoworkspacesilent, 3"
        "$mainMod SHIFT, 4, movetoworkspacesilent, 4"
        "$mainMod SHIFT, 5, movetoworkspacesilent, 5"
        "$mainMod SHIFT, 6, movetoworkspacesilent, 6"
        "$mainMod SHIFT, 7, movetoworkspacesilent, 7"
        "$mainMod SHIFT, 8, movetoworkspacesilent, 8"
        "$mainMod SHIFT, 9, movetoworkspacesilent, 9"
        "$mainMod SHIFT, 0, movetoworkspacesilent, 10"

        # Example special workspace (scratchpad)
        "$mainMod, S, togglespecialworkspace, magic"
        "$mainMod SHIFT, S, movetoworkspacesilent, special:magic"

        # Scroll through existing workspaces with mainMod + scroll
        "$secondaryMod, TAB, cyclenext, hist next"
        "$secondaryMod, TAB, alterzorder, top"

        "$secondaryMod SHIFT, TAB, cyclenext, hist prev "
        "$secondaryMod SHIFT, TAB, alterzorder, top "

        "$mainMod, TAB, workspace, e+1"
        "$mainMod SHIFT, TAB, workspace, e-1"

        "$mainMod SHIFT, up, fullscreenstate, 1"
        "$mainMod SHIFT, left, resizeactive, exact 100% 100%"
        "$mainMod SHIFT, left, moveactive, exact 0 4"
        "$mainMod SHIFT, right, resizeactive, exact 100% 100%"
        "$mainMod SHIFT, right, moveactive, exact 0 4"

        "$mainMod, P, pin"
      ];

      bindm = [
        # Move/resize windows with mainMod + LMB/RMB and dragging
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];

      bindel = [
        # Laptop multimedia keys for volume and LCD brightness
        ",XF86AudioRaiseVolume, exec, sh $HOME/.config/hypr/volume.sh up"
        ",XF86AudioLowerVolume, exec, sh $HOME/.config/hypr/volume.sh down"
        ",XF86AudioMute, exec, sh $HOME/.config/hypr/volume.sh mute"
        ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
        ",XF86MonBrightnessUp, exec, sh $HOME/.config/hypr/brightness.sh up"
        ",XF86MonBrightnessDown, exec, sh $HOME/.config/hypr/brightness.sh down"
      ];

      bindl = [
        ", XF86AudioNext, exec, playerctl next"
        ", XF86AudioPause, exec, playerctl play-pause"
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioPrev, exec, playerctl previous"
      ];

      windowrule = [
        # Ignore maximize requests from apps. You'll probably like this.
        "suppressevent maximize, class:.*"
        # Fix some dragging issues with XWayland
        "nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0"
      ];

    };
  };
}
