{
  # Startup preferences captured from the current non-secret configuration.
  defaultProvider = "openai-codex";
  defaultModel = "gpt-6.1-sol";
  defaultThinkingLevel = "xhigh";

  # Enable pi's built-in codemode tool alongside the default tools.
  defaultTools = [ "+codemode" ];

  # Keep the palette independent of machine-local extension checkouts.
  theme = "dotfiles-workbench-dark";
  hideThinkingBlock = true;
  terminal.showTerminalProgress = true;

  compaction.enabled = true;
  followUpMode = "one-at-a-time";

  enableInstallTelemetry = false;
}
