{
  imports = [
    ./packages.nix
    ./fonts.nix
    ./programs/general.nix
    ./programs/zsh.nix
    ./programs/neovim.nix
    ./programs/git.nix
  ];

  home.sessionVariables.EDITOR = "nvim";
  programs.home-manager.enable = true;
}
