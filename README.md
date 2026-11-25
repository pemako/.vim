# Vim 配置说明

> 环境：Vim 9.2 (Homebrew, macOS arm64) · leader = `;` · 插件管理 = vim-plug
> 主要语言：Go / Python / Shell / Rust

---

## 1. 文件地图

| 路径 | 作用 |
|---|---|
| `~/.vim/vimrc` | 主配置（本文件描述的键位都在这里） |
| `~/.vim/coc-settings.json` | LSP 参数（rust-analyzer / pyright / gopls / bashls） |
| `~/.vim/bundle/` | vim-plug 安装的插件 |
| `~/.vim/README.md` | 本说明 |
| `~/.vim/vimrc.bak.*` | 历史备份，回滚用 |

---

## 2. 分工（重要，先看这个）

| 层 | 谁负责 | 说明 |
|---|---|---|
| 补全 / 跳转 / 重命名 / 诊断 | **coc.nvim** + 各语言 LSP | 四门语言共用一套键位 |
| LSP 服务端 | gopls · pyright · bash-language-server · rust-analyzer | 由 coc 扩展自动拉起 |
| 格式化 | **各语言原生 formatter** | 不经过 ALE / LSP，直接 stdin→stdout |
| 构建 / 运行 / 测试 | `:make` → quickfix | 统一由 `;R*` 触发 |
| 大纲 | vista + coc | `;v` |
| 文件搜索 | fzf + ripgrep | `<C-p>` |
| 文件浏览 | nnn | `;n` |

ALE 和 vim-go 均已移除。Go 的语法 / 缩进 / `compiler` 用 Vim 9.2 内置的 runtime 文件
（和 vim-go 的功能等价，缩进函数同为 `GoIndent()`），LSP 由 coc-go 提供，gopls 只有一个实例。

---

## 3. 快捷键

### 3.1 文件 / 窗口

| 键 | 动作 |
|---|---|
| `;w` | 保存（强制 `:w!`） |
| `;x` | 保存并关闭 |
| `;q` | 关闭 |
| `;cd` | 切到当前文件所在目录（并打印 pwd） |
| `<C-h>` `<C-j>` `<C-k>` `<C-l>` | 在窗口间移动 |
| `<C-d>` / `<C-u>` | 下 / 上滚动一行 |
| `<C-p>` | fzf 找文件（rg 驱动） |
| `;n` | 打开 nnn 文件浏览器 |
| `;y` | 复制到系统剪贴板（Visual 模式） |
| `;Y` | 复制整行到系统剪贴板（Normal 模式；`;y` 在 Normal 下是等待动作的操作符） |
| `;p` / `;P` | 从系统剪贴板粘贴到光标后 / 前 |
| `;;` | 重复上一次 `f` / `t` 查找（leader 占用了原生 `;`） |

`<C-v>`（可视块）和 `<C-c>`（取消）保持 Vim 原义，没有被剪贴板映射占用。

### 3.2 LSP（coc.nvim，四门语言通用）

| 键 | 动作 |
|---|---|
| `gd` | 跳到定义 |
| `gy` | 跳到类型定义 |
| `gi` | 跳到实现 |
| `gr` | 列出引用 |
| `K` | 悬停文档（签名 + doc） |
| `;m` | 重命名符号（跨文件） |
| `;a` | 当前光标位置的代码动作（Rust：`Import \`std::fmt\``、`Qualify as …`、实现 trait 等）；Visual 模式下对选中范围生效。**光标不在报错符号上时会自动跳到本行第一条诊断的位置再取**，所以在行首按也能拿到 Import |
| `<space>a` | 全部诊断（错误/警告） |
| `<space>o` | 当前文件符号（也可用 `;v` 侧栏大纲） |
| `<space>s` | 全项目符号搜索 |
| `<space>c` | coc 命令列表 |
| `<space>e` | 已装扩展列表 |
| `<space>j` / `<space>k` / `<space>p` | coc 列表里下一条 / 上一条 / 恢复上次列表 |

