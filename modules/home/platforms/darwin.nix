{ lib, ... }:
{
  # Do not append to Home Manager's managed .zprofile during shell startup.
  programs.zsh.envExtra = lib.mkBefore ''
    if [[ -x /opt/homebrew/bin/brew ]]; then
      eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [[ -x /usr/local/bin/brew ]]; then
      eval "$(/usr/local/bin/brew shellenv)"
    fi
  '';
  home.sessionPath = [ "/Applications/WezTerm.app/Contents/MacOS" ];
}
