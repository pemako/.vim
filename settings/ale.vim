""" ale 相关配置

let g:ale_sh_shfmt_options = '-i 2 -ci'
let g:ale_fixers = {
		\ 'json' : ['prettier'],
		\ 'sh' : ['shfmt'],
		\ 'yaml' : ['prettier'],
		\ 'xml' : ['xmllint'],
		\ 'python': ['black', 'isort'],
		\ 'proto': ['protolint'],
		\ 'ruby' : ['brakeman'],
		\ 'go': ['goimports', 'gofmt'],
		\ 'js': ['eslint'],
		\}
nmap <Leader>; :ALEFix<CR>
