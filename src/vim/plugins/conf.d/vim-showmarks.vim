let g:showmarks_marks_notime = 1
let g:unite_source_mark_marks = '01abcABCDEFGHIJKLNMOPQRSTUVWXYZ'
let g:showmarks_enable       = 1
if !exists('g:markrement_char')
    let g:markrement_char = [
    \     'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M',
    \     'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z',
    \     'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm',
    \     'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z'
    \ ]
en

fu! s:AutoMarkrement()
    if !exists('b:markrement_pos')
        let b:markrement_pos = 0
    else
        let b:markrement_pos = (b:markrement_pos + 1) % len(g:markrement_char)
    en
    exe 'mark' g:markrement_char[b:markrement_pos]
    echo 'marked' g:markrement_char[b:markrement_pos]
endf

aug show-marks-sync
        au!
        au BufReadPost * sil! ShowMarksOnce
aug END

nn [Mark] <Nop>
nm <Space><Space> [Mark]

com! -bar MarksDelete sil :delm! | :delm 0-9A-Z | :wv! | :ShowMarksOnce

nn <silent>[Mark]d :MarksDelete<CR>
nn <silent>[Mark]l :ShowMarksOnce<CR>
nn <silent>[Mark]s :DoShowMarks<CR>
" }}}
