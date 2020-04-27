" #PLUGINS {{{
call plug#begin('~/.local/share/nvim/plugged')

" Markdown
Plug 'reedes/vim-pencil'
Plug 'nelstrom/vim-markdown-folding'

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
Plug 'SirVer/ultisnips'
Plug 'nvie/vim-flake8'
Plug 'honza/vim-snippets'

" Syntax Highlighting
Plug 'sheerun/vim-polyglot'
Plug 'othree/html5.vim'

" Utilities
Plug 'preservim/nerdtree'
Plug 'jlanzarotta/bufexplorer'
Plug 'terryma/vim-multiple-cursors'
Plug 'maxbrunsfeld/vim-yankstack'
Plug 'airblade/vim-rooter'
Plug 'tpope/vim-surround'
Plug 'moll/vim-bbye'
Plug 'miyakogi/conoline.vim'
Plug 'ervandew/supertab'
Plug 'szw/vim-maximizer'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-repeat'
Plug 'jiangmiao/auto-pairs'
Plug 'godlygeek/tabular'
Plug 'tpope/vim-unimpaired'
Plug 'mileszs/ack.vim'
Plug 'morhetz/gruvbox'
Plug 'shinchu/lightline-gruvbox.vim'
Plug 'maximbaz/lightline-ale'
Plug 'tpope/vim-vinegar'
Plug 'tpope/vim-obsession'
Plug 'gcmt/taboo.vim'
Plug 'luochen1990/rainbow'
Plug 'ludovicchabant/vim-gutentags'
Plug 'TaDaa/vimade'
Plug 'ap/vim-css-color'
Plug 'dense-analysis/ale'
Plug 'editorconfig/editorconfig-vim'
Plug 'htacg/tidy-html5'
Plug 'majutsushi/tagbar'
call plug#end()
"}}}'
