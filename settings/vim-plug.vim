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

Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'preservim/nerdcommenter'
Plug 'preservim/nerdtree', {'on': 'NERDTreeToggle'}
Plug 'tpope/vim-surround'
Plug 'vim-airline/vim-airline'
Plug 'jiangmiao/auto-pairs'
Plug 'fatih/vim-go', {'tag': '*'}
Plug 'mhinz/vim-startify'
Plug 'dense-analysis/ale'
Plug 'yianwillis/vimcdoc'                               " vim 中文版文档


" 使用 lsp 做代码补全
Plug 'prabirshrestha/async.vim'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/vim-lsp'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
Plug 'prabirshrestha/asyncomplete-file.vim'
call plug#end()
