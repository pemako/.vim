"""" pemakoa@gmail.com

" General
syntax on         " 开启语法高亮
filetype on       " Enable filetype plugins
filetype plugin on
filetype indent on

"" Set to auto read when a file is changed from the outside
set autoread
"set autowrite
"au FocusGained,BufEnter * checktime
"" With a map leader it's possible to do extra key combinations
"" like <leader>w saves the current file
"leader 键的默认值为 /
"let mapleader = ";"


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

set expandtab                   " use spaces instead of tabs
set smarttab                    " 开启时，在行首按 TAB 将加入 shiftwidth 个空格，否则加入 tabstop 个空格
set shiftwidth=2                " 使用每层缩进的空格数
set tabstop=2                   " 一个tab为2个空格
set lbr                         " 尽量不会把一个单词拆分成两截放到不同的行中
set tw=500                      " Linebreak on 500 characters

set ai                          " auto indent
set si                          " smart indent
set wrap                        " wrap lines

set softtabstop=2               " 每次删除的空格数
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
set statusline=\ %{HasPaste()}%F%m%r%h\ %w\ \ CWD:\ %r%{getcwd()}%h\ \ \ Line:\ %l\ \ Column:\ %c

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


" 让Vim的补全菜单行为与一般IDE一致(参考VimTip1228)
set completeopt=longest,menu
set rtp+=/usr/local/opt/fzf

"" 加载插件
let setting_dir = '~/.vim/settings'
for fpath in split(globpath(setting_dir, '*.vim'), '\n')
  exec 'source' fpath
endfor
