{ pkgs, ... }:

{
  programs.bat.enable = true;

  programs.eza = {
    enable = true;
    icons = true;
    git = true;
    extraOptions = [ "--group-directories-first" ];
  };

  home.packages = with pkgs; [
    # cli
    bat
    eza
    fd
    fzf
    gh
    jless
    ripgrep
    wget

    # javascript/typescript
    pnpm
    fnm

    # LSPs
    lua-language-server
    tailwindcss-language-server
    #unocss-language-server
    typescript-language-server

    nixfmt-rfc-style

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')

  ];

}
