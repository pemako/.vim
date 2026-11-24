"""" pemakoa@gmail.com

" General
syntax on         " 开启语法高亮
set nocompatible
filetype on       " Enable filetype plugins
filetype plugin on
filetype indent on

set guicursor= " 禁止修改光标样式


"" Set to auto read when a file is changed from the outside
set autoread
"set autowrite
"au FocusGained,BufEnter * checktime
"" With a map leader it's possible to do extra key combinations
"" like <leader>w saves the current file
"leader 键的默认值为 /
let mapleader = ";"


""" VIM user interface
set so=7                        " Set 7 lines to the cursor - when moving vertically using j/k
set langmenu=zh_CN.UTF-8        " 语言设置
set helplang=cn                 " 如果有就使用vim中文帮助文档
set termencoding=utf-8
set encoding=utf-8
set history=500                 " Sets how many lines of history VIM has to remember
set ruler                       " Always show current position
set hid                         " A buffer becomes hidden when it is abandoned

set autochdir                   " 输出时只有文件名，不带 ./ ../等目录前缀(默认了执行 % 在当前的目录下)
set noundofile                  " 禁止生成临时文件
set nobackup                    " 禁止备份
set noswapfile                  " 禁止swap文件
set ignorecase                  " 搜索忽略大小写
set smartcase                   " 该选项被启用后，只要我们在查找模式中输入了大 写字母，‘ignorecase’设置就不再生效了

set number                      " 显示行号
"set cursorcolumn               " 高亮光标所在行
set cursorline                  " 高亮光标所在列
set showcmd                     " 显示等待输入命令
set scroll=1                    " 光标移动的距离
set scrolloff=3                 " 光标移动到buffer的顶部和底部时保持3行距离
set cmdheight=1                 " 设置显示消息的空间
set confirm                     " 在处理未保存或只读文件的时候，弹出确认
set report=0                    " 调用:commands 命令模式时总是报告修改的行数

set ai                          " auto indent
set si                          " smart indent
set wrap                        " wrap lines

set expandtab                   " use spaces instead of tabs
set tabstop=2                   " 一个tab为2个空格
set shiftwidth=2                " 使用每层缩进的空格数
set softtabstop=2               " 每次删除的空格数
set smarttab                    " 开启时，在行首按 TAB 将加入 shiftwidth 个空格，否则加入 tabstop 个空格
set lbr                         " 尽量不会把一个单词拆分成两截放到不同的行中
set tw=500                      " Linebreak on 500 characters


set backspace=indent,eol,start  " 使用回车键正常处理空格缩进，行结束符 段首
set whichwrap+=<,>,h,l          " Configure backspace so it acts as it should act
set hlsearch                    " 高亮搜索结果
set incsearch                   " 增量查找功能
set lazyredraw                  " 在执行宏时不要重绘(良好的性能配置)
set magic                       " For regular expressions turn magic on
set showmatch                   " 高亮显示匹配的括号
set matchtime=2                 " 匹配括号高亮的时间（单位是十分之一秒）
set fo+=mB                      " 支持亚洲语言 m 允许在两个汉字之间断行 B 表示将两行合并为一行的时候，汉字于汉字之间不要补空格
set iskeyword+=$,@,%,#,-,_      " 带有如下符号的单词不要被换行分割
set sm
set selection=inclusive         " 指定在选择文本时，光标所在位置也属于被选中的范围

set wildmenu                    " 在命令模式下使用 Tab 自动补全的时候，将补全内容使用一个漂亮的单行菜单形式显示出来

set laststatus=2                " 显示状态栏
"set statusline=\ %{HasPaste()}%F%m%r%h\ %w\ \ CWD:\ %r%{getcwd()}%h\ \ \ Line:\ %l\ \ Column:\ %c

"" Ignore compiled files
set wildignore=*.o,*~,*.pyc
set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store,*.gem

