""" vim-go

let g:go_def_mode         = 'gopls'
let g:go_info_mode        = 'gopls'
let g:go_def_reuse_buffer = 1
let g:go_doc_popup_window = 1
let g:godef_split         = 2

" 设置语法高亮
let g:go_highlight_array_whitespace_error = 1   " heighlight white space after []
let g:go_highlight_functions  = 1
let g:go_highlight_types      = 1


let g:go_debug_preserve_layout = 1
let g:go_debug_windows = {
    \ 'vars':       'leftabove 50vnew',
    \ 'stack':      'leftabove 20new',
    \ 'goroutines': 'botright 10new',
    \ 'out':        'botright 5new',
    \ }

let g:go_debug_mappings = {
    \ '(go-debug-breakpoint)' : {'key': 'b'},
    \ '(go-debug-continue)'   : {'key': 'c', 'arguments': '<nowait>'},
    \ '(go-debug-print)'      : {'key': 'p'},
    \ '(go-debug-stop)'       : {'key': 'q'},
    \ '(go-debug-next)'       : {'key': 'n', 'arguments': '<nowait>'},
    \ '(go-debug-step)'       : {'key': 's'},
  \}
