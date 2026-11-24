""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"  vimrc — 配置说明与快捷键见 ~/.vim/README.md
"  leader = ;   语言：Go / Python / Shell / Rust
"  分工：coc = LSP；各语言原生 formatter；:make → quickfix
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


" ============================== 1. 基础 ==============================
set nocompatible
filetype plugin indent on
syntax on
let mapleader = ";"

set encoding=utf-8
set fileformats=unix,dos,mac
set history=500
set autoread                    " 外部改动的文件自动重读
set autochdir                   " 自动切到当前文件所在目录（:! / fzf / grep 的基准目录）
set hidden                      " 切走的 buffer 保留（LSP/终端需要）
set confirm                     " 有未保存修改时先确认
set report=0                    " 报告每一次改动行数
set backspace=indent,eol,start
set whichwrap+=<,>,h,l
set selection=inclusive

" 中文
set helplang=cn                 " 配合 vimcdoc 使用中文帮助
set formatoptions+=mB           " 中文按字断行，合并行时不补空格

" ============================== 2. 显示 ==============================
set number
set ruler
set showcmd
set cursorline
set scrolloff=3
set scroll=1                    " CTRL-D/CTRL-U 每次滚动 1 行（个人习惯）
set laststatus=2
set cmdheight=1
set showmatch
set matchtime=2
set wildmenu
set foldcolumn=1
set foldmethod=indent
set foldlevel=99                " 默认展开所有折叠，需要时再 zc/za
set lazyredraw                  " 宏/批量操作时减少重绘
set shortmess+=c                " 补全不弹 "match n of m" 提示（coc 用）
set updatetime=300              " coc 诊断/符号刷新更快（默认 4000 太慢）
set timeoutlen=800              " 映射序列的按键间隔上限（超时会当普通命令执行）
set ttimeoutlen=50              " 终端按键序列（<Tab>/组合键）响应更快
set guicursor=                  " 保持块状光标，不随模式变形

" 静音
set noerrorbells
set novisualbell
set t_vb=

" ============================== 3. 编辑 ==============================
set expandtab
set smarttab
set tabstop=2
set shiftwidth=2
set softtabstop=2
set autoindent
set smartindent
set wrap
set linebreak                   " 折行时不在单词中间断开
set iskeyword&                  " 用默认字符集：$@%#- 并入单词会破坏 w / * / iw / gd

" 搜索
set ignorecase
set smartcase
set incsearch
set hlsearch
set magic

