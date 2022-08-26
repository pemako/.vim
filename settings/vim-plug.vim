""" vim-plug 管理

" 自动安装插件管理
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

let s:bundle_dir    = $HOME.'/.vim/bundle'
let g:plug_shallow  = 0                                 " 使用浅拷贝默认值为1
let g:plug_window   = 'enew'                            " 打开插件窗口命令
let g:plug_pwindow  = 'vertical rightbelow new'         " 打开 PlugDiff 预览窗口的命令


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
Plug 'voldikss/vim-translator'													" 翻译插件
Plug 'yianwillis/vimcdoc'                               " vim 中文版文档
Plug 'preservim/nerdcommenter'                          " 快速添加注释
Plug 'ryanoasis/vim-devicons'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'

"" Git 相关
Plug 'tpope/vim-fugitive'
Plug 'rhysd/committia.vim'

"" 搜索
Plug 'junegunn/fzf', {'do': { -> fzf#install() }}
Plug 'junegunn/fzf.vim'

Plug 'godlygeek/tabular'
Plug 'preservim/vim-markdown'
Plug 'dhruvasagar/vim-table-mode'
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}
" If you have nodejs and yarn
"Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install' }

Plug 'fatih/vim-go', {'tag': '*'}
Plug 'dense-analysis/ale'

Plug 'prabirshrestha/vim-lsp'                           " async language server protocol plugin
Plug 'mattn/vim-lsp-settings'
Plug 'prabirshrestha/async.vim'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
"Plug 'prabirshrestha/asyncomplete-file.vim'

call plug#end()
