{ pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    plugins = [
      # {
      #    name = "fzf-tab";
      #    src = pkgs.fetchFromGitHub {
      #      owner = "Aloxaf";
      #      repo = "fzf-tab";
      #      rev = "v1.1.2";
      #      sha256 = "7fed01afba9392b6392408b9a0cf888522ed7a10";
      #    };
      #  }
    ];
    shellAliases = {
      ls = "eza --icons=always";
      cat = "bat";
    };

    defaultKeymap = "emacs";

    # zprof.enable = true;

    completionInit = "
      autoload -Uz compinit

      for dump in ~/.zcompdump(N.mh+24); do
        compinit
      done
      compinit -C
    ";

    initExtra = ''
      eval "$(oh-my-posh init zsh --config ~/dotfiles/pure.omp.json)"
      bindkey '^p' history-search-backward
      bindkey '^n' history-search-forward

      export PATH="/home/dev-rb/.local/share/fnm:$PATH"
      export PATH=$PATH:/mnt/e/WezTerm/wezterm.exe
      eval "`fnm env`"

      export PNPM_HOME="/home/dev-rb/.local/share/pnpm"
      case ":$PATH:" in
        *":$PNPM_HOME:"*) ;;
        *) export PATH="$PNPM_HOME:$PATH" ;;
      esac

      source ~/wezterm.sh

    '';
  };

  programs.oh-my-posh = {
    enable = true;
    enableZshIntegration = true;
  };
}
