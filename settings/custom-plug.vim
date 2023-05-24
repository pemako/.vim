""" 这里对引入的插件进行自定义设置

"" ale 插件相关设置
let g:ale_sh_shfmt_options = '-i 2 -ci'
let g:ale_fixers = {
		\ 'json' : ['prettier'],
		\ 'sh' : ['shfmt'],
		\ 'yaml' : ['prettier'],
		\ 'xml' : ['xmllint'],
		\ 'python': ['black', 'isort'],
		\ 'proto': ['protolint'],
		\ 'ruby' : ['brakeman'],
		\ 'go': ['goimports', 'gofmt'],
		\ 'js': ['eslint'],
		\}
nmap <Leader>; :ALEFix<CR>


"" fzf 插件相关配置
let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6, 'relative': v:true, 'yoffset': 1.0  }  }


"" nerdtree 插件相关配置
let NERDTreeIgnore = ['\.pyc$', '__pycache__']
let NERDTreeShowHidden=1
" https://github.com/preservim/nerdtree/issues/1321
" let g:NERDTreeMinimalMenu=1
" nerdtree-git-plugin 插件配置
let g:NERDTreeGitStatusIndicatorMapCustom = {
    \ "Modified"  : "✹",
    \ "Staged"    : "✚",
    \ "Untracked" : "✭",
    \ "Renamed"   : "➜",
    \ "Unmerged"  : "═",
    \ "Deleted"   : "✖",
    \ "Dirty"     : "✗",
    \ "Clean"     : "✔︎",
    \ 'Ignored'   : '☒',
    \ "Unknown"   : "?"
    \ }

nnoremap <leader>n :NERDTree<CR>


"" translator 插件设置
let g:translator_window_type        = 'popup' " popup & preview
let g:translator_window_max_width   = 0.6
let g:translator_window_max_height  = 0.6
let g:translator_history_enable     = v:false
"let g:translator_proxy_url = ''

"nmap <silent> <Leader>t <Plug>Translate
"vmap <silent> <Leader>t <Plug>TranslateV
nmap <silent> <Leader>t <Plug>TranslateW
vmap <silent> <Leader>t <Plug>TranslateWV
"nmap <silent> <Leader>r <Plug>TranslateR
"vmap <silent> <Leader>r <Plug>TranslateRV
"nmap <silent> <Leader>x <Plug>TranslateX


"" vim-go 插件设置
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