" ============================== 4. 文件与持久化 ==============================
set nobackup                    " 不生成 文件~ 永久备份
set nowritebackup               " 写文件时也不生成临时 文件~（打断写入会残留）
set noswapfile
set undofile                    " 持久撤销：崩溃/误操作后重新打开仍可 undo
set undodir=~/.vim/undo
set wildignore=*.o,*~,*.pyc,*.gem
set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store
set wildignore+=*/node_modules/*,*/target/*,*/.venv/*,*/__pycache__/*

" 补全菜单：coc 推荐值，配合下面的 <CR>/<Tab> 映射
set completeopt=menuone,noinsert,noselect


" ============================== 5. 插件管理 ==============================
" vim-plug 不存在时自动下载
def! s:mkCheckPlug()
  if empty(glob('~/.vim/autoload/plug.vim'))
    silent! execute '!curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
  endif
enddef
call s:mkCheckPlug()

let s:bundle_dir    = $HOME.'/.vim/bundle'
let g:plug_shallow  = 0
let g:plug_window   = 'enew'
let g:plug_pwindow  = 'vertical rightbelow new'

call plug#begin(s:bundle_dir)

" 界面
Plug 'mhinz/vim-startify'                        " 启动界面
Plug 'vim-airline/vim-airline'                   " 状态栏
Plug 'ryanoasis/vim-devicons'                    " 文件图标
Plug 'liuchengxu/vista.vim'                      " 侧栏大纲（;v，走 coc）
Plug 'preservim/nerdtree', {'on': 'NERDTreeToggle'}   " 目录树（按需加载）

" 编辑增强
Plug 'jiangmiao/auto-pairs'                      " 括号/引号自动配对
Plug 'tpope/vim-surround'                        " 增删改包围符号
Plug 'tpope/vim-repeat'                          " . 支持插件动作
Plug 'preservim/nerdcommenter'                   " 注释（;cc / ;cu / ;cs）
Plug 'godlygeek/tabular'                         " 对齐（;= ;: ;, ;"）
Plug 'voldikss/vim-translator'                   " 翻译（;tr）

" 文本
Plug 'preservim/vim-markdown'
Plug 'dhruvasagar/vim-table-mode'                " 表格（;tm / ;tt）
Plug 'yianwillis/vimcdoc'                        " Vim 中文帮助

" 语言
Plug 'fatih/vim-go', {'tag': '*'}                " Go 命令集（LSP 归 coc）
Plug 'rust-lang/rust.vim', {'for': 'rust'}       " Rust 语法/缩进、:RustFmt/:RustRun
Plug 'editorconfig/editorconfig-vim'             " 跟随项目 .editorconfig

" 导航与 LSP
Plug 'mcchrish/nnn.vim'                          " 文件浏览器（;n）
Plug 'junegunn/fzf.vim'                          " 模糊查找（<C-p>）
Plug 'neoclide/coc.nvim', {'branch': 'release'}  " LSP 前端 + 补全

call plug#end()

" 配置改完保存即生效
autocmd BufWritePost $MYVIMRC source $MYVIMRC


" ============================== 6. 基础快捷键 ==============================
" 文件
nnoremap <leader>w  :w!<CR>
nnoremap <leader>x  :x<CR>
nnoremap <leader>q  :q<CR>
nnoremap <leader>cd :cd ..<CR>:pwd<CR>

" 窗口之间移动
nnoremap <C-h> <C-W>h
nnoremap <C-j> <C-W>j
nnoremap <C-k> <C-W>k
nnoremap <C-l> <C-W>l

" 与 macOS 一致的复制粘贴
vnoremap <C-c> "+y
nnoremap <C-v> "*p

" 取消搜索高亮
noremap <silent> <leader>/ :nohlsearch<CR>

" 标签页
nnoremap <leader>1 :tabfirst<CR>
nnoremap <leader>2 :tabnext 1<CR>
nnoremap <leader>3 :tabnext 2<CR>
nnoremap <leader>0 :tablast<CR>

" 对齐（tabular）
nnoremap <leader>= :Tabularize /=<CR>
nnoremap <leader>: :Tabularize /:<CR>
nnoremap <leader>, :Tabularize /,<CR>
nnoremap <leader>" :Tabularize /"<CR>


" ============================== 7. LSP（coc.nvim）==============================
" 诊断与补全统一由 coc 提供；各语言服务端：gopls / pyright /
" bash-language-server / rust-analyzer

" 补全菜单
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr> <S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
      \ : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1] =~# '\s'
endfunction

" 跳转与文档
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

nnoremap <silent> K :call ShowDocumentation()<CR>
function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

" 行内提示（inlay hints）调暗：代码是正文，提示用灰斜体，不抢注意力
function! s:DimInlayHints() abort
  highlight CocInlayHint           guifg=#5c6370 ctermfg=240 gui=italic cterm=italic
  highlight! link CocInlayHintType      CocInlayHint
  highlight! link CocInlayHintParameter CocInlayHint
endfunction
augroup InlayHintStyle
  autocmd!
  autocmd User CocNvimInit call s:DimInlayHints()
  autocmd ColorScheme *    call s:DimInlayHints()
augroup END
call s:DimInlayHints()

" 重命名 / 代码动作
nmap <leader>m  <Plug>(coc-rename)
nmap <leader>a  <Plug>(coc-codeaction-selected)
xmap <leader>a  <Plug>(coc-codeaction-selected)

" coc 列表
nnoremap <silent><nowait> <space>a :<C-u>CocList diagnostics<CR>
nnoremap <silent><nowait> <space>e :<C-u>CocList extensions<CR>
nnoremap <silent><nowait> <space>c :<C-u>CocList commands<CR>
nnoremap <silent><nowait> <space>o :<C-u>CocList outline<CR>
nnoremap <silent><nowait> <space>s :<C-u>CocList -I symbols<CR>
nnoremap <silent><nowait> <space>j :<C-u>CocNext<CR>
nnoremap <silent><nowait> <space>k :<C-u>CocPrev<CR>
nnoremap <silent><nowait> <space>p :<C-u>CocListResume<CR>


" ============================== 8. 语言工作流 ==============================
" 格式化：直接用各语言自己的 formatter，失败不动缓冲区
function! s:FormatBuffer() abort
  let l:ft   = &filetype
  let l:view = winsaveview()
  let l:src  = getline(1, '$')

  if l:ft ==# 'rust'
    let l:cmd = 'rustfmt --edition 2021'
  elseif l:ft ==# 'go'
    let l:cmd = 'gofmt'
  elseif l:ft ==# 'python'
    let l:cmd = 'ruff format -'
  elseif l:ft =~# '^\%(sh\|bash\|zsh\)$'
    let l:cmd = 'shfmt -i 2 -ci'
  elseif l:ft ==# 'json'
    let l:cmd = 'jq .'
  elseif l:ft ==# 'yaml'
    let l:cmd = 'prettier --stdin-filepath ' . shellescape(expand('%:p'))
  else
    echo '没有为 ' . l:ft . ' 配置格式化器'
    return
  endif

  let l:out = systemlist(l:cmd, l:src)
  if v:shell_error != 0 || empty(l:out)
    echohl WarningMsg | echomsg '格式化失败：' . l:cmd | echohl None
    return
  endif
  silent %delete _
  call setline(1, l:out)
  call winrestview(l:view)
endfunction
command! -nargs=0 Format :call <SID>FormatBuffer()

" Python 的 traceback 用 errorformat 匹配不稳定，直接把输出重建成可跳转的 quickfix
function! s:PythonQuickfix() abort
  let l:items = []
  for l:e in getqflist()
    let l:m = matchlist(l:e.text, 'File "\([^"]\+\)", line \(\d\+\)')
    if !empty(l:m)
      call add(l:items, {'filename': l:m[1], 'lnum': str2nr(l:m[2]),
            \ 'text': l:e.text, 'valid': 1})
    elseif !empty(l:items)
      let l:items[-1].text .= ' | ' . substitute(l:e.text, '^\s*', '', '')
    endif
  endfor
  if !empty(l:items)
    call setqflist(l:items)
    silent! cc
  endif
endfunction

" cargo test 的 "panicked at src/lib.rs:47:9:" 不在 Vim 的 cargo errorformat 里。
" 有 panic 时把 quickfix 收敛成「失败位置」列表，;e + 回车直接跳到出错行。
function! s:RustQuickfix() abort
  let l:items = []
  for l:e in getqflist()
    let l:m = matchlist(get(l:e, 'text', ''), 'panicked at \(\S\+\):\(\d\+\):\(\d\+\)')
    if !empty(l:m)
      call add(l:items, {'filename': fnamemodify(l:m[1], ':p'),
            \ 'lnum': str2nr(l:m[2]), 'col': str2nr(l:m[3]),
            \ 'text': l:e.text, 'valid': 1})
    endif
  endfor
  if !empty(l:items)
    call setqflist(l:items)
    silent! cc
  endif
endfunction

" 从当前文件向上找项目根（Cargo.toml / go.mod），找不到就退回文件所在目录
function! s:FindUp(marker) abort
  let l:dir = expand('%:p:h')
  while 1
    if filereadable(l:dir . '/' . a:marker)
      return l:dir
    endif
    let l:parent = fnamemodify(l:dir, ':h')
    if l:parent ==# l:dir
      return expand('%:p:h')
    endif
    let l:dir = l:parent
  endwhile
endfunction

" quickfix 列表的显示格式：
"   有位置的条目 -> 文件|行 col 列| 文本（默认样式）
"   纯输出行（;r 的程序 stdout）-> 只显示文本，不出现 "|| "
function! QuickfixText(info) abort
  let l:lines = []
  let l:items = getqflist({'id': a:info.id, 'items': 1}).items
  for l:i in range(a:info.start_idx - 1, a:info.end_idx - 1)
    let l:e = l:items[l:i]
    if l:e.valid && l:e.bufnr > 0 && l:e.lnum > 0
      let l:name = bufname(l:e.bufnr)
      call add(l:lines, printf('%s|%d col %d| %s',
            \ l:name, l:e.lnum, l:e.col, l:e.text))
    else
      call add(l:lines, l:e.text)
    endif
  endfor
  return l:lines
endfunction
let &quickfixtextfunc = 'QuickfixText'

" 执行完把结果摆出来：有输出/错误就打开 quickfix 窗口，不用再去按 ;e
function! s:ShowResult(run) abort
  if empty(getqflist())
    echohl WarningMsg
    echomsg a:run ? '程序没有输出' : '没有错误，检查通过'
    echohl None
    return
  endif
  " 打开窗口但把焦点还回来：留在源码里，才能接着按 ;b / ;r
  " （否则焦点在 quickfix 窗口上时，:w 会作用在那个缓冲区，报 E32）
  let l:win = win_getid()
  cwindow
  call win_gotoid(l:win)
  if a:run
    " 运行输出在末尾：把 quickfix 的"当前项"设到最后一条，窗口会跟着滚过去
    call setqflist([], 'a', {'idx': len(getqflist())})
  endif
endfunction

" ;e 改成开/关切换
function! s:QuickfixToggle() abort
  let l:open = 0
  for l:w in range(1, winnr('$'))
    if getwinvar(l:w, '&buftype') ==# 'quickfix'
      let l:open = 1
    endif
  endfor
  if l:open
    cclose
  else
    copen
  endif
endfunction

" 构建 / 运行 / 测试：统一进 quickfix
function! s:LangWorkflow(action) abort
  let l:ft   = &filetype
  let l:file = shellescape(expand('%:p'))
  " 切到项目根（cargo/gc 报的路径是相对根的）；找不到项目就退回文件目录
  let l:dir = expand('%:p:h')
  if l:ft ==# 'rust'
    let l:dir = s:FindUp('Cargo.toml')
  elseif l:ft ==# 'go'
    let l:dir = s:FindUp('go.mod')
  endif
  execute 'lcd ' . fnameescape(l:dir)

  if l:ft ==# 'rust'
    compiler cargo
    if a:action ==# 'run'
      let &l:errorformat = '%m'          " 运行时保留程序输出，而不是当错误丢弃
    endif
    execute 'make ' . a:action
    if a:action ==# 'test'
      call s:RustQuickfix()
    endif
    call s:ShowResult(a:action ==# 'run')
  elseif l:ft ==# 'go'
    compiler go
    let &l:makeprg = 'go'
    if a:action ==# 'run'
      let &l:errorformat = '%m'
    endif
    execute 'make ' . (a:action ==# 'build' ? 'build ./...'
          \ : a:action ==# 'test' ? 'test ./...' : 'run .')
    call s:ShowResult(a:action ==# 'run')
  elseif l:ft ==# 'python'
    let &l:makeprg = 'python3'
    if a:action ==# 'build'
      execute 'make -m py_compile ' . l:file
    elseif a:action ==# 'test'
      execute 'make ' . (executable('pytest') ? '-m pytest -q' : '-m unittest -v')
    else
      execute 'make ' . l:file
    endif
    call s:PythonQuickfix()
    call s:ShowResult(a:action ==# 'run')
  elseif l:ft =~# '^\%(sh\|bash\|zsh\)$'
    if a:action ==# 'build'
      compiler shellcheck
      execute 'make ' . l:file
      call s:ShowResult(0)
    elseif a:action ==# 'test'
      echo 'Shell 没有测试阶段，用 ;b 做 shellcheck 检查'
    else
      let &l:makeprg = 'bash'
      let &l:errorformat = '%m'          " 脚本输出进 quickfix，方便回看
      execute 'make ' . l:file
      call s:ShowResult(1)
    endif
  else
    echo '未配置的语言：' . l:ft
  endif
endfunction

" 需要 stdin 的程序：在终端里跑
function! s:LangTerm() abort
  let l:ft = &filetype
  if l:ft ==# 'rust'
    term cargo run
  elseif l:ft ==# 'go'
    term go run .
  elseif l:ft ==# 'python'
    execute 'term python3 ' . shellescape(expand('%:p'))
  elseif l:ft =~# '^\%(sh\|bash\|zsh\)$'
    execute 'term bash ' . shellescape(expand('%:p'))
  else
    echo '未配置的语言：' . l:ft
  endif
endfunction

" Python 专用：用 autoimport 补齐文件里缺失的 import（补全列表里的 Auto-import 只覆盖单个符号）
function! s:PyAutoImport() abort
  if &filetype !=# 'python'
    echo '只在 Python 文件里可用'
    return
  endif
  let l:bin = executable('autoimport') ? 'autoimport' : $HOME . '/.local/bin/autoimport'
  if !executable(l:bin)
    echo 'autoimport 未安装：pipx install autoimport'
    return
  endif
  silent! write
  let l:out = system(shellescape(l:bin) . ' ' . shellescape(expand('%:p')) . ' 2>&1')
  if v:shell_error != 0
    echo 'autoimport 失败：' . substitute(l:out, "\n", ' ', 'g')
    return
  endif
  silent! edit!
  echo '已补齐缺失的 import'
endfunction
command! -nargs=0 Import :call <SID>PyAutoImport()

" 各语言缩进惯例（覆盖全局 2 空格）
augroup LangIndent
  autocmd!
  autocmd FileType rust   setlocal sw=4 sts=4 ts=4 et
  autocmd FileType python setlocal sw=4 sts=4 ts=4 et
  autocmd FileType go     setlocal noexpandtab ts=4 sw=4
  autocmd FileType sh     setlocal sw=2 sts=2 ts=2 et
augroup END

" 两键、小写、无 Shift：即使超时，落到的普通命令（b/e/f/g/m/r/T）也都无害
nnoremap <leader>b :w<CR>:call <SID>LangWorkflow('build')<CR>   " 构建 / 语法检查
nnoremap <leader>r :w<CR>:call <SID>LangWorkflow('run')<CR>     " 运行
nnoremap <leader>T :w<CR>:call <SID>LangWorkflow('test')<CR>    " 测试
nnoremap <leader>g :w<CR>:call <SID>LangTerm()<CR>              " 终端里跑（需要 stdin）
nnoremap <leader>f :call <SID>FormatBuffer()<CR>                " 格式化
nnoremap <leader>F :call <SID>PyAutoImport()<CR>                " Python: 补 import（Fix imports）
nnoremap <leader>e :call <SID>QuickfixToggle()<CR>               " 错误列表（开/关）
nnoremap <leader>; :call <SID>FormatBuffer()<CR>                " 格式化（;; 快捷）


" ============================== 9. 其它插件配置 ==============================
" 翻译（;tt 已被 vim-table-mode 占用，故用 ;tr）
nnoremap <silent> <leader>tr <Plug>Translate<CR>
xmap     <silent> <leader>tr <Plug>TranslateV<CR>

" 大纲（vista，符号来源用 coc）
let g:vista_default_executive = 'coc'
nmap <leader>v :Vista!!<CR>

" nnn：打开方式与预览
let g:nnn#action = {
      \ '<c-t>': 'tab split',
      \ '<c-x>': 'split',
      \ '<c-v>': 'vsplit'}
let g:nnn#session = 'local'

" fzf：rg 驱动，排除版本控制目录与依赖目录
set rtp+=/opt/homebrew/opt/fzf
let $FZF_DEFAULT_COMMAND = 'rg --files --hidden --glob "!{.git,.idea,node_modules,target,.venv,__pycache__,*~}"'
let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6, 'relative': v:true, 'yoffset': 1.0 }}
nnoremap <silent> <C-p> :Files<CR>

" fzf 里 ctrl-q 把选中文件塞进 quickfix
function! s:build_quickfix_list(lines)
  call setqflist(map(copy(a:lines), '{ "filename": v:val, "lnum": 1 }'))
  copen
  cc
endfunction
let g:fzf_action = {
  \ 'ctrl-q': function('s:build_quickfix_list'),
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }
