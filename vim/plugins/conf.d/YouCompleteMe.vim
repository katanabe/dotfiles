" YCM

let g:ycm_global_ycm_extra_conf='~/dotfiles/_ycm_extra_conf.py'
let g:ycm_filetype_whitelist = {
            \ 'cpp' : 1,
            \ 'javascript' : 1,
            \ 'go' : 1
            \ }
let g:ycm_filetype_blacklist = {
            \ 'unite' : 1,
            \ 'vimfiler' : 1,
            \ }
let g:ycm_extra_conf_globlist = [
            \ '~/.ycm_extra_conf.py',
            \ ]
let g:ycm_semantic_triggers =  {
            \   'c' : ['->', '.'],
            \   'objc' : ['->', '.'],
            \   'cpp,objcpp' : ['->', '.', '::'],
            \   'perl' : ['->'],
            \   'php' : ['->', '::'],
            \   'cs,java,javascript,d,vim,ruby,python,perl6,scala,vb,elixir,go' : ['.'],
            \   'lua' : ['.', ':'],
            \   'erlang' : [':'],
            \ }
let g:ycm_server_keep_logfiles = 1

