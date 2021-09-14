# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block, everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# PATH Stuff
# Add commonly used folders to PATH
export PATH="/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"

# brew installed ruby path
export RUBY_HOME="/usr/local/opt/ruby/bin"

# add rust path
export PATH="$HOME/.cargo/bin:$PATH"

# add solana path
export PATH="/Users/claycoffman/.local/share/solana/install/active_release/bin:$PATH"

# set terminfo path
export TERMINFO=/usr/share/terminfo/

# gems loc
export GEM_PATH="/usr/local/opt/ruby/lib/ruby/gems/2.7.0"
export GEM_HOME=$GEM_PATH
export PATH="$RUBY_HOME:$GEM_HOME/bin:$HOME:$PATH"

# Set editor vars
export VISUAL=nvim
export EDITOR=$VISUAL

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Path to tidyrc config files
export HTML_TIDY="$HOME/.tidyrc"

export PATH="$HOME/.pyenv/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

# add $USER bin to path
export PATH="$HOME/bin:$PATH"

# add .local/ to path
export PATH="$HOME/.local/bin:$PATH"

# Needed for pyenv to find openssl
export CFLAGS="-I$(brew --prefix openssl)/include" 
export LDFLAGS="-L$(brew --prefix openssl)/lib" 

# Needed to compile python >== 3.6.8 for some reason?
export LDFLAGS="-L/usr/local/opt/zlib/lib -L/usr/local/opt/bzip2/lib"
export CPPFLAGS="-I/usr/local/opt/zlib/include -I/usr/local/opt/bzip2/include"

# Some stuff for Gamestonk terminal app
# Alphavantage key
export GT_API_KEY_ALPHAVANTAGE="QVFKRSD7024MRNSF"

# Financialmodelingprep.com
export GT_API_KEY_FINANCIALMODELINGPREP="6541143dc28625f88dc912a051e497f6"

# Quandl
export GT_API_KEY_QUANDL="XUaxJszsfJWaLJZcyK43"

# Reddit
# export GT_API_REDDIT_CLIENT_ID="IzJCk4Yj1lAxRA"
# export GT_API_REDDIT_CLIENT_SECRET="kHV0DfCFoUKHRol2wTLdUIA4kXMjrA"
# export GT_API_REDDIT_USERNAME="clayc210"
# export GT_API_REDDIT_PASSWORD="2vG$@RTUT7"
# export GT_API_REDDIT_USER_AGENT="stonk-scraper-script by /u/clayc210"
# 
# Twitter
# export GT_API_TWITTER_KEY="6u8OAYWosiKjRouOPfVQOOeyT"
# export GT_API_TWITTER_SECRET_KEY="4y94vdM3avGjvHItP6r3xl4QjupJXx1hmnOdnEggJUN1Zp1Rde"
# export GT_API_TWITTER_BEARER_TOKEN="AAAAAAAAAAAAAAAAAAAAABqRNQEAAAAAhJMpKsqy9k%2F4xBeGK3RjWCA685w%3DICVzTA5Mp7De73rt2mpHsdIb3nL0RfZmwjKfHsAUTbQBM3Nxb9"

# need this for --user-install gems to find .gem/bin
if which ruby >/dev/null && which gem >/dev/null; then
    PATH="$(ruby -r rubygems -e 'puts Gem.user_dir')/bin:$PATH"
fi

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME=powerlevel10k/powerlevel10k

# Something for autojump
[ -f /usr/local/etc/profile.d/autojump.sh ] && . /usr/local/etc/profile.d/autojump.sh

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in ~/.oh-my-zsh/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git vi-mode nvm zsh-autosuggestions zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

# exports

# Set custom aliases in $ZSH/custom/custom_alias.zsh
# For a full list of active aliases, run `alias`.

# POWERLINE CONFIG
POWERLEVEL9K_MODE="nerdfont-complete"

# Please only use this battery segment if you have material icons in your nerd font (or font)
# Otherwise, use the font awesome one in "User Segments"
POWERLEVEL9K_PROMPT_ON_NEWLINE=true
POWERLEVEL9K_PROMPT_ADD_NEWLINE=true
POWERLEVEL9K_RPROMPT_ON_NEWLINE=true
POWERLEVEL9K_SHORTEN_DIR_LENGTH=2
POWERLEVEL9K_SHORTEN_STRATEGY="truncate_beginning"
POWERLEVEL9K_STATUS_VERBOSE=false
POWERLEVEL9K_VCS_CLEAN_FOREGROUND='black'
POWERLEVEL9K_VCS_CLEAN_BACKGROUND='green'
POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND='black'
POWERLEVEL9K_VCS_UNTRACKED_BACKGROUND='yellow'
POWERLEVEL9K_VCS_MODIFIED_FOREGROUND='white'
POWERLEVEL9K_VCS_MODIFIED_BACKGROUND='black'
POWERLEVEL9K_COMMAND_EXECUTION_TIME_BACKGROUND='black'
POWERLEVEL9K_COMMAND_EXECUTION_TIME_FOREGROUND='blue'
POWERLEVEL9K_FOLDER_ICON=''
POWERLEVEL9K_STATUS_OK_IN_NON_VERBOSE=true
POWERLEVEL9K_STATUS_VERBOSE=false
POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD=0
POWERLEVEL9K_VCS_UNTRACKED_ICON='\u25CF'
POWERLEVEL9K_VCS_UNSTAGED_ICON='\u00b1'
POWERLEVEL9K_VCS_INCOMING_CHANGES_ICON='\u2193'
POWERLEVEL9K_VCS_OUTGOING_CHANGES_ICON='\u2191'
POWERLEVEL9K_VCS_COMMIT_ICON="\uf417"
POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX="%F{blue}\u256D\u2500%f"
POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX="%F{blue}\u2570\uf460%f "
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(vi_mode context os_icon ssh dir dir_writable vcs)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(command_execution_time status)
HIST_STAMPS="mm/dd/yyyy"
DISABLE_UPDATE_PROMPT=true


[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# workaround for slow pasting (char by char)
### Fix slowness of pastes with zsh-syntax-highlighting.zsh
pasteinit() {
  OLD_SELF_INSERT=${${(s.:.)widgets[self-insert]}[2,3]}
  zle -N self-insert url-quote-magic # I wonder if you'd need `.url-quote-magic`?
}

pastefinish() {
  zle -N self-insert $OLD_SELF_INSERT
}
zstyle :bracketed-paste-magic paste-init pasteinit
zstyle :bracketed-paste-magic paste-finish pastefinish
