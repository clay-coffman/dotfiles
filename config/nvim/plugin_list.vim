" #PLUGINS {{{
call plug#begin('~/.local/share/nvim/plugged')

" Git
Plug 'tpope/vim-fugitive'
Plug 'rhysd/git-messenger.vim'
Plug 'airblade/vim-gitgutter'

" Fuzzy Search
Plug 'junegunn/fzf', { 'do': './install --bin' }
Plug 'junegunn/fzf.vim'

" Appearance and Themes
Plug 'sainnhe/gruvbox-material'
Plug 'itchyny/lightline.vim'
Plug 'drewtempelmeyer/palenight.vim'
Plug 'doums/darcula'
Plug 'arcticicestudio/nord-vim'
Plug 'yggdroot/indentline'

" Autocompletion & Intellisense
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Folding
Plug 'tmhedberg/simpylfold'

" Utilities
Plug 'preservim/nerdtree'
Plug 'antoinemadec/coc-fzf'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'mileszs/ack.vim'
Plug 'morhetz/gruvbox'
Plug 'shinchu/lightline-gruvbox.vim'
Plug 'ludovicchabant/vim-gutentags'
Plug 'jremmen/vim-ripgrep'
Plug 'majutsushi/tagbar'
call plug#end()
"}}}'
