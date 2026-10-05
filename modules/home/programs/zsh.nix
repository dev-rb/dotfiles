{ ... }:

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
    };

    defaultKeymap = "emacs";

    completionInit = ''
      autoload -Uz compinit

      for dump in ~/.zcompdump(N.mh+24); do
        compinit
      done
      compinit -C
    '';

    initContent = ''
      export GOPATH="$HOME/go"
      export BUN_INSTALL="$HOME/.bun"
      export ANDROID_HOME="$HOME/Android/Sdk"
      export PNPM_HOME="$HOME/.local/share/pnpm"
      export PAGER=cat
      export BAT_PAGING=always
      export GPG_TTY=$(tty)

      typeset -U path
      path=("$PNPM_HOME" "$HOME/.local/bin" "$BUN_INSTALL/bin" "$HOME/.local/share/fnm" $path /usr/local/go/bin "$GOPATH/bin" "$ANDROID_HOME/emulator" "$ANDROID_HOME/platform-tools" "$HOME/.cargo/bin")

      if (( $+commands[fnm] )); then
        eval "$(fnm env)"
      fi

      alias air='$(go env GOPATH)/bin/air'
      if [ -f "$HOME/wezterm.sh" ]; then
        source "$HOME/wezterm.sh"
      fi

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
        cmd="''${FZF_DEFAULT_COMMAND/--hidden /}"
        result=$(eval "''${cmd:-find . -type f}" | fzf --preview "$_FZF_PREVIEW_CMD") \
          && LBUFFER+="$result"
        zle reset-prompt
      }
      zle -N _fzf_file_no_hidden

      zle-keymap-select () {
        if [ $KEYMAP = vicmd ]; then
          printf "\033[2 q"
        else
          printf "\033[6 q"
        fi
      }
      zle -N zle-keymap-select
      zle-line-init () {
        zle -K viins
        printf "\033[6 q"
      }
      zle -N zle-line-init

      bindkey -v
      source <(fzf --zsh)
      bindkey '^p' history-search-backward
      bindkey '^n' history-search-forward
    '';
  };

  programs.oh-my-posh = {
    enable = true;
    enableZshIntegration = true;
    configFile = ../../../pure.omp.json;
  };
}
