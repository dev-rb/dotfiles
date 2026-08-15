{ pkgs, ... }:

{
  programs.bat.enable = true;

  programs.eza = {
    enable = true;
    icons = "auto";
    git = true;
    extraOptions = [ "--group-directories-first" ];
  };

  # fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    nerd-fonts.iosevka-term
    nerd-fonts.jetbrains-mono
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
    adwaita-fonts

    # cli
    bat
    eza
    fd
    fzf
    gh
    jless
    ripgrep
    wget
    jq
    btop
    oh-my-posh

    # javascript/typescript
    fnm
    bun
    oxlint
    oxfmt

    # LSPs
    lua-language-server
    tailwindcss-language-server
    #unocss-language-server
    typescript-language-server
    nil

    tree-sitter

    # formatters
    nixfmt
    stylua
    biome

    rustup

    go

    just

    docker
  ];

}
