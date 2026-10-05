{ pkgs, ... }:
{
  # Shared tools only. Node versions stay with fnm; Rust toolchains stay with rustup.
  home.packages = with pkgs; [
    fd
    fzf
    gh
    google-cloud-sdk
    jless
    ripgrep
    wget
    jq
    btop
    fnm
    bun
    oxlint
    oxfmt
    lua-language-server
    tailwindcss-language-server
    typescript-language-server
    nil
    tree-sitter
    nixfmt
    stylua
    rustup
    go
    just
    docker
  ];
}
