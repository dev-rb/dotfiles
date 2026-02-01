{ pkgs, ... }:

{
  programs.bat.enable = true;

  programs.eza = {
    enable = true;
    icons = "auto";
    git = true;
    extraOptions = [ "--group-directories-first" ];
  };

  home.packages = with pkgs; [
    nerd-fonts.iosevka-term
    nerd-fonts.jetbrains-mono

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

    # javascript/typescript
    fnm
    bun

    # LSPs
    lua-language-server
    tailwindcss-language-server
    #unocss-language-server
    typescript-language-server
    nil

    tree-sitter

    # formatters
    nixfmt-rfc-style
    stylua
    biome
  ];

}
