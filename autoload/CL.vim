" Get two different lines and put the differences in the search register
function! CL#CompareLines(l1, l2)
    let l1 = a:l1
    let l2 = a:l2

    " Get the content of the lines
    let line1 = getline(l1)
    let line2 = getline(l2)

    let pattern = ""

    " Compare lines and create pattern of diff
    for i in range(strlen(line1))
        if strpart(line1, i, 1) !=# strpart(line2, i, 1)
            if pattern != ""
                let pattern = pattern . "\\|"
            endif
            let pattern = pattern . "\\%" . l1 . "l" . "\\%" . ( i+1 ) . "c"
            let pattern = pattern . "\\|" . "\\%" . l2 . "l" . "\\%" . ( i+1 ) . "c"
        endif
    endfor

    " Search and highlight the diff
    if strlen(pattern) > 0
        execute "let @/='" . pattern . "'"
        set hlsearch
        normal! n
    endif
endfunction

" Creates foldings to focus on two lines
function! CL#FocusLines(l1, l2)
    let l1 = a:l1
    let l2 = a:l2

    if (l1 > 1)
        execute "1, " . ( l1 - 1 ) . "fold"
    endif

    if ( l2-l1 > 2 )
        execute (l1 + 1) . "," . (l2 - 1) . "fold"
    endif

    if (l2 < line('$'))
        execute (l2 + 1) . ",$fold"
    endif
endfunction
