"""  自定义设置

let setting_dir = '~/.vim/settings'

for fpath in split(globpath(setting_dir, '*.vim'), '\n')
  if (fpath == expand(setting_dir . "/manager.vim"))
    continue
  endif
  exe 'source' fpath
endfor
