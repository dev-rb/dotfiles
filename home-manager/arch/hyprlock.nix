{ ... }: {
  programs.hyprlock = {
    enable = true;

    settings = {
      "$font" = "Monospace";

      general = {
        hide_cursor = false;
        fail_timeout = 500;
      };

      # uncomment to enable fingerprint authentication
      auth = {
        fingerprint = {
          enabled = true;
          ready_message = "Scan fingerprint to unlock";
          present_message = "Scanning...";
          retry_delay = 250; # in milliseconds
        };
      };

      background = {
        monitor = "";
        path = "screenshot";
        blur_passes = 3;
      };

      input-field = {
        monitor = "";
        size = "20%, 5%";
        outline_thickness = 2;
        inner_color = "rgba(0, 0, 0, 0.0)"; # no fill

        outer_color = "rgba(d65d0eee)";
        check_color = "rgba(cc241dee)";
        fail_color = "rgba(98971aee)";

        font_color = "rgb(143, 143, 143)";
        fade_on_empty = false;
        rounding = 8;

        font_family = "$font";
        placeholder_text = "Input password...";
        fail_text = "$PAMFAIL";

        # uncomment to use a letter instead of a dot to indicate the typed password
        # dots_text_format = *
        # dots_size = 0.4
        dots_spacing = 0.3;

        # uncomment to use an input indicator that does not show the password length (similar to swaylock's input indicator)
        # hide_input = true

        position = "0, -20";
        halign = "center";
        valign = "center";
      };

      # TIME
      label = [
        {
          monitor = "";
          text =
            "$TIME12"; # ref. https://wiki.hyprland.org/Hypr-Ecosystem/hyprlock/#variable-substitution
          font_size = 90;
          font_family = "$font";

          position = "-30, 0";
          halign = "right";
          valign = "top";
        }
        {
          monitor = "";
          text = ''
            cmd[update:60000] date +"%A, %d %B %Y"''; # update every 60 seconds
          font_size = 25;
          font_family = "$font";

          position = "-30, -150";
          halign = "right";
          valign = "top";
        }
        {
          monitor = "";
          text = "$LAYOUT[en,ru]";
          font_size = 24;
          onclick = "hyprctl switchxkblayout all next";

          position = "250, -20";
          halign = "center";
          valign = "center";
        }
      ];

    };

  };
}
