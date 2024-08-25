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

    initExtra = ''
      eval "$(oh-my-posh init zsh --config ~/dotfiles/pure.omp.json)"
      bindkey '^p' history-search-backward
      bindkey '^n' history-search-forward

    '';
  };

  programs.oh-my-posh = {
    enable = true;
    enableZshIntegration = true;
  };
}
