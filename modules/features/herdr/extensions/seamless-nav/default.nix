{
  config,
  lib,
  pkgs,
  ...
}:
let
  package = config.programs.herdr.package;
  pluginPath = "${config.xdg.configHome}/herdr/extensions/seamless-nav";
  runtimeInputs = [
    pkgs.jq
    pkgs.coreutils
    pkgs.gnugrep
  ]
  ++ lib.optional pkgs.stdenv.isLinux pkgs.procps;

  # Keep Herdr's current server binary when provided. The fallback and shell
  # tools are pinned; WezTerm still comes from its existing app installation.
  navigate = pkgs.writeShellScript "herdr-seamless-nav" ''
    export PATH=${lib.makeBinPath runtimeInputs}:$PATH
    export HERDR_BIN_PATH="''${HERDR_BIN_PATH:-${lib.getExe package}}"
    ${builtins.readFile ./scripts/navigate.sh}
  '';

  plugin = pkgs.runCommand "herdr-seamless-nav-plugin" { } ''
    mkdir -p "$out/scripts" "$out/nvim" "$out/wezterm"
    substitute ${./herdr-plugin.toml} "$out/herdr-plugin.toml" \
      --replace-fail '"bash"' '"${lib.getExe pkgs.bash}"'
    cp ${navigate} "$out/scripts/navigate.sh"
    cp ${./nvim/at_edge.lua} "$out/nvim/at_edge.lua"
    cp ${./wezterm/seamless-nav.lua} "$out/wezterm/seamless-nav.lua"
  '';

  # Refresh the managed path without undoing a local `herdr plugin disable`.
  # Run the read and write together through Home Manager's dry-run helper.
  registerPlugin = pkgs.writeShellScript "herdr-link-seamless-nav" ''
    set -euo pipefail
    plugins="$(${lib.getExe package} plugin list --json --plugin seamless-nav)"
    disabled="$(${lib.getExe pkgs.jq} -r '
      .result.plugins | if type == "array" then
        any(.[]; .plugin_id == "seamless-nav" and .enabled == false)
      else error("Invalid Herdr plugin list") end
    ' <<<"$plugins")"
    if [[ $disabled == true ]]; then
      exec ${lib.getExe package} plugin link "$1" --disabled
    else
      exec ${lib.getExe package} plugin link "$1"
    fi
  '';
in
{
  xdg.configFile."herdr/extensions/seamless-nav".source = plugin;
  home.sessionVariables.HERDR_SEAMLESS_NAV_DIR = pluginPath;

  # Load before WezTerm's shared callbacks. The store path also makes helper
  # changes update the main config, triggering its native reload watcher.
  programs.wezterm.extraConfig = lib.mkOrder 400 ''
    local herdr_seamless_nav_path = ${lib.generators.toLua { } "${plugin}/wezterm/seamless-nav.lua"}
  '';

  # Link only this plugin through Herdr's API. Keep the rest of its writable
  # registry, active settings, and plugin configuration outside Home Manager.
  home.activation.herdrSeamlessNavigation = lib.hm.dag.entryAfter [ "herdrSettingsDefaults" ] ''
    herdrConfigHome=${lib.escapeShellArg config.xdg.configHome}
    run ${pkgs.coreutils}/bin/env \
      XDG_CONFIG_HOME="''${XDG_CONFIG_HOME-$herdrConfigHome}" \
      ${registerPlugin} ${lib.escapeShellArg pluginPath}
  '';
}