"" No annoying sound on errors
set noerrorbells
set novisualbell
set t_vb=
set tm=500

set foldcolumn=1                " Add a bit extra margin to the left
set ffs=unix,dos,mac            " Use Unix as the standard file type

set foldmethod=indent           " 基于缩进的代码折叠
" set foldmethod=syntax         " 基于语法的代码缩进
" set nofoldeable               " 启动 vim 时关闭折叠代码

" 让Vim的补全菜单行为与一般IDE一致(参考VimTip1228)
set completeopt=longest,menu
set rtp+=/opt/homebrew/opt/fzf

"" 加载插件
"let setting_dir = '~/.vim/settings'
"for fpath in split(globpath(setting_dir, '*.vim'), '\n')
"  exec 'source' fpath
"endfor
"
" 插件管理
"

" 检查 plug 插件是否存在，不存在默认添加
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

Plug 'mhinz/vim-startify'                               " vim 开始界面
Plug 'preservim/tagbar'                                 " 查看当前代码文件中的变量和函数列表的插件
Plug 'vim-airline/vim-airline'                          " Vim状态栏插件
Plug 'jistr/vim-nerdtree-tabs'                          " 可以使 nerdtree 的 tab 更加友好些
Plug 'Xuyuanp/nerdtree-git-plugin'                      " 可以在导航目录中看到 git 版本信息
Plug 'preservim/nerdtree', {'on': 'NERDTreeToggle'}     " 提供一个导航目录的侧边栏
Plug 'jiangmiao/auto-pairs'                             " 自动补全括号的插件，包括小括号，中括号，以及花括号
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'voldikss/vim-translator'   " 翻译插件
Plug 'yianwillis/vimcdoc'      " vim 中文版文档
Plug 'preservim/nerdcommenter' " 快速添加注释
Plug 'stevearc/aerial.nvim'


Plug 'godlygeek/tabular'                                " 对齐任意文本，适用于各种格式化需求，不限于表格
Plug 'preservim/vim-markdown'
Plug 'dhruvasagar/vim-table-mode'
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install'  }

Plug 'fatih/vim-go', {'tag': '*'}
Plug 'rust-lang/rust.vim', {'for': 'rust'}              " Rust: 语法/缩进, :RustFmt :RustRun :RustTest

Plug 'mcchrish/nnn.vim'
Plug 'junegunn/fzf.vim'
Plug 'dense-analysis/ale'


Plug 'neoclide/coc.nvim', {'branch': 'release'}
" UI 增强
Plug 'liuchengxu/vista.vim' " 代码大纲
Plug 'ryanoasis/vim-devicons' " 图标支持
Plug 'editorconfig/editorconfig-vim'
call plug#end()


" 让配置变更立即生效
autocmd BufWritePost $MYVIMRC source $MYVIMRC