补全：`<Tab>` / `<S-Tab>` 选择，`<CR>` 确认。

**关于行内提示（inlay hints）**：代码里那些灰斜体的小字是 LSP 提示，不是代码。

| 提示 | 内容 | 当前 |
|---|---|---|
| 变量类型 | `users: List[User]` | 开 |
| 函数返回类型 | 函数定义处的返回类型 | 开 |
| 调用处参数名 | `print(values: …)`、`User(name: …)` | **关**（太吵） |

颜色是 `CocInlayHint`（灰 `#5c6370` + 斜体），在 vimrc 的 `s:DimInlayHints()` 里改。
想全关：`coc-settings.json` 里把 `pyright.inlayHints.variableTypes` / `functionReturnTypes`、
`rust-analyzer.inlayHints.typeHints.enable` 设成 `false`；想再开参数名提示，把对应的
`parameterTypes` / `parameterHints.enable` 设回 `true`。

### 3.3 语言工作流（Go / Python / Shell / Rust 同一套键）

| 键 | 含义 | Rust | Go | Python | Shell |
|---|---|---|---|---|---|
| `;b` | 构建 / 检查 | `cargo build` | `go build ./...` | `python3 -m py_compile` | `shellcheck` |
| `;r` | 运行 | `cargo run` | `go run .` | `python3 文件` | `bash 文件` |
| `;T` | 测试 | `cargo test` | `go test ./...` | `pytest`（无则 `unittest`） | 无（提示用 `;b`） |
| `;e` | 错误/输出列表（开/关切换） | 同 | 同 | 同 | 同 |
| `;f` | 格式化 | `rustfmt` | `goimports` | `ruff format` | `shfmt -i 2 -ci` |
| `;g` | 终端里跑（要 stdin 时） | `cargo run` | `go run .` | `python3` | `bash` |

Python 专用：

| 键 | 作用 |
|---|---|
| `;F` / `:Import` | 一键整理当前文件的 import，三件事：**补**缺失的（`autoimport`）、**删**没用到的、**分组排序**（`ruff check --select I,F401 --fix`，标准库 / 第三方两组）。补完自动重载缓冲区并按增删行数修正光标（停在原来那行代码上，而不是原来那个行号）。没装 `ruff` 时降级成只做增删，不报错。用大写 `F` 是为了误触时安全（`F` 只会等下一个字符，不会进模式） |
| 补全时选 "Auto-import" 条目 | 单个符号自动带 import（pyright `autoImportCompletions`，coc-pyright 默认开） |
| `:CocCommand pyright.organizeimports` | 反方向：排序并删除未使用的 import |

这套键刻意做成 **两键、小写、无 Shift**：即使手慢导致 Vim 超时放弃序列，落到的普通命令（`b` `e` `f` `g` `m` `r` `T`）也都无害，不会像 `R` 那样跳进替换模式。

说明：

- 所有 `;b/;r/;T` 都会先 `:silent write` 再执行（用 `silent` 是为了不触发 hit-enter 提示）；`;b/;r/;T/;g` 都会把 cwd 切到**项目根**（向上找 `Cargo.toml` / `go.mod`；找不到才用文件目录），所以相对路径（cargo/go 的报错路径）能正确解析。
- 执行完会自动打开 quickfix 窗口把结果停住（**焦点留在源码窗口**，所以可以接着按 `;b`/`;r`）；`;r` 的列表会滚到最后一条，程序输出在末尾。
- 列表显示：有位置的条目是 `文件|行 col 列| 文本`，纯输出行只显示文本，不会出现 `||`。
- 看完用 `;e` 关掉（开/关切换）或 `:q` 关窗口；没有错误/输出时会提示一行，不弹窗口。
- 输出统一进 quickfix：`;e` 打开列表，回车跳到出错行，`:cn` / `:cp` 上下条。
- 格式化失败不会破坏缓冲区内容，只报一行提示；光标位置会保留。

