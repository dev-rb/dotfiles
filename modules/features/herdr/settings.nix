{
  # Use the configured interface directly on a fresh installation.
  onboarding = false;

  # Shared appearance; keep automatic theme switching disabled.
  theme = {
    name = "vesper";
    auto_switch = false;
  };

  # Render symbolic status indicators and keep notifications inside Herdr.
  ui = {
    status_indicators = "symbols";
    toast.delivery = "herdr";
  };
}
