{ pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    plugins = [ ];
    shellAliases = {
      ls = "eza --icons=always";
      cat = "bat";
    };

    initExtra = ''eval "$(oh-my-posh init zsh --config ~/dotfiles/pure.omp.json)"'';
  };

  programs.oh-my-posh = {
    enable = true;
    enableZshIntegration = true;
  };
}
