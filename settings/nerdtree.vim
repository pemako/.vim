"" nerdtree 

let NERDTreeIgnore = ['\.pyc$', '__pycache__']
let NERDTreeShowHidden=1
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