### 3.4 格式化细节

| filetype | 命令 | 备注 |
|---|---|---|
| rust | `rustfmt --edition 2021` | 若项目用 2024 edition，改 `s:FormatBuffer()` 里这一行 |
| go | `goimports -local <module>` | 在 `gofmt` 基础上顺手增删 import，并把 import 分成三组：标准库 / 第三方 / 本地包。`<module>` 从最近的 `go.mod` 第一行读，无 `go.mod` 时退回普通 `goimports`。保存时自动跑同一个 `s:FormatBuffer`，所以 `;f` 和 `:w` 的分组结果一致 |
| python | `ruff format --stdin-filename <当前文件> -` | 只格式化，不跑 lint 修复；带文件名才能读到项目 `pyproject.toml` 的配置 |
| sh / bash / zsh | `shfmt -i 2 -ci` | 2 空格缩进，`case` 分支也缩进 |
| json | `jq .` | 2 空格 |
| yaml | `prettier --stdin-filepath …` | 保留原缩进 |

### 3.5 其它插件默认映射（由插件提供，非本配置定义）

| 键 | 来源 |
|---|---|
| `;cc` / `;cu` / `;cs` / `;c<space>` | nerdcommenter：注释 / 取消 / 花式注释 / 切换 |
| `;tm` | vim-table-mode：切换表格模式 |
| `;tt`（normal） | table-mode：把当前行/选中行格式化成表格 |
| `;T`（visual） | table-mode：带分隔线表格化 |
| `;tr` | vim-translator：翻译光标下的词；Visual 模式翻译选区 |
| `;=` `;:` `;,` `;"` | tabular：按等号 / 冒号 / 逗号 / 双引号对齐 |
| `;1` `;2` `;3` `;0` | 跳到第 1/2/3/最后一个标签页 |

> 查某个键到底绑了什么：`:verbose map <键>`；查 leader 下全部映射：`:map ;`。

---

## 4. 每门语言的日常操作流

### Rust

```sh
cargo new hello && cd hello && vim src/main.rs
```

1. 读代码：`gd` 跳定义、`K` 看签名、`;v` 看本文件结构
2. 改：`;a` 补 `use`、`;m` 改名
3. 查：`;b`（cargo build）→ `;e` 看错误 → 回车跳到行
4. 跑：`;r`；要输入的程序用 `;g`
5. 测试：`;T`
6. 格式化：`;f`

### Go

```sh
vim main.go
```

1. `gd` / `K` / `gr`（gopls）
2. `;b` 编译检查 → `;e`
3. `;r` 运行（`go run .`，需要当前目录是 module）
4. `;T` 测试；保存时自动格式化（`BufWritePre` → `s:FormatBuffer`），也可随时 `;f`

### Python

```sh
vim app.py
```

1. `gd` / `K` / `gr`（pyright）；类型信息看 hover 和补全（这版 pyright 不支持行内 inlay hints，只有 Rust 那边有）
2. `;b` 语法检查（`py_compile`）
3. `;r` 运行 → traceback 会进 quickfix，回车跳到出错行
4. `;T` 测试（装了 pytest 自动用 pytest）
5. `;f` 格式化（ruff）

### Shell

```sh
vim deploy.sh
```

1. `;b` 跑 shellcheck → quickfix 里是 SC2045 / SC2086 这类规则号
2. `;r` 用 bash 跑；要交互用 `;g`
3. `;f` 用 shfmt 按 2 空格格式化（`case` 分支也会缩进）

---

## 5. Rust 常驻 watcher（另开终端面板用，不占 vim）

已安装：`cargo-watch 8.5.3`、`bacon 3.26.0`。

```sh
cargo watch -x check        # 保存即编译检查
cargo watch -x run          # 保存即运行
cargo watch -x 'test -q'    # 保存即跑测试
bacon                       # TUI：诊断可 j/k 翻页
bacon test                  # 切到 test job
bacon --list-jobs
```

在任意子目录启动（自动定位 crate 根），可加进 `~/.zshrc`：

