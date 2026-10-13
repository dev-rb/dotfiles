{ mkFeature, ... }:
mkFeature {
  name = "git";
  homeManager =
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
          # Undo Git's default LESS=FRX no-init flag for alternate-screen scrolling.
          core.pager = "bat --paging=always --style=plain --pager='less -FR -+X'";
        };
      };

      programs.zsh.shellAliases = {
        gcf = "git checkout $(git branch --sort=committerdate | fzf --tac --exact)";
        gcrf = ''
          git checkout $(git branch --remote --sort=-committerdate | fzf | sed 's/[[:alnum:]_]\{1,\}\///')
        '';
        gs = "git status";
        gds = "git diff --staged";
        gd = "git diff";
      };
    };
}
