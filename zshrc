# Add deno completions to search path
if [[ ":$FPATH:" != *":/Users/claycoffman/.zsh/completions:"* ]]; then export FPATH="/Users/claycoffman/.zsh/completions:$FPATH"; fi
# ============================== 
# Environment Variables
# ==============================

# Set the default language and locale
export LANG=en_US.UTF-8

# Set the default editor to Neovim
export EDITOR=nvim

# ==============================
# Path
# ==============================
#
export PATH="$HOME/bin:$HOME/.local/bin:/opt/homebrew/bin:/usr/local/bin:/opt/homebrew/opt/llvm/bin:$PATH"
export LDFLAGS="-L/opt/homebrew/opt/llvm/lib"
export CPPFLAGS="-I/opt/homebrew/opt/llvm/include"

# default path for prettierd config file
export PRETTIERD_DEFAULT_CONFIG="$HOME/.prettierrc.yaml"

# Load secrets from .zsh_secrets
if [ -f "$HOME/.zsh_secrets" ]; then
  source "$HOME/.zsh_secrets"
fi

# Add autojump path
[ -f /opt/homebrew/etc/profile.d/autojump.sh ] && . /opt/homebrew/etc/profile.d/autojump.sh

# ==============================
# Zim Configuration
# ==============================

# Zim Modules

# Disable automatic widget re-binding on each precmd. This can be set when
# zsh-users/zsh-autosuggestions is the last module in your ~/.zimrc.
ZSH_AUTOSUGGEST_MANUAL_REBIND=1

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#dc8a78,bold,underline"

ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)

#ZSH_HIGHLIGHT_STYLES[comment]='fg=242'

# ------------------
# Initialize modules
# ------------------

ZIM_HOME=${ZDOTDIR:-${HOME}}/.zim

# Download zimfw plugin manager if missing.
if [[ ! -e ${ZIM_HOME}/zimfw.zsh ]]; then
  if (( ${+commands[curl]} )); then
    curl -fsSL --create-dirs -o ${ZIM_HOME}/zimfw.zsh \
        https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh
  else
    mkdir -p ${ZIM_HOME} && wget -nv -O ${ZIM_HOME}/zimfw.zsh \
        https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh
  fi
fi

# Install missing modules, and update ${ZIM_HOME}/init.zsh if missing or outdated.
if [[ ! ${ZIM_HOME}/init.zsh -nt ${ZIM_CONFIG_FILE:-${ZDOTDIR:-${HOME}}/.zimrc} ]]; then
  source ${ZIM_HOME}/zimfw.zsh init -q
fi

# Initialize modules.
source ${ZIM_HOME}/init.zsh

# ------------------------------
# Post-init module configuration
# ------------------------------

# ==============================
# Custom Aliases and Functions
# ==============================

# Aliases for convenience
alias v="nvim"
alias c="clear"
alias mux="tmuxinator"

# view git diff in bat
batdiff() {
    git diff --name-only --relative --diff-filter=d | xargs bat --diff
}

# alias y to yazi
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}

# ==============================
# Additional Configurations
# ==============================
#
# Remove older command from the history if a duplicate is to be added.
setopt HIST_IGNORE_ALL_DUPS

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

#
# Input/output
#

# Set editor default keymap to emacs (`-e`) or vi (`-v`)
bindkey -v

# Remove path separator from WORDCHARS.
WORDCHARS=${WORDCHARS//[\/]}

# Enable command auto-correction
ENABLE_CORRECTION="true"

# Prompt for spelling correction of commands.
setopt CORRECT

# Customize spelling correction prompt.
SPROMPT='zsh: correct %F{red}%R%f to %F{green}%r%f [nyae]? '

# Enable extended globbing
setopt extended_glob

# Enable autocd (change directory by typing the directory name)
setopt auto_cd

# Enable history appending instead of overwriting
setopt append_history

# Share history across all sessions
setopt share_history

# STARSHIP
eval "$(starship init zsh)"

# UV shell completions
eval "$(uv generate-shell-completion zsh)"

# ==============================
# End of .zshrc
# ==============================
. "/Users/claycoffman/.deno/env"

# pnpm
export PNPM_HOME="/Users/claycoffman/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
export PATH="/opt/homebrew/opt/postgresql@16/bin:$PATH"