```zsh
watch-rust() {
  local root
  root=$(cargo locate-project --message-format plain 2>/dev/null | xargs dirname 2>/dev/null)
  [[ -z "$root" ]] && { echo "不在 cargo 项目里"; return 1; }
  if (( $# == 0 )); then ( cd "$root" && cargo watch -x check )
  else ( cd "$root" && cargo watch "$@" ); fi
}

bacon-here() {
  local root
  root=$(cargo locate-project --message-format plain 2>/dev/null | xargs dirname 2>/dev/null)
  [[ -z "$root" ]] && { echo "不在 cargo 项目里"; return 1; }
  ( cd "$root" && bacon "$@" )
}
```

注意：`cargo-watch` 和 `bacon` **不要同时开**（抢 `target/` 构建锁，会互相等待）；要 stdin 的程序别用 `-x run`，用 `;g`。

---

## 6. 排查

| 现象 | 检查 |
|---|---|
| 没有补全/跳转 | `:CocList extensions` 看扩展是否 active；`:CocInfo` 看服务状态 |
| 想看 LSP 进程 | `pgrep -fl 'gopls\|rust-analyzer\|pyright\|bash-language-server'` |
| 二进制是否存在 | `:echo executable('gopls')`（同理 `rust-analyzer`/`pyright`/`bash-language-server`） |
| 报错列表空的 | `:echo b:current_compiler`（rust=cargo / go=go / sh=shellcheck） |
| 格式化没反应 | `:echo &filetype` 是否在支持列表；手动跑一次原始命令看报错 |
| 启动变慢/报错 | `vim -V1/tmp/vim.log` 看加载顺序；`:messages` 看警告 |

---

## 7. 维护

```sh
# 插件
vim +PlugInstall +qa          # 安装 vimrc 里新增的 Plug
vim +PlugClean! +qa           # 删除 bundle 下不再引用的目录（! 不逐个询问）

# coc 扩展
vim -c 'CocInstall coc-xxx' -c 'qa'

# 依赖自检
for b in rg nnn gopls pyright bash-language-server shellcheck shfmt ruff \
         rustfmt gofmt goimports cargo-watch bacon jq prettier; do
  printf '%-24s %s\n' "$b" "$(command -v $b || echo MISSING)"
done
```

回滚：`cp ~/.vim/vimrc.bak.<时间戳> ~/.vim/vimrc`

---

## 8. 已知取舍与默认值

- **不装 vim-go**。它的三块能力都已有替代，留着反而是 bug 来源（曾用 buffer-local 映射抢走
  `gd` / `K` / `<C-]>`、另起一套 gopls 导致 6 个进程、`go_fmt_command` 静默降级成 `gofmt`
  使 import 分组失效）：
  - 语法 / 缩进 / `compiler` → Vim 9.2 内置（实测禁用 vim-go 后 `;b` / `;r` / `;f` 和高亮缩进全部正常）
  - 跳转 / 悬停 / 补全 / 重命名 → coc-go
  - `:GoAddTags` / `:GoImpl` / `:GoTestFunc` / `:GoPlay` → coc-go 的 `go.tags.add` /
    `go.impl.cursor` / `go.test.generate.*` / `go.playground`（`:CocCommand` 调用）
  - 保存时格式化 → 自己的 `GoFormatOnSave` autocmd
  另外 vim-go 的 15 个外部依赖本机只装了 4 个，`:GoAddTags` 这类命令实测本来就跑不动
  （缺 `gomodifytags`）。需要调试器时 `dlv` 已装，可直接用 `:CocCommand go.` 系列或命令行。
