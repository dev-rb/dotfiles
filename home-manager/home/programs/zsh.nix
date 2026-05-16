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
    }
    // (
      if vars.name == "wsl" then
        {

          # Windows path for explorer
          explorer = "/mnt/c/Windows/explorer.exe";
          wezterm = "$WEZTERM";
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
      export PATH="$HOME/.local/bin:$PATH"

      eval "`fnm env`"

      export PNPM_HOME="$HOME/.local/share/pnpm"
      case ":$PATH:" in
        *":$PNPM_HOME:"*) ;;
        *) export PATH="$PNPM_HOME:$PATH" ;;
      esac

      alias air='$(go env GOPATH)/bin/air'
      source ~/wezterm.sh

      source <(fzf --zsh)

      export FZF_DEFAULT_COMMAND='fd --type f --hidden --strip-cwd-prefix'

      export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

      export FZF_DEFAULT_OPTS='
        --height=60%
        --layout=reverse
        --border=rounded
        --prompt="  "
        --pointer="  "
        --preview-window=right:65%:wrap:border-left
      '

      export _FZF_PREVIEW_CMD='bat --color=always --style=plain,numbers --line-range=:500 {}'
      export FZF_CTRL_T_OPTS="--preview '$_FZF_PREVIEW_CMD'"

      _fzf_file_no_hidden() {
        local cmd result
        cmd="\$\{FZF_DEFAULT_COMMAND/--hidden /}"
        result=$(eval "\$\{cmd:-find . -type f}" | fzf --preview "$_FZF_PREVIEW_CMD") \
          && LBUFFER+="$result"
        zle reset-prompt
      }
      zle -N _fzf_file_no_hidden


    ''
    + (if vars.name == "wsl" then ''export WEZTERM="$(fd wezterm.exe /mnt --max-results 1)"'' else "");
  };

  programs.oh-my-posh = {
    enable = true;
    enableZshIntegration = true;
    configFile = "~/dotfiles/pure.omp.json";
  };
}
