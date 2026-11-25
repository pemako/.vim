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
set noautochdir                 " 不自动切目录：会冲掉 :lcd，并把 fzf/:make 的基准缩到子目录
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
set laststatus=2
set cmdheight=1
set showmatch
set matchtime=2
set wildmenu
set foldcolumn=1
set signcolumn=number           " 诊断符号画在行号列，coc 报错时正文不横向抖动
set foldmethod=indent
set foldlevel=99                " 默认展开所有折叠，需要时再 zc/za
" 不开 lazyredraw：官方文档说它只适合临时打开（may cause display errors），
" 常开会让 quickfix / coc 弹窗"闪一下再定住"
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
" 不用 smartindent：filetype indent 已接管；它会把无 indentexpr 文件的 # 顶到第 0 列
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
" 目录不存在时 undofile 会静默失效（连 undofile() 都返回空），换机器必踩
if !isdirectory(expand('~/.vim/undo'))
  call mkdir(expand('~/.vim/undo'), 'p', 0700)
endif
set wildignore=*.o,*~,*.pyc,*.gem
set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store
set wildignore+=*/node_modules/*,*/target/*,*/.venv/*,*/__pycache__/*

" 补全菜单：coc 推荐值，配合下面的 <CR>/<Tab> 映射
set completeopt=menuone,noinsert,noselect


" ============================== 5. 插件管理 ==============================
" vim-plug 不存在时自动下载
function! s:CheckPlug() abort
  if empty(glob('~/.vim/autoload/plug.vim'))
    silent! execute '!curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
  endif
endfunction
call s:CheckPlug()

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
" vim-go 的 ftplugin 会用 buffer-local 映射抢走 gd/K/<C-]>，压过 coc 的全局映射，
" 必须在加载前关掉，否则 Go 文件里跳转/悬停走的是 :GoDef 而不是 coc
let g:go_def_mapping_enabled     = 0
let g:go_doc_keywordprg_enabled  = 0
let g:go_code_completion_enabled = 0
" vim-go 默认会自己起一套 gopls（含 daemon），和 coc-go 的那个重复
let g:go_gopls_enabled           = 0
Plug 'fatih/vim-go', {'tag': '*', 'for': 'go'}   " Go 命令集（LSP 归 coc）
Plug 'rust-lang/rust.vim', {'for': 'rust'}       " Rust 语法/缩进、:RustFmt/:RustRun
Plug 'editorconfig/editorconfig-vim'             " 跟随项目 .editorconfig

" 导航与 LSP
Plug 'mcchrish/nnn.vim'                          " 文件浏览器（;n）
Plug 'junegunn/fzf.vim'                          " 模糊查找（<C-p>）
Plug 'neoclide/coc.nvim', {'branch': 'release'}  " LSP 前端 + 补全

call plug#end()

" 配置改完保存即生效（必须放 augroup + autocmd!，否则每次重载都多叠一条）
augroup vimrc_reload
  autocmd!
  autocmd BufWritePost $MYVIMRC nested source $MYVIMRC
augroup END


" ============================== 6. 基础快捷键 ==============================
" 文件
nnoremap <leader>w  :w!<CR>
nnoremap <leader>x  :x<CR>
nnoremap <leader>q  :q<CR>
nnoremap <leader>cd :cd %:p:h<CR>:pwd<CR>

" 窗口之间移动
nnoremap <C-h> <C-W>h
nnoremap <C-j> <C-W>j
nnoremap <C-k> <C-W>k
nnoremap <C-l> <C-W>l

" 剪贴板（不占用 <C-v> 可视块 / <C-c> 可视模式取消）
vnoremap <leader>y "+y
" Normal 下 ;y 是等待动作的操作符（;yw 等），整行复制用 ;Y
nnoremap <leader>Y "+yy
nnoremap <leader>p "+p
nnoremap <leader>P "+P

" 取消搜索高亮
noremap <silent> <leader>/ :nohlsearch<CR>

" 每次滚动 1 行（'scroll' 是窗口局部选项，改窗口大小就被重置成半屏，只能用映射）
nnoremap <C-d> <C-e>
nnoremap <C-u> <C-y>

" 标签页
nnoremap <leader>1 :tabfirst<CR>
nnoremap <leader>2 :tabnext 2<CR>
nnoremap <leader>3 :tabnext 3<CR>
nnoremap <leader>0 :tablast<CR>

" leader 是 ;，原生的「重复 f/t 查找」被占掉了，用 ;; 补回来
nnoremap <leader><leader> ;

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
      \ <SID>CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr> <S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
      \ : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! s:CheckBackspace() abort
  let l:col = col('.') - 1
  return !l:col || getline('.')[l:col - 1] =~# '\s'
endfunction

" 跳转与文档
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

nnoremap <silent> K :call <SID>ShowDocumentation()<CR>
function! s:ShowDocumentation() abort
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
" 光标位置上的代码动作（Import `std::fmt` 这类修复在这里）
" rust-analyzer 只在光标精确落在报错符号上时才给 Import（实测 impl fmt::Display
" 这行，只有 fmt::Display 那段列范围内有 Import，行首 impl 和行尾 for P 都是 0 个），
" 所以先原地取；取不到就跳到本行第一条诊断的起始列再取，省得自己去数列。
" 判定用的是"有没有 quickfix 类动作"而不是"有没有动作"：gopls 在任何位置都会
" 返回一个 Browse documentation，只数个数的话 fallback 永远不触发。
function! s:HasFix(acts) abort
  if type(a:acts) != v:t_list
    return 0
  endif
  for l:a in a:acts
    if get(l:a, 'kind', '') =~# '^\%(quickfix\|source\.\|refactor\.\)'
      return 1
    endif
  endfor
  return 0
endfunction

function! s:CodeAction() abort
  if s:HasFix(CocAction('codeActions', 'cursor'))
    call CocActionAsync('codeAction', 'cursor')
    return
  endif
  " 光标处没有可用修复，跳到本行第一条诊断的起始列再试
  let l:diags = filter(CocAction('diagnosticList'),
        \ 'v:val.file ==# expand("%:p") && v:val.lnum == line(".")')
  if !empty(l:diags) && l:diags[0].col != col('.')
    call cursor(l:diags[0].lnum, l:diags[0].col)
  endif
  call CocActionAsync('codeAction', 'cursor')
endfunction
nnoremap <silent> <leader>a :call <SID>CodeAction()<CR>
" 选区范围上的代码动作
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
" 从当前文件向上找 go.mod，读出 module 名（goimports -local 的分组依据）
function! s:GoModule() abort
  let l:gomod = findfile('go.mod', expand('%:p:h') . ';')
  if empty(l:gomod)
    return ''
  endif
  return matchstr(get(readfile(l:gomod, '', 5), 0, ''), '^module\s\+\zs\S\+')
endfunction

" 格式化：直接用各语言自己的 formatter，失败不动缓冲区
function! s:FormatBuffer() abort
  let l:ft   = &filetype
  let l:view = winsaveview()
  let l:src  = getline(1, '$')

  if l:ft ==# 'rust'
    let l:cmd = 'rustfmt --edition 2021'
  elseif l:ft ==# 'go'
    " goimports 默认只分两组（标准库和本地包混在一起，第三方单独一组）。
    " 传 -local <module> 才会拆成三组：标准库 / 第三方 / 本地包。
    let l:cmd = 'goimports'
    let l:mod = s:GoModule()
    if !empty(l:mod)
      let l:cmd .= ' -local ' . shellescape(l:mod)
    endif
  elseif l:ft ==# 'python'
    let l:cmd = 'ruff format --stdin-filename ' . shellescape(expand('%:p')) . ' -'
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
" findfile() 的 ';' 后缀就是「向上递归查找」，不用自己写循环
function! s:FindUp(marker) abort
  let l:found = findfile(a:marker, expand('%:p:h') . ';')
  return empty(l:found) ? expand('%:p:h') : fnamemodify(l:found, ':p:h')
endfunction

" quickfix 列表的显示格式：
"   有位置的条目 -> 文件|行 col 列| 文本（默认样式）
"   纯输出行（;r 的程序 stdout）-> 只显示文本，不出现 "|| "
function! s:QuickfixText(info) abort
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
let &quickfixtextfunc = function('s:QuickfixText')

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
  " 用 copen 而不是 cwindow：程序输出行没有文件/行号，cwindow 会认为"没有错误"而不开窗。
  " 窗口已存在时不再 copen，避免每次抢一下焦点（视觉上闪一下）。
  let l:has_qf = 0
  for l:w in range(1, winnr('$'))
    if getwinvar(l:w, '&buftype') ==# 'quickfix'
      let l:has_qf = 1
    endif
  endfor
  if !l:has_qf
    let l:win = win_getid()
    copen
    call win_gotoid(l:win)
  endif
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
    silent execute 'make ' . a:action
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
    silent execute 'make ' . (a:action ==# 'build' ? 'build ./...'
          \ : a:action ==# 'test' ? 'test ./...' : 'run .')
    call s:ShowResult(a:action ==# 'run')
  elseif l:ft ==# 'python'
    let &l:makeprg = 'python3'
    if a:action ==# 'build'
      silent execute 'make -m py_compile ' . l:file
    elseif a:action ==# 'test'
      silent execute 'make ' . (executable('pytest') ? '-m pytest -q' : '-m unittest -v')
    else
      silent execute 'make ' . l:file
    endif
    call s:PythonQuickfix()
    call s:ShowResult(a:action ==# 'run')
  elseif l:ft =~# '^\%(sh\|bash\|zsh\)$'
    if a:action ==# 'build'
      compiler shellcheck
      silent execute 'make ' . l:file
      call s:ShowResult(0)
    elseif a:action ==# 'test'
      echo 'Shell 没有测试阶段，用 ;b 做 shellcheck 检查'
    else
      let &l:makeprg = 'bash'
      let &l:errorformat = '%m'          " 脚本输出进 quickfix，方便回看
      silent execute 'make ' . l:file
      call s:ShowResult(1)
    endif
  else
    echo '未配置的语言：' . l:ft
  endif
endfunction

" 需要 stdin 的程序：在终端里跑
" 和 s:LangWorkflow 一样要先切到项目根：cargo / go 都要从含 Cargo.toml / go.mod
" 的目录启动，否则报 "go.mod file not found"
function! s:LangTerm() abort
  let l:ft = &filetype
  if l:ft ==# 'rust'
    execute 'lcd ' . fnameescape(s:FindUp('Cargo.toml'))
  elseif l:ft ==# 'go'
    execute 'lcd ' . fnameescape(s:FindUp('go.mod'))
  endif
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
  " autoimport 在文件头插入 import，行号会整体下移；只存行号的 winrestview 会
  " 让光标停在原行号上（指向的已经是别的代码），所以按插入行数补偿
  let l:before = line('$')
  let l:view   = winsaveview()
  let l:file = shellescape(expand('%:p'))
  let l:out = system(shellescape(l:bin) . ' ' . l:file . ' 2>&1')
  if v:shell_error != 0
    echo 'autoimport 失败：' . substitute(l:out, "\n", ' ', 'g')
    return
  endif
  " autoimport 只管增删，不排序（实测输出里 from 可能排在 import 前面）。
  " 用 ruff 的 isort 规则补上分组：I = 排序分组，F401 = 删未使用的 import。
  " 两者职责不重叠：autoimport 能"补"缺失的，ruff 不能；ruff 能分组，autoimport 不能。
  if executable('ruff')
    call system('ruff check --select I,F401 --fix --quiet ' . l:file . ' 2>&1')
  endif
  silent! edit!
  let l:added = line('$') - l:before
  let l:view.lnum    += l:added
  let l:view.topline += l:added
  call winrestview(l:view)
  echo l:added > 0 ? printf('import 已整理（净增 %d 行）', l:added)
        \ : (l:added < 0 ? printf('import 已整理（净减 %d 行）', -l:added) : 'import 已是最新')
endfunction
command! -nargs=0 Import :call <SID>PyAutoImport()

" 各语言缩进惯例（覆盖全局 2 空格）
" vim-go 保存时也会整理 import，同样要按三组分。因为我们关掉了 gopls
" （go_gopls_enabled = 0），vim-go 的 go_fmt_command 会降级成 gofmt——
" gofmt 不动 import，分组只由 goimports 那条路径（go_imports_mode）决定。
" 用 BufWritePre 在 vim-go 的 autosave 之前把 -local 填好。
let g:go_fmt_command = 'goimports'
augroup GoLocalImports
  autocmd!
  autocmd BufWritePre *.go call s:SetGoFmtLocal()
augroup END
function! s:SetGoFmtLocal() abort
  let l:mod = s:GoModule()
  if empty(l:mod)
    return
  endif
  let g:go_gopls_local = l:mod
  let l:opts = get(g:, 'go_fmt_options', {})
  let g:go_fmt_options = extend(
        \ type(l:opts) == v:t_dict ? copy(l:opts) : {},
        \ {'goimports': '-local ' . l:mod})
endfunction

augroup LangIndent
  autocmd!
  autocmd FileType rust   setlocal sw=4 sts=4 ts=4 et
  autocmd FileType python setlocal sw=4 sts=4 ts=4 et
  autocmd FileType go     setlocal noexpandtab ts=4 sw=4
  autocmd FileType sh     setlocal sw=2 sts=2 ts=2 et
augroup END

" 两键、小写、无 Shift：即使超时，落到的普通命令（b/e/f/g/m/r/T）也都无害
"
" 注意：:map 不支持行尾注释（:help map-comments），" 之后的内容会被算进 {rhs}
" 当按键执行。所有说明一律写在映射的上一行。

" 用 silent write：否则 "written" 加上工作流自己的消息会超出 cmdheight=1，
" 每次都弹 hit-enter 提示，要多按一次回车
" 构建 / 语法检查
nnoremap <leader>b :silent write<CR>:call <SID>LangWorkflow('build')<CR>
" 运行
nnoremap <leader>r :silent write<CR>:call <SID>LangWorkflow('run')<CR>
" 测试
nnoremap <leader>T :silent write<CR>:call <SID>LangWorkflow('test')<CR>
" 终端里跑（需要 stdin）
nnoremap <leader>g :silent write<CR>:call <SID>LangTerm()<CR>
" 格式化
nnoremap <leader>f :call <SID>FormatBuffer()<CR>
" Python: 补 import（Fix imports）
nnoremap <leader>F :call <SID>PyAutoImport()<CR>
" 错误列表（开/关）
nnoremap <leader>e :call <SID>QuickfixToggle()<CR>


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
for s:fzf_dir in ['/opt/homebrew/opt/fzf', '/usr/local/opt/fzf', '~/.fzf']
  if isdirectory(expand(s:fzf_dir))
    execute 'set rtp+=' . fnameescape(expand(s:fzf_dir))
    break
  endif
endfor
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