"""" 定义键盘映射

" 文件操作
nmap <leader>w :w!<cr> " 保存当前文件
nmap <leader>x :x<cr>  " 关闭当前文件
nmap <leader>q :q<cr>  " 退出当前文件

" 窗口移动
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

"贴复制 和 mac 的保持一致
vnoremap <C-c> "+y " 支持在Visual模式下，通过C-c复制到系统剪切板
nnoremap <C-v> "*p " 支持在normal模式下，通过C-v粘贴系统剪切板

noremap <silent><leader>/ :nohls<CR> " 关掉上一次搜索的高亮

" ale 插件的相关设置
let g:ale_sh_shftm_options='-i 2 -ci'
let g:ale_json_jq_options= '--indent 2'
let g:ale_fixers = {
      \ 'json': ['jq'],
      \ 'sh': ['shfmt'],
      \ 'make': ['checkmake'],
      \ 'yaml': ['perttier'],
      \ 'python': ['isort', 'yapf', 'autoimport'],
      \ 'go': ['goimports', 'gofmt'],
      \ 'rust': ['rustfmt'],
      \}

" Rust 的诊断全部交给 coc + rust-analyzer；清空 ALE 的 rust linter，避免两个 LSP 进程抢活
let g:ale_linters = {'rust': []}

nmap <leader>; :ALEFix<CR>

" nnn action
" https://github.com/mcchrish/nnn.vim
let g:nnn#action = {
      \ '<c-t>': 'tab split',
      \ '<c-x>': 'split',
      \ '<c-v>': 'vsplit'}

" nnn 插件预览功能配置
let g:nnn#session = 'local'

" coc 代码自动补全相关配置
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" 格式化代码
command! -nargs=0 Format :call CocAction('format')

" Vista 配置
let g:vista_default_executive = 'coc'
nmap <leader>v :Vista!!<CR>

inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use K to show documentation in preview window
nnoremap <silent> K :call ShowDocumentation()<CR>

function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

" 跳转到定义
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Symbol renaming
nmap <leader>rn <Plug>(coc-rename)

"  Mappings for CoCList
nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr> "  Show all diagnostics
nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>  "  Manage extensions
nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>    "  Show commands
nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>     "  Find symbol of current document
nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>  "  Search workspace symbols
nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>             "  Do default action for next item
nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>             "  Do default action for previous item
nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>       "  Resume latest coc list

" ===== Rust 工作流 =====
" Rust 惯例 4 空格缩进，覆盖全局的 tabstop=2
augroup RustWorkflow
  autocmd!
  autocmd FileType rust setlocal sw=4 sts=4 ts=4 et
  autocmd FileType rust compiler cargo          " :make -> cargo，错误进 quickfix
augroup END

" ;R 前缀：避开已有的 ;rn（重命名），否则每次按 ;r 都要等 timeoutlen
nnoremap <leader>Rb :w<CR>:make build<CR>       " cargo build
nnoremap <leader>Rr :w<CR>:make run<CR>         " cargo run
nnoremap <leader>Rt :w<CR>:make test<CR>        " cargo test
nnoremap <leader>Rc :copen<CR>                  " 打开错误列表，回车跳转
nnoremap <leader>Rf :RustFmt<CR>                " rustfmt 当前文件
nnoremap <leader>Rx :term cargo run<CR>         " 需要 stdin 的交互式程序
" ===== /Rust 工作流 =====

"  在多个tab中快速的切换
"  gt  切换到下一个标签 gT 切换到上一个标签
nnoremap <Leader>1 :tabfirst<CR>  "  快速切换到第一个标签页
nnoremap <Leader>2 :tabnext 1<CR> "  快速切换到第二个标签页
nnoremap <Leader>3 :tabnext 2<CR> "  快速切换到第三个标签页
nnoremap <Leader>0 :tablast<CR>   "  快速切换到最后一个标签页


" tabularize 插件设置
nnoremap <leader>= :Tabularize /= <CR> " 快速对齐等号
nnoremap <leader>: :Tabularize /: <CR> " 快速对齐冒号
nnoremap <leader>, :Tabularize /, <CR> " 快速对齐逗号
nnoremap <leader>" :Tabularize /" <CR> " 快速对双引号

" fzf 配置
" 使用 rg 作为 fzf 的默认搜索工具，并忽略特定目录
let $FZF_DEFAULT_COMMAND = 'rg --files --hidden --glob "!{.git,.idea, node_modules}"'
let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6, 'relative': v:true, 'yoffset': 1.0 }}
nnoremap <silent> <leader>cd :cd ..<CR>:pwd<CR>
" 定义快捷键 : 当前目录搜索文件
nnoremap <silent> <C-p> :Files<CR>
" 使用 Ag 搜索当前目录
"nnoremap <silent> <leader>p :Ag<CR>

" 使用 Ripgrep 搜索当前目录
"nnoremap <silent> <leader>r :Rg<CR>
" An action can be a reference to a function that processes selected lines
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



