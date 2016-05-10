" Vim plugin to diff two lines of a buffer and navigate through the changes
" File:     compare-lines.vim
" Author:   statox
" License:  This file is distributed under the MIT License

" Create the commands
command! -nargs=* CL call <SID>CompareLines(<f-args>)
command! -nargs=* FL call <SID>FocusLines(<f-args>)
command! -nargs=* FCL call <SID>CompareLines(<f-args>)|call <SID>FocusLines(<f-args>)

" Get two different lines and put the differences in the search register
function! s:CompareLines(...)

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

" Creates foldings to focus on two lines
function! s:FocusLines(...)

    if len(a:000) == 0
        let l1=line(".")
        let l2=line(".")+1
    elseif len(a:000) == 1
        let l1 =line(".")
        let l2 =str2nr(a:1)
    elseif len(a:000) == 2
        let l1 = str2nr(a:1)
        let l2 = str2nr(a:2)
    else
        echom "Bad number of arguments"
        return
    endif

    " Sort the lines
    if ( l1 > l2 )
        let temp = l2
        let l2 = l1
        let l1 = temp
    endif

    " Check that the lines are in the buffer
    if (l1 < 1 || l1 > line("$") || l2 < 1 || l2 > line("$"))
        echom ("A selected line is not in the buffer")
        return
    endif

    if (l1 > 1)
        execute "1, " . ( l1 - 1 ) . "fold"
    endif

    if ( l1 != l2 )
        execute (l1 + 1) . "," . (l2 - 1) . "fold"
    endif

    if (l2 < line('$'))
        execute (l2 + 1) . ",$fold"
    endif
endfunction
