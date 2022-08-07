
Plug 'godlygeek/tabular' "必要插件，安装在vim-markdown前面
Plug 'plasticboy/vim-markdown'
Plug 'ericcurtin/CurtineIncSw.vim'                      " 用于头文件源文件来回切换
Plug 'ludovicchabant/vim-gutentags'                     " 自动生成 tags
Plug 'andymass/vim-matchup'                             " 配对标签跳转
Plug 'Xuyuanp/nerdtree-git-plugin'                      " nerdtree 辅助插件，展示文件状态
Plug 'mhinz/vim-startify'                               " 版本控制系统 vcs 展示每列的增删改状态，支持大部分 vcs
Plug 'voldikss/vim-translate-me'
Plug 'fatih/vim-go', {'tag': '*'}
Plug 'jiangmiao/auto-pairs'                             "自动补全括号插件
" 注意这里如果系统为10.13 版本的不要使用最新版本 使用 commitid=4e480a3  原因:https://github.com/ycm-core/YouCompleteMe/issues/3805
"Plug 'ycm-core/YouCompleteMe', { 'commit':'4e480a31' ,'do': './install.py --clang-completer --system-libclang --all' }
Plug 'pemako/YouCompleteMe', { 'do': 'CC=/usr/local/opt/llvm/bin/clang-12 python3 install.py --all' }
Plug 'rdnetto/YCM-Generator', { 'branch': 'stable'}     " YouCompleteMe 辅助插件，生成项目 .ycm_extra_conf.py 文件
Plug 'tenfyzhong/CompleteParameter.vim'                 " ycm 辅助
Plug 'davidhalter/jedi-vim'                             " ycm 复制，用户Python补全
Plug 'Yggdroot/indentLine'                              " 缩进线，方便 python 语言对齐
Plug 'vim-airline/vim-airline'                          " 状态栏
Plug 'wsdjeg/FlyGrep.vim'                               " 异步实时代码检索
Plug 'dense-analysis/ale'
Plug 'tmhedberg/SimpylFold'                             " python 折叠
Plug 'yianwillis/vimcdoc'                               " vim 中文版文档
Plug 'dhruvasagar/vim-table-mode'                       " vim table
Plug 'iamcco/mathjax-support-for-mkdp'
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install'   }
Plug 'rhysd/vim-clang-format'                           " cpp格式化
Plug 'tpope/vim-surround'
Plug 'rust-lang/rust.vim'
Plug 'mattn/webapi-vim'

Plug 'google/vim-maktaba'
Plug 'will133/vim-dirdiff'
Plug 'tenfyzhong/tagbar-proto.vim'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'vim-ruby/vim-ruby'


" File explorer
Plug 'scrooloose/nerdtree', {'on': 'NERDTreeToggle'}    " 树形目录插件，延迟加载
Plug 'scrooloose/nerdcommenter'

" Class outline viewer
Plug 'majutsushi/tagbar', {'on': 'TagbarToggle'}

" Fuzzy search
Plug 'ctrlpvim/ctrlp.vim'

" Grep
Plug 'mileszs/ack.vim'

" Find and replace
Plug 'brooth/far.vim'

" Syntax checker
Plug 'scrooloose/syntastic'

" Additional syntaxes and markup/programming languages
Plug 'sheerun/vim-polyglot'

" Git
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'
Plug 'rhysd/committia.vim'
Plug 'int3/vim-extradite'

Plug 'vim-ruby/vim-ruby'
