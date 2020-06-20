" #PLUGINS {{{
call plug#begin('~/.local/share/nvim/plugged')

" Markdown

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

" Autocompletion & Intellisense
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Utilities
Plug 'preservim/nerdtree'
Plug 'antoinemadec/coc-fzf'
Plug 'jlanzarotta/bufexplorer'
Plug 'tpope/vim-surround'
Plug 'miyakogi/conoline.vim'
Plug 'tpope/vim-commentary'
Plug 'mileszs/ack.vim'
Plug 'morhetz/gruvbox'
Plug 'shinchu/lightline-gruvbox.vim'
Plug 'tpope/vim-obsession'
Plug 'ludovicchabant/vim-gutentags'
Plug 'jremmen/vim-ripgrep'
Plug 'majutsushi/tagbar'
call plug#end()
"}}}'
