{ vars, ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    historySubstringSearch.enable = true;

    history = {
      ignoreAllDups = true;
      ignoreDups = true;
      ignoreSpace = true;
    };

    shellAliases = {
      ls = "eza --icons=always";
      cat = "bat";
    } // (if vars.name == "wsl" then {

      # Windows path for explorer
      explorer = "/mnt/c/Windows/explorer.exe";
      wezterm = "$WEZTERM";
    } else
      { });

    defaultKeymap = "emacs";

    # zprof.enable = true;

    completionInit = ''
      autoload -Uz compinit

      for dump in ~/.zcompdump(N.mh+24); do
        compinit
      done
      compinit -C
    '';

    initContent = ''
      eval "$(oh-my-posh init zsh --config ~/dotfiles/pure.omp.json)"
      bindkey '^p' history-search-backward
      bindkey '^n' history-search-forward


      export GOPATH="$HOME/go"

      export PATH="$HOME/.local/share/fnm:$PATH"
      export PATH=$PATH:/usr/local/go/bin:$GOPATH/bin

      export BUN_INSTALL="$HOME/.bun"
      export PAGER=less
      export BAT_PAGING=always
      export PATH="$BUN_INSTALL/bin:$PATH"

      export ANDROID_HOME="$HOME/Android/Sdk"
      export PATH=$PATH:$ANDROID_HOME/emulator
      export PATH=$PATH:$ANDROID_HOME/platform-tools



      export PATH="$BUN_INSTALL/bin:$PATH"

      eval "`fnm env`"

      export PNPM_HOME="$HOME/.local/share/pnpm"
      case ":$PATH:" in
        *":$PNPM_HOME:"*) ;;
        *) export PATH="$PNPM_HOME:$PATH" ;;
      esac

      alias air='$(go env GOPATH)/bin/air'
      source ~/wezterm.sh

    '' + (if vars.name == "wsl" then
      ''export WEZTERM="$(fd wezterm.exe /mnt --max-results 1)"''
    else
      "");
  };

  programs.oh-my-posh = {
    enable = true;
    enableZshIntegration = true;
    configFile = "~/dotfiles/pure.omp.json";
  };
}
