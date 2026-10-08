{ mkFeature, ... }:
mkFeature {
  name = "devtools";
  homeManager = { pkgs, ... }: {
    # Keep Node versions with fnm and Rust toolchains with rustup.
    home.packages = with pkgs; [
      google-cloud-sdk
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

      # Portable build and service CLIs; macOS-only tools live in macos-apps.
      cmake
      doppler
      pulumi
      sccache
      stripe-cli
      zig
    ];
  };
}
