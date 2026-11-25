#!/usr/bin/env bash
# 新机器一键装齐这套 vim 配置的依赖（macOS / Linux 通用）。
#
# 用法：  ~/.vim/bootstrap.sh          检查依赖并按锁定版本装插件
#         ~/.vim/bootstrap.sh --check  只检查，缺依赖时退出码 1
#
# 插件版本由 plugins.lock.vim 锁定；coc 扩展由 vimrc 的
# g:coc_global_extensions 声明，首次启动 coc 会自动装。
#
# 脚本只提示命令，不自动执行安装——装系统包要不要 sudo、用哪个源，
# 交给你自己决定更安全。

set -uo pipefail

CHECK_ONLY=0
[ "${1:-}" = "--check" ] && CHECK_ONLY=1

red() { printf '\033[31m%s\033[0m' "$*"; }
grn() { printf '\033[32m%s\033[0m' "$*"; }
ylw() { printf '\033[33m%s\033[0m\n' "$*"; }
have() { command -v "$1" >/dev/null 2>&1; }

# ---- 探测包管理器 ----------------------------------------------------
PM=""
PM_INSTALL=""
SUDO=""
if [ "$(id -u)" != "0" ] && have sudo; then
  SUDO="sudo "
fi

if have brew; then
  PM="brew";    PM_INSTALL="brew install"
elif have apt-get; then
  PM="apt";     PM_INSTALL="${SUDO}apt-get install -y"
elif have dnf; then
  PM="dnf";     PM_INSTALL="${SUDO}dnf install -y"
elif have pacman; then
  PM="pacman";  PM_INSTALL="${SUDO}pacman -S --needed"
elif have zypper; then
  PM="zypper";  PM_INSTALL="${SUDO}zypper install -y"
elif have apk; then
  PM="apk";     PM_INSTALL="${SUDO}apk add"
fi

# 同一个工具在各发行版里的包名不同，查表取当前平台的名字。
# 格式: "brew|apt|dnf|pacman|zypper|apk"，"-" 表示该平台没有现成包
pkg() {
  local table="$2" idx
  case "$PM" in
    brew) idx=1 ;; apt) idx=2 ;; dnf) idx=3 ;;
    pacman) idx=4 ;; zypper) idx=5 ;; apk) idx=6 ;;
    *) echo ""; return ;;
  esac
  echo "$table" | cut -d'|' -f"$idx"
}

MISSING=()

# need <命令> <包名表> [备注]
need() {
  local cmd="$1" table="$2" note="${3:-}"
  if have "$cmd"; then
    printf '  %-16s %s %s\n' "$cmd" "$(grn ✓)" "$note"
    return
  fi
  MISSING+=("$cmd")
  local name; name="$(pkg "$cmd" "$table")"
  local hint
  if [ -z "$PM" ]; then
    hint="（未识别包管理器，请自行安装）"
  elif [ -z "$name" ] || [ "$name" = "-" ]; then
    hint="（$PM 无现成包，见下方「手动安装」）"
  else
    hint="$PM_INSTALL $name"
  fi
  printf '  %-16s %s %s\n' "$cmd" "$(red ✗)" "$hint"
}

# need_cmd <命令> <固定安装命令> —— 不走系统包管理器的
need_cmd() {
  if have "$1"; then
    printf '  %-16s %s\n' "$1" "$(grn ✓)"
  else
    MISSING+=("$1")
    printf '  %-16s %s %s\n' "$1" "$(red ✗)" "$2"
  fi
}

echo "平台: $(uname -s)  包管理器: ${PM:-未识别}"
echo

echo "== 1. 基础 =="
need vim  "vim|vim|vim|vim|vim|vim"                     "需 9.0+（自带 go 的 syntax/indent/compiler）"
need git  "git|git|git|git|git|git"
need node "node|nodejs|nodejs|nodejs|nodejs|nodejs"     "coc.nvim 必需"
need rg   "ripgrep|ripgrep|ripgrep|ripgrep|ripgrep|ripgrep"  "fzf 的文件源"
need fzf  "fzf|fzf|fzf|fzf|fzf|fzf"                     "<C-p> 找文件"
need nnn  "nnn|nnn|nnn|nnn|nnn|nnn"                     ";n 文件浏览器"

echo "== 2. 格式化 / 检查（;f 和 ;b 用）=="
need shfmt      "shfmt|-|shfmt|shfmt|-|shfmt"
need shellcheck "shellcheck|shellcheck|ShellCheck|shellcheck|ShellCheck|shellcheck"
need jq         "jq|jq|jq|jq|jq|jq"
need prettier   "prettier|-|-|prettier|-|-"
need ruff       "ruff|-|-|ruff|-|-"                     "Python 格式化 + ;F 的 import 分组"
need_cmd autoimport "pipx install autoimport     # ;F 补缺失的 import"

echo "== 3. 语言工具链 =="
need go "go|golang|golang|go|go|go"
need_cmd goimports     "go install golang.org/x/tools/cmd/goimports@latest"
need_cmd cargo         "curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh"
need_cmd rustfmt       "rustup component add rustfmt"
need_cmd rust-analyzer "rustup component add rust-analyzer"
need python3 "python3|python3|python3|python|python3|python3"

echo
# 系统包管理器里通常没有的，补充说明
NEED_MANUAL=0
for m in "${MISSING[@]:-}"; do
  case "$m" in shfmt|prettier|ruff) NEED_MANUAL=1 ;; esac
done
if [ "$NEED_MANUAL" = 1 ] && [ "$PM" != "brew" ]; then
  echo "手动安装（多数 Linux 发行版没有现成包）："
  echo "  shfmt     go install mvdan.cc/sh/v3/cmd/shfmt@latest"
  echo "  prettier  npm install -g prettier"
  echo "  ruff      pipx install ruff   或  pip install --user ruff"
  echo
fi

if [ ${#MISSING[@]} -eq 0 ]; then
  printf '%s\n' "$(grn 所有依赖齐全。)"
else
  ylw "缺 ${#MISSING[@]} 个：${MISSING[*]}"
  if [ $CHECK_ONLY -eq 1 ]; then
    exit 1
  fi
  echo "按上面各行右侧的命令装好后重跑本脚本。缺的工具只影响对应语言，"
  echo "不装也能用 vim，到时候 ;f / ;b 会提示命令不存在。"
  echo
fi

if [ $CHECK_ONLY -eq 1 ]; then
  exit 0
fi

echo "== 4. 安装插件（按 plugins.lock.vim 锁定的版本）=="
if [ -f "$HOME/.vim/plugins.lock.vim" ]; then
  vim -S "$HOME/.vim/plugins.lock.vim" +qa
  printf '%s\n' "$(grn 插件已按锁定版本安装。)"
else
  ylw "没有 plugins.lock.vim，改用最新版安装"
  vim +PlugInstall +qa
fi

echo
echo "== 5. coc 扩展 =="
echo "   首次启动 vim 时 coc 会按 g:coc_global_extensions 自动安装，装完会提示重启。"

echo
printf '%s\n' "$(grn 完成。打开一个 .go / .rs / .py 文件验证：gd 跳转、;b 构建、;f 格式化。)"
