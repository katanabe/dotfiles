" syntastic
" ファイルの構文エラーを確認してくれるプラグイン
let g:syntastic_mode_map = { 'mode': 'passive',
            \ 'active_filetypes': ['ruby', 'javascript', 'python', 'perl'],
            \ 'passive_filetypes': [] }
let g:syntastic_ruby_checkers = ['mri', 'rubocop']
let g:syntastic_cpp_compiler = 'clang++'
let g:syntastic_cpp_compiler_options = ' -std=c++11 -stdlib=libc++'

