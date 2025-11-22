{ pkgs, nixgl, ... }:

{
  programs.bat.enable = true;

  programs.eza = {
    enable = true;
    icons = "auto";
    git = true;
    extraOptions = [ "--group-directories-first" ];
  };

  # fonts.fontconfig.enable = true;

  nixGL.packages = nixgl.packages;
  nixGL.defaultWrapper = "mesa";
  #nixGL.offloadWrapper = "nvidiaPrime";
  nixGL.installScripts = [ "mesa" ];

  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = (pkg: true);
    };
  };

  home.packages = with pkgs; [
    # nixgl.auto.nixGLNvidia
    # nixgl.auto.nixVulkanNvidia
    # nixgl.nixGLIntel
    # nixgl.nixVulkanIntel

    # fonts
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
    adwaita-fonts
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
    oh-my-posh

    # javascript/typescript
    fnm
    bun

    # LSPs
    lua-language-server
    tailwindcss-language-server
    #unocss-language-server
    typescript-language-server
    nil

    # formatters
    nixfmt-rfc-style
    stylua
    biome
  ];

}
