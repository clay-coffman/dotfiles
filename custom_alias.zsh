# aliases
alias v="nvim"
alias c="clear"
alias zshrc="nvim ~/.zshrc"
alias aliases="vim ~/.oh-my-zsh/custom/custom_alias.zsh" 
alias pgconfig="vim ~/.config/pgcli/config"
alias pt="papertrail"
alias corelogs="papertrail -s core-api"
alias stagecorelogs="papertrail -s core-stage-api"
alias hogs="top -o -cpu"
alias vimconfig="nvim /Users/claycoffman/.dotfiles/config/nvim"
alias mux="tmuxinator"

# run zsh-autosuggestions asyncronously
ZSH_AUTOSUGGEST_USE_ASYNC=1

# FZF
# fh - search in your command history and execute selected command
fh() {
  print -z $( ([ -n "$ZSH_NAME" ] && fc -l 1 || history) | fzf +s --tac --height 40% | sed 's/ *[0-9]* *//')
}

# fd - cd to selected directory
fd() {
  local dir
  dir=$(find ${1:-.} -path '*/\.*' -prune \
                  -o -type d -print 2> /dev/null | fzf +m) &&
  cd "$dir"
}

# find and open a file (see below)
# Modified version where you can press
#   - CTRL-O to open with `open` command,
#   - CTRL-E or Enter key to open with the $EDITOR
fo() {
  local out file key
  IFS=$'\n' out=($(fzf-tmux --query="$1" --exit-0 --expect=ctrl-o,ctrl-e))
  key=$(head -1 <<< "$out")
  file=$(head -2 <<< "$out" | tail -1)
  if [ -n "$file" ]; then
    [ "$key" = ctrl-o ] && open "$file" || ${EDITOR:-vim} "$file"
  fi
}

# quickly change to new iterm profile
alias display() { echo -e "\033]50;SetProfile=$1\a" }
