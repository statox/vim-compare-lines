" Vim plugin to diff two lines of a buffer and navigate through the changes
" File:     compare-lines.vim
" Author:   statox
" License:  This file is distributed under the MIT License

" Create the commands
command! -nargs=* CL call <SID>PreTreatmentFunction("Compare", <f-args>)
command! -nargs=* FL call <SID>PreTreatmentFunction("Focus", <f-args>)
command! -nargs=* FCL call <SID>PreTreatmentFunction("CompareFocus", <f-args>)
command! XL call <SID>RestoreAfterCompare()

" This function is called to
" - get the line numbers
" - check their existence in the buffer
" - save the foldmethod
" - create the mappings of the plugin
function! s:PreTreatmentFunction(function, ...)
    " Depending on the number of arguments define which lines to treat
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

    " Handle foldmethod configuration
    let s:foldmethod_save=&foldmethod
    set foldmethod=manual

    " Create a mapping to quit the compare mode
    if !empty(maparg('<C-c>', 'n')) 
        let s:mapping_save = maparg('<C-c>', 'n', 0, 1)
    endif
    nunmap <C-c> 
    nnoremap <C-c> :XL<CR>

    " Depending on the command used call the corresponding function
    if a:function == "Compare"
        call <SID>CompareLines(l1, l2)
    elseif a:function == "Focus"
        call <SID>FocusLines(l1, l2)
    elseif a:function == "CompareFocus"
        call <SID>CompareLines(l1, l2)
        call <SID>FocusLines(l1, l2)
    else
        echoe "Unkown function call"
        return
    endif
endfunction

function! s:RestoreAfterCompare()
    " Remove foldings created
    normal! zE
    " Remove search highlight
    set nohlsearch
    " Remove the mapping
    unmap <C-c>
    " Restore the mapping to its previous value
    if exists("s:mapping_save")
        execute (s:mapping_save.noremap ? 'nnoremap ' : 'nmap ') .
             \ (s:mapping_save.buffer ? ' <buffer> ' : '') .
             \ (s:mapping_save.expr ? ' <expr> ' : '') .
             \ (s:mapping_save.nowait ? ' <nowait> ' : '') .
             \ (s:mapping_save.silent ? ' <silent> ' : '') .
             \ s:mapping_save.lhs . " "
             \ s:mapping_save.rhs
    endif
    " Restore fold method
    let &foldmethod=s:foldmethod_save
endfunction

" Get two different lines and put the differences in the search register
function! s:CompareLines(l1, l2)
    let l1 = a:l1
    let l2 = a:l2

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
function! s:FocusLines(l1, l2)
    let l1 = a:l1
    let l2 = a:l2

    echom "focus l1, l2:" . l1 . "," . l2

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
