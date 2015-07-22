" UltiSnips
let g:UltiSnipsExpandTrigger="<c-k>"
let g:UltiSnipsJumpForwardTrigger="<c-k>"
let g:UltiSnipsJumpBackwardTrigger="<c-j>"

let g:UltiSnipsEditSplit="horizontal"
let g:UltiSnipsUsePythonVersion = 2

nnoremap <silent> <leader>nsp :<C-u>UltiSnipsEdit<CR>

let local_snippets_dir = $HOME.'/.vim/snips'
if !isdirectory(local_snippets_dir)
  call mkdir(local_snippets_dir, "p")
endif
let g:UltiSnipsSnippetsDir = local_snippets_dir
let g:UltiSnipsSnippetDirectories=["snips"]
