" let g:ale_linters = {
"     \ 'python': [
"     \    'pylint'
"     \    ]
"     \ }
" 
" let g:ale_fixers = {
"     \ 'python': [
"         \ 'remove_trailing_lines',
"         \ 'isort',
"         \ 'black'
"   \     ]
"   \ }
" 
" let g:ale_python_black_options = '--line-length 80'
" 
" "
" "can't get this to work, won't load plugins...
" let g:ale_python_pylint_options = '--load-plugins pylint_flask_sqlalchemy'
