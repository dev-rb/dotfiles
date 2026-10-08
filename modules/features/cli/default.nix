{ mkFeature, ... }:
mkFeature {
  name = "cli";
  homeManager = { pkgs, ... }: {
    home.packages = with pkgs; [
      fd
      fzf
      gdu
      gh
      jless
      ripgrep
      wget
      jq
      btop
      parallel
    ];
    programs.bat.enable = true;
    programs.eza = {
      enable = true;
      icons = "auto";
      git = true;
      extraOptions = [ "--group-directories-first" ];
    };
    programs.zoxide = {
      enable = true;
      enableZshIntegration = true;
    };
    programs.yazi = {
      enable = true;
      enableZshIntegration = true;
      settings.preview = {
        max_width = 10000;
        max_height = 10000;
      };
    };
  };
}
