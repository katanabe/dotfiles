" powerline/lightline 
" vim-powerline がdeprecatedになったということで、lightlineに変更
" NeoBundle 'Lokaltog/vim-powerline', 'develop'
" let g:Powerline_symbols = 'fancy'
let g:lightline = {
      \ 'colorscheme': 'hybrid',
      \ 'component': {
      \   'readonly': '%{&filetype=="help"?"":&readonly?"⭤":""}',
      \   'modified': '%{&filetype=="help"?"":&modified?"+":&modifiable?"":"-"}'
      \ },
      \ 'separator': { 'left': '⮀', 'right': '⮂' },
      \ 'subseparator': { 'left': '⮁', 'right': '⮃' }
      \ }