- Python 的 quickfix 由 `s:PythonQuickfix()` 重建（Vim 的 `errorformat` 对 `File "...", line N` 匹配不稳定）。
- `:Format` 命令与 `;f` 等价，都走原生 formatter。
- `;F` 为什么要串两个工具：`autoimport` 能**补**缺失的 import 但不排序（实测输出里
  `from` 会排在 `import` 前面）；`ruff --select I` 能分组排序、`F401` 能删未使用，但
  **不能补**缺失的。两者职责不重叠，所以先 `autoimport` 再 `ruff`。
  已知局限：`autoimport` 补不了 `collections` 的部分成员（如 `defaultdict`），
  这类用补全列表里的 Auto-import 条目，或手写。
- Python 的补 import 用 `;F`（`autoimport`）而不是 `;a`：pyright 对
  "X is not defined" 这类诊断**不提供任何 code action**（实测在诊断位置取到 0 个），
  它的 auto-import 只在补全列表里出现。Rust（rust-analyzer）和 Go（gopls）则在
  code action 里给 `Import …` / `Add import`，所以这两门语言用 `;a` 即可。
- `;a` 不是裸的 `<Plug>(coc-codeaction-cursor)`：LSP 只在光标精确落在报错符号的列范围内
  才返回 `Import`（实测 `impl fmt::Display for P` 这行，只有 col 6–18 有，行首 `impl`
  和行尾 `for P` 都是 0 个）。所以 `;a` 先原地取，没有 `quickfix` 类动作时自动跳到本行
  诊断的起始列再取。判定按动作的 `kind` 而不是个数——gopls 在任何位置都会返回一个
  `Browse gopls feature documentation`，只数个数的话 Go 永远不会触发这个兜底。
- 工作流用两键小写（`;b ;r ;T ;e ;f ;g`），重命名在 `;m`。早期用 `;R*` 三键方案，因为超时后 `R` 会触发替换模式，已废弃。
- 映射后面**不能写行尾注释**（`:help map-comments`）：`"` 之后的内容会被算进 `{rhs}` 当按键执行。
  本配置所有说明都写在映射的上一行。
- Markdown 预览插件（依赖 `yarn`）已移除；需要时再加，并先 `brew install yarn`。

与常见默认不同的几处（都是有意为之）：

| 设置 | 值 | 为什么 |
|---|---|---|
| `undofile` | 开，目录 `~/.vim/undo` | 崩溃/误操作后重开文件仍能 `u` 撤销 |
| `nobackup` / `nowritebackup` / `noswapfile` | 全关 | 项目里不会出现 `文件~` 和 `.swp`；恢复靠上面的 undofile |
| `foldlevel` | 99 | 默认展开所有折叠（原来 0 = 全折叠）；要默认折叠改回 0 |
| `completeopt` | `menuone,noinsert,noselect` | coc 推荐值，配合 `<Tab>` / `<CR>` |
| `iskeyword` | 默认 | 不再把 `-` `#` `@` `%` `$` 并入单词，避免影响 `w` / `*` / `iw` / `gd` |
| `timeoutlen` / `ttimeoutlen` | 800 / 50 | 映射序列的按键间隔上限 0.8s；终端按键序列 50ms 内判定 |
| `updatetime` | 300 | coc 诊断与符号刷新跟着变快（默认 4000） |
| `autochdir` | **关** | 开着会冲掉工作流切到项目根的 `:lcd`，并把 fzf / `:make` 的基准缩到当前子目录 |
| `smartindent` | 关 | `filetype indent` 已接管；它会把没有 `indentexpr` 的文件里 `#` 开头的行顶到第 0 列 |
| `signcolumn` | `number` | 诊断符号画在行号列上，coc 报错时正文不横向抖动，也不额外占宽度 |
| `scroll` | 不设 | 它是窗口局部选项，改窗口大小就被重置成半屏；滚动 1 行改用 `<C-d>` / `<C-u>` 映射 |
| `lazyredraw` | 关 | 官方文档说它只适合临时打开（`may cause display errors`），常开会让 quickfix / coc 弹窗「闪一下再定住」 |
| `undodir` | `~/.vim/undo`，启动时自动创建 | 目录不存在时 `undofile` 会**静默失效**（连 `undofile()` 都返回空），换机器/新克隆必踩 |
