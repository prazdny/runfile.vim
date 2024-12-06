let g:run_cmd = ''

function! RunFile(cmd, options = {})
    let stay = get(a:options, 'stay', 0)

    " Prevent this function from running in terminal windows
    if &buftype == 'terminal'
        return
    endif

    " Get the directory of the current file
    let dir = expand('%:p:h')

    " Get the filename
    let filename = expand('%:t')

    " Execute the command in the specified directory
    execute 'term sh -c "cd ' . dir . ' && ' . substitute(a:cmd, '%', filename, '') . '"'

    " Map q to close the output buffer
    nnoremap <silent> <buffer> q <C-\><C-n>:bd!<cr>

    " If stay is true, keep the original buffer focused
    if stay
        wincmd p
    endif
endfunction

" Mappings
if exists('g:run_cmd')
    nnoremap <silent> <F11> :call RunFile(g:run_cmd, { 'stay': 0 })<cr>
    nnoremap <silent> <F12> :call RunFile(g:run_cmd, { 'stay': 1 })<cr>
endif

" Filetype command definitions
augroup RunFileCmds
    autocmd!

    autocmd FileType c let g:run_cmd = 'gcc % && ./a.out ; rm -f ./a.out'
    autocmd FileType go let g:run_cmd = 'go run %'
    autocmd FileType perl let g:run_cmd = 'python %'
    autocmd FileType php let g:run_cmd = 'php %'
    autocmd FileType python let g:run_cmd = 'python %'
    autocmd FileType ruby let g:run_cmd = 'ruby %'
    autocmd FileType tcl let g:run_cmd = 'tclsh %'
augroup END
