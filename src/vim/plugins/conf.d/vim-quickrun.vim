" vim-quickrun
nmap <Leader>r <plug>(quickrun)
let g:quickrun_config = {}
let g:quickrun_config.perl = {'command': 'perl', 'cmdopt': '-MProject::Libs'}
let g:quickrun_config['ruby.rspec'] = {'command' : 'rspec'}
let g:quickrun_config.go = {
            \ 'command': 'go',
            \ 'exec': '%c run %s:p:t %a',
            \ 'tempfile': '%{tempname()}.go',
            \ 'hook/output_encode/encoding': 'utf-8',
            \ 'hook/cd/directory': '%S:p:h'}
let g:quickrun_config.cpp = {
            \ 'command' : 'clang++',
            \ 'cmdopt' : '-std=c++11 -stdlib=libc++'
            \ }

