" Vim plugin to diff two lines of a buffer and navigate through the changes
" File:     compare-lines.vim
" Author:   statox
" License:  This file is distributed under the MIT License

" Create the command allowing to call the function
command! -nargs=* CL call CompareLines(<f-args>)

" Get two different lines and put the differences in the search register
function! CompareLines(...)

    " Check the number of arguments
    " And get lines numbers
    if len(a:000) == 0
        let l1=line(".")
        let l2=line(".")+1
    elseif len(a:000) == 1
        let l1 =line(".")
        let l2 =a:1
    elseif len(a:000) == 2
        let l1 = a:1
        let l2 = a:2
    else
        echom "Bad number of arguments"
        return
    endif

    " Check that the lines are in the buffer
    if (l1 < 1 || l1 > line("$") || l2 < 1 || l2 > line("$"))
        echom ("A selected line is not in the buffer")
        return
    endif

    " Get the content of the lines
    let line1 = getline(l1)
    let line2 = getline(l2)

    let pattern = ""

    " Compare lines and create pattern of diff
    for i in range(strlen(line1))
        if strpart(line1, i, 1) != strpart(line2, i, 1)
            if pattern != ""
                let pattern = pattern . "\\|"
            endif
            let pattern = pattern . "\\%" . l1 . "l" . "\\%" . ( i+1 ) . "c"
            let pattern = pattern . "\\|" . "\\%" . l2 . "l" . "\\%" . ( i+1 ) . "c"
        endif
    endfor

    " Search and highlight the diff
    execute "let @/='" . pattern . "'"
    set hlsearch
    normal n
endfunction

