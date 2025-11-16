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

    shellAliases =
      {
        ls = "eza --icons=always";
        cat = "bat";
        gcf = "git checkout $(git branch --sort=committerdate | fzf --tac --exact)";
        gs = "git status";
      }
      // (
        if vars.name == "wsl" then
          {

            # Windows path for explorer
            explorer = "/mnt/c/Windows/explorer.exe";
            wezterm = "/mnt/c/Program\\ Files/WezTerm/wezterm.exe";
          }
        else
          { }
      );

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

      export GOPATH="/home/${vars.username}/go"

      export PATH="/home/${vars.username}/.local/share/fnm:$PATH"
      export PATH=$PATH:/usr/local/go/bin:$GOPATH/bin

      export BUN_INSTALL="$HOME/.bun"
      export PAGER=cat
      export PATH="$BUN_INSTALL/bin:$PATH"

      export ANDROID_HOME="$HOME/Android/Sdk"
      export PATH=$PATH:$ANDROID_HOME/emulator
      export PATH=$PATH:$ANDROID_HOME/platform-tools



      # export PATH=$PATH:"/mnt/c/Program Files/WezTerm/"

      eval "`fnm env`"

      export PNPM_HOME="/home/${vars.username}/.local/share/pnpm"
      case ":$PATH:" in
        *":$PNPM_HOME:"*) ;;
        *) export PATH="$PNPM_HOME:$PATH" ;;
      esac

      alias air='$(go env GOPATH)/bin/air'
      source ~/wezterm.sh

    '';
  };

  programs.oh-my-posh = {
    enable = true;
    enableZshIntegration = true;
  };
}
