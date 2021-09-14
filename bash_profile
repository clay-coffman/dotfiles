# source .bashrc
if [ -f ~/.bashrc ]; then
   source ~/.bashrc
fi


test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"
. "$HOME/.cargo/env"
export PATH="/Users/claycoffman/.local/share/solana/install/active_release/bin:$PATH"
