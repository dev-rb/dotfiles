# zmodload zsh/zprof
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

### zinit

ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

if [ ! -d "$ZINIT_HOME" ]; then
  mkdir -p "$(dirname $ZINIT_HOME)"
  git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

source "${ZINIT_HOME}/zinit.zsh"

setopt prompt_subst

### path
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games
export PATH=$PATH:/usr/bin
export PATH=$PATH:/usr/bin/npm
export PATH=$PATH:~/.local/bin
export PATH=$PATH:/mnt/e/WezTerm/wezterm.exe
# export PATH=$PATH:/opt/gradle/gradle-8.2.1/bin
export JAVA_HOME=/usr/lib/jvm/jdk-20.0.2
# export PATH=$PATH:$JAVA_HOME/bin
export PATH="$PATH:/mnt/c/Windows/System32"
export ZSH=$HOME/dotfiles/.zsh
export PATH="$PATH:/nix/var/nix/profiles/default/bin"

# pnpm
# export PNPM_HOME="/home/dev-rb/.local/share/pnpm"
# export PATH="$PNPM_HOME:$PATH"

# export NVM_DIR="$HOME/.nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# export PATH=$PATH:/usr/local/go/bin

LS_COLORS=$LS_COLORS:'ow=1;34:' ; export LS_COLORS 

# Uncomment the following line to disable colors in ls.
DISABLE_LS_COLORS="true"

### history

bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward

export HISTFILE=$ZSH/.zsh_history

# How many commands zsh will load to memory.
HISTSIZE=10000
# How many commands history will save on file.
SAVEHIST=$HISTSIZE
HISTDUP=erase

setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

### plugins

# powerlevel10k
zinit light romkatv/powerlevel10k

zinit ice depth=1 wait lucid

zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

autoload -Uz compinit

for dump in ~/.zcompdump(N.mh+24); do
  compinit
done
compinit -C

zinit cdreplay -q


zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':completion:*:*:git:*' script ~/dotfiles/.zsh/plugins/git-completion.bash
fpath=(~/dotfiles/.zsh/plugins $fpath)

### alias

alias ls="eza --icons=always"
# alias ls="ls --color"
alias wezterm='wezterm.exe'
alias zshconfig="nvim ~/dotfiles/.zsh/.zshrc"
alias cat="bat"

# zoxide
eval "$(zoxide init zsh)"


# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
eval "$(fzf --zsh)"


# fnm
export PATH="/home/dev-rb/.local/share/fnm:$PATH"
eval "`fnm env`"

. "$HOME/.cargo/env"

# pnpm
export PNPM_HOME="/home/dev-rb/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

source ~/wezterm.sh

source ~/.nix-profile/etc/profile.d/hm-session-vars.sh
# Nix
if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
  . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
fi
# End Nix

# pnpm end
# zprof
