{ mkFeature, ... }:
mkFeature {
  name = "wsl";
  homeManager = { lib, ... }: {
    programs.zsh.shellAliases = {
      explorer = "/mnt/c/Windows/explorer.exe";
      wezterm = "$WEZTERM";
    };
    programs.zsh.initContent = lib.mkAfter ''
      # Respect an explicit path; Windows mounts are not always available.
      if [[ -z "$WEZTERM" && -d /mnt/c ]]; then
        export WEZTERM="$(fd --absolute-path --max-results 1 '^wezterm\.exe$' /mnt/c 2>/dev/null)"
      fi
    '';
  };
}
