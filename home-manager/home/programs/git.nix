{ ... }:

{
  programs.git = {
    enable = true;
    settings = {
      init.defaultBranch = "main";
      push = {
        autoSetupRemote = true;
        default = "simple";
      };
      user = {
        email = "43100342+dev-rb@users.noreply.github.com";
        name = "dev-rb";
      };
      core.editor = "nvim";
      core.pager = "bat";
    };
  };

  programs.zsh.shellAliases = {
    gcf = "git checkout $(git branch --sort=committerdate | fzf --tac --exact)";
    gs = "git status";
  };
}
