" ===================================================================
"   Neovim Basic init.vim
"   (Place this file at ~/.config/nvim/init.vim)
" ===================================================================

" -----------------------
"  Plugin Manager (vim-plug)
" -----------------------
" Ensure you've installed vim-plug for Neovim:
"   curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
"       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

call plug#begin('~/.local/share/nvim/plugged')
  " Gruvbox colorscheme
  Plug 'dracula/vim', { 'as': 'dracula' }
  Plug 'nathanaelkane/vim-indent-guides' " Indent lines
  Plug 'nvim-lua/plenary.nvim'
  Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.8' }
  Plug 'nvim-telescope/telescope-file-browser.nvim'
  Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
  Plug 'scrooloose/nerdtree'
  Plug 'tpope/vim-surround'
  Plug 'tpope/vim-commentary'
  Plug 'christoomey/vim-tmux-navigator'
  Plug 'preservim/nerdtree' |
            \ Plug 'Xuyuanp/nerdtree-git-plugin' |
            \ Plug 'ryanoasis/vim-devicons'
  Plug 'neoclide/coc.nvim', {'branch': 'release'}
  Plug 'preservim/tagbar'
  Plug 'tpope/vim-dispatch'
call plug#end()

" -----------------------
"  UI & Behavior Settings
" -----------------------
syntax on
set number               " Show line numbers
set relativenumber       " Relative line numbers
set mouse=a              " Enable mouse support
set clipboard=unnamedplus " Use system clipboard
set tabstop=4            " Show existing tab with 4 spaces width
set shiftwidth=4         " When indenting with '>', use 4 spaces
set expandtab            " Use spaces instead of tabs
set background=dark      " Set background for Gruvbox
let mapleader = ","      " Map leader to ,
set ignorecase           " make search case-insensitive
set smartcase            " override ignorecase if search contains uppercase letters

" Toggle search highlighting with <Leader>h
nnoremap <leader>h :nohlsearch<CR>

" leader bd closes current buffer
nnoremap <leader>bd :bd<CR>

" Other settings
" Always show sign column to prevent text shifting
set signcolumn=yes

"reduce update time for better responsiveness
set updatetime=300

" -----------------------
"  Colorscheme
" -----------------------
set background=dark
colorscheme dracula

" Optional Gruvbox customizations
" let g:gruvbox_contrast_dark = "hard"
" let g:gruvbox_invert_selection = 0

" -----------------------
"  Additional Mappings or Settings
" -----------------------
" Map ,w to save the current file
nnoremap <leader>w :w<CR>

" command to quickly edit .init.vim/config file
command! Config edit $MYVIMRC

" nnoremap <leader>ff :Telescope find_files<CR>
" nnoremap <leader>fg :Telescope live_grep<CR>
" (Uncomment lines above after installing 'nvim-telescope/telescope.nvim', etc.)

" -----------------------
"  Plugin Configs   
" -----------------------
" indent-guides
let g:indent_guides_enable_on_vim_startup = 1

" -----------------------
" Telescope
" -----------------------
" Telescope
" Find files using Telescope command-line sugar.
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>

" -----------------------
" NERDTree
" -----------------------
" NERDTree
nnoremap <leader>e :NERDTree<CR>
nnoremap <C-t> :NERDTreeToggle<CR>
nnoremap <C-f> :NERDTreeFind<CR>

" set NERDTree window size
let g:NERDTreeWinSize = 24

" show dotfiles
let NERDTreeShowHidden=1

" Start NERDTree. If a file is specified, move the cursor to its window.
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * NERDTree | if argc() > 0 || exists("s:std_in") | wincmd p | endif

" Exit Vim if NERDTree is the only window remaining in the only tab.
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif

let g:NERDTreeGitStatusUseNerdFonts = 1 " you should install nerdfonts by yourself. default: 

" -----------------------
" Tagbar
" -----------------------
" Tagbar
" Open NERDTree on the left and Tagbar on the right
autocmd VimEnter * NERDTree | wincmd p | TagbarOpen

" Toggle tagbar
nnoremap <leader>T :TagbarToggle<CR>

" set Tagbar window size
let g:tagbar_width=20


" -----------------------
" vim-dispatch
" -----------------------
" Compile and run the current C++ file using clang++
nnoremap <leader>cr :Dispatch clang++ -std=c++17 -Wall % -o %< && chmod +x %< && ./%<<CR>

" -----------------------
" COC Config
" -----------------------
" disable backup files for coc.nvim compatibility
set nobackup
set nowritebackup

" Function to check if the cursor is at the beginning of the line or preceded by whitespace
function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Customize keybindings for completion navigation and selection

" Navigate completion menu with c-J and c-K 
inoremap <silent><expr> <C-j> coc#pum#visible() ? coc#pum#next(1) :"\<C-j>"
inoremap <silent><expr> <C-k> coc#pum#visible() ? coc#pum#prev(1) :"\<C-k>"

" Use Tab to confirm the selected completion item
inoremap <silent><expr> <Tab>
      \ coc#pum#visible() ? coc#pum#confirm() :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()

" Use Shift-Tab to navigate completion menu backwards
inoremap <silent><expr> <S-Tab>
      \ coc#pum#visible() ? coc#pum#prev(1) :
      \ "\<C-h>"

" Accept selected completion item or insert a newline
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
            \ : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" Trigger completion with <C-Space>
if has('nvim')
  inoremap <silent><expr> <C-Space> coc#refresh()
else
  inoremap <silent><expr> <C-@> coc#refresh()
endif

" Navigate diagnostics with [g and ]g
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" Code navigation mappings
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Show documentation with K
nnoremap <silent> K :call ShowDocumentation()<CR>

function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

" Highlight symbol references on cursor hold
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

" Auto-format for specific filetypes and signature help
augroup mygroup
  autocmd!
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Code actions mappings
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

nmap <leader>ac  <Plug>(coc-codeaction-cursor)
nmap <leader>as  <Plug>(coc-codeaction-source)
nmap <leader>qf  <Plug>(coc-fix-current)

" Refactor code actions
nmap <silent> <leader>re <Plug>(coc-codeaction-refactor)
xmap <silent> <leader>r  <Plug>(coc-codeaction-refactor-selected)
nmap <silent> <leader>r  <Plug>(coc-codeaction-refactor-selected)

" Run Code Lens action
nmap <leader>cl  <Plug>(coc-codelens-action)

" Text objects for functions and classes
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Scroll float windows/popups with <C-f> and <C-b>
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

" Selection ranges with <C-s>
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Commands for formatting and organizing imports
command! -nargs=0 Format :call CocActionAsync('format')
command! -nargs=? Fold :call CocAction('fold', <f-args>)
command! -nargs=0 OR   :call CocActionAsync('runCommand', 'editor.action.organizeImport')

" Native statusline support
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Mappings for CoCList
nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>


