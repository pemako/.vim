""" 定义各种键盘映射

nmap <leader>w :w!<cr>  " 保存当前文件
nmap <leader>x :x<cr>	  " 关闭当前文件
nmap <leader>q :q<cr>	  " 退出当前文件

nnoremap <C-d> :shell<CR>             " Cttl-d 在 vim 和 shell 来回切换
noremap <silent><leader>/ :nohls<CR>  " 关闭掉上次搜索的高亮

" Smart way to move between windows
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

" http://stackoverflow.com/questions/13194428/is-better-way-to-zoom-windows-in-vim-than-zoomwin
" Zoom / Restore window.
function! s:ZoomToggle() abort
    if exists('t:zoomed') && t:zoomed
        execute t:zoom_winrestcmd
        let t:zoomed = 0
    else
        let t:zoom_winrestcmd = winrestcmd()
        resize
        vertical resize
        let t:zoomed = 1
    endif
endfunction
command! ZoomToggle call s:ZoomToggle()
nnoremap <silent> <Leader>z :ZoomToggle<CR>


""" vim-go 插件
au FileType go nmap <leader>g <Plug>(go-run)
au FileType go nmap <leader>gd <Plug>(go-def-split)
au FileType go nmap <leader>gi <Plug>(go-iferr)
au FileType go nmap <leader>gf :GoFillStruct<cr>
au FileType go nmap <leader>gdd :GoDebugStart .<cr>


"" preservim/nerdcommenter 插件默认添加注释和取消注释快捷键
"<leader>cc   加注释
"<leader>cu   解开注释
