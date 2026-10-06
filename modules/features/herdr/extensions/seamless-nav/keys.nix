{
  # Herdr handles vertical sidebar selection itself.
  navigate_workspace_up = [
    "up"
    "ctrl+k"
  ];
  navigate_workspace_down = [
    "down"
    "ctrl+j"
  ];

  command =
    map
      ({ key, action }: {
        inherit key;
        type = "plugin_action";
        command = "seamless-nav.${action}";
      })
      [
        {
          key = "ctrl+h";
          action = "left";
        }
        {
          key = "ctrl+j";
          action = "down";
        }
        {
          key = "ctrl+k";
          action = "up";
        }
        {
          key = "ctrl+l";
          action = "right";
        }
        # Prefix bindings also match plain Ctrl+H/L while the sidebar is open.
        {
          key = "prefix+ctrl+h";
          action = "sidebar-left";
        }
        {
          key = "prefix+ctrl+l";
          action = "sidebar-right";
        }
      ];
}
