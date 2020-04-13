let g:ale_linters = {
    \ 'python': [
        \ 'flake8'
  \     ]
  \ }

let g:ale_fixers = {
    \ 'python': [
        \ 'remove_trailing_lines',
        \ 'isort',
        \ 'black'
  \     ]
  \ }

let g:ale_python_black_options = '--line-length 80'
