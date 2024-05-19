# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

setopt prompt_subst
export PATH=~/.local/bin:$PATH
export PATH=$PATH:/opt/gradle/gradle-8.2.1/bin
export JAVA_HOME=/usr/lib/jvm/jdk-20.0.2
export PATH=$PATH:$JAVA_HOME/bin
export PATH=$PATH:/mnt/e/WezTerm/wezterm.exe

export ZSH=$HOME/dotfiles/.zsh

# pnpm
export PNPM_HOME="/home/dev-rb/.local/share/pnpm"
export PATH="$PNPM_HOME:$PATH"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export PATH=$PATH:/usr/local/go/bin

LS_COLORS=$LS_COLORS:'ow=1;34:' ; export LS_COLORS 

# Uncomment the following line to disable colors in ls.
DISABLE_LS_COLORS="true"

### ---- history config -------------------------------------
export HISTFILE=$ZSH/.zsh_history

# How many commands zsh will load to memory.
export HISTSIZE=10000

# How many commands history will save on file.
export SAVEHIST=10000

# History won't save duplicates.
setopt HIST_IGNORE_ALL_DUPS

# History won't show duplicates on search.
setopt HIST_FIND_NO_DUPS

### ---- PLUGINS & THEMES -----------------------------------
#
# source $ZSH/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
source $ZSH/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source $ZSH/plugins/docker/docker.plugin.zsh
fpath=($ZSH/plugins/zsh-completions/src $fpath)

autoload -U compinit; compinit
alias wezterm='wezterm.exe'
alias zshconfig="nvim ~.zsh/.zshrc"

eval "$(zoxide init zsh)"

source ~/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
