# ╔══════════════════════════════════════════════════════════════════════════════╗
# ║  KONFIGURASI ZSH PRIBADI - CACHYOS                                         ║
# ╚══════════════════════════════════════════════════════════════════════════════╝

# ──────────────────────────────────────────────────────────────────────────────
# ENVIRONMENT & PATH
# ──────────────────────────────────────────────────────────────────────────────

# Docker / Podman
export DOCKER_HOST=unix:///run/user/$(id -u)/podman/podman.sock

# Variabel lingkungan umum
export MICRO_TRUECOLOR=1
export BAT_THEME="Catppuccin Mocha"
export EDITOR=fresh
export FZF_BASE=/usr/share/fzf

# FZF
export FZF_DEFAULT_OPTS="--height 70% \
--layout=reverse \
--border=top \
--style=full \
--preview '~/.local/bin/fzf-preview.sh {}' \
--bind 'focus:transform-header:file --brief {} 2>/dev/null || echo {}'"

# Path utama - urutan penting: user bins > system
typeset -U path
path=(
  $HOME/go/bin
  $HOME/bin
  $HOME/.local/bin
  $HOME/.local/share/fnm
  $HOME/.cargo/bin
  $HOME/.bun/bin
  $HOME/.config/herd-lite/bin
  $path
)
export PATH

# FNM (Node version manager) - lazy load
if (( $+commands[fnm] )); then
  eval "$(fnm env --use-on-cd --shell zsh)"
fi

# Zoxide (replace cd, keep completion)
if (( $+commands[zoxide] )); then
  eval "$(zoxide init zsh --cmd cd)"
fi

# Bun completion
[[ -s "$HOME/.bun/_bun" ]] && source "$HOME/.bun/_bun"

# Atuin (history)
. "$HOME/.atuin/bin/env"
eval "$(atuin init zsh)"

# Herd Lite (PHP)
export PHP_INI_SCAN_DIR="/home/ryoukaii/.config/herd-lite/bin:$PHP_INI_SCAN_DIR"

# OpenClaw completion
[[ -f "/home/ryoukaii/.openclaw/completions/openclaw.zsh" ]] && source "/home/ryoukaii/.openclaw/completions/openclaw.zsh"

# ──────────────────────────────────────────────────────────────────────────────
# PLUGIN & KONFIGURASI DASAR
# ──────────────────────────────────────────────────────────────────────────────

plugins=(
  git         # Pintasan git & status di prompt
  fzf         # Fuzzy finder
  extract     # Ekstrak arsip dengan perintah 'x'
)

# Load konfigurasi bawaan CachyOS
source /usr/share/cachyos-zsh-config/cachyos-config.zsh

# ──────────────────────────────────────────────────────────────────────────────
# HISTORY & COMPLETION
# ──────────────────────────────────────────────────────────────────────────────

# PROMPT_COMMAND milik bash, bukan zsh
unset PROMPT_COMMAND

# History settings
HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000
SAVEHIST=10000
HISTDUP=erase
HIST_STAMPS="yyyy-mm-dd"

setopt APPEND_HISTORY
setopt INC_APPEND_HISTORY
setopt INC_APPEND_HISTORY_TIME
setopt SHARE_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS

# Completion
zmodload zsh/complist
setopt AUTO_MENU
setopt MENU_COMPLETE

# Completion styling
zstyle ':completion:*' group-name ''
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# Autosuggest
ZSH_AUTOSUGGEST_STRATEGY=(history)
ZSH_AUTOSUGGEST_USE_ASYNC=1
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=50

# ──────────────────────────────────────────────────────────────────────────────
# OPSI ZSH
# ──────────────────────────────────────────────────────────────────────────────

setopt AUTO_CD              # cd tanpa mengetik 'cd'
setopt AUTO_PUSHD           # pushd otomatis saat cd
setopt PUSHD_IGNORE_DUPS    # tidak simpan duplikat di stack
setopt CORRECT              # koreksi typo perintah
setopt INTERACTIVE_COMMENTS # izinkan komentar di command line

# ──────────────────────────────────────────────────────────────────────────────
# KEYBINDINGS
# ──────────────────────────────────────────────────────────────────────────────

bindkey '^P' up-line-or-history
bindkey '^N' down-line-or-history
bindkey '^F' forward-char
bindkey '^B' backward-char
bindkey '^[[1;5D' backward-word
bindkey '^[[1;5C' forward-word

# Edit command line in $EDITOR
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^X^E' edit-command-line
bindkey '^Xe' edit-command-line

# Autosuggest accept
bindkey '^ ' autosuggest-accept

# ──────────────────────────────────────────────────────────────────────────────
# ALIAS
# ──────────────────────────────────────────────────────────────────────────────

# Eza (better ls)
EZA_IGNORE='node_modules|vendor|dist|build|coverage|.git|.next|.nuxt|target'

_eza() {
  local has_tree=false
  for arg in "$@"; do
    [[ "$arg" == "--tree" ]] && has_tree=true
  done

  if $has_tree; then
    eza --icons --group-directories-first --color=auto --ignore-glob="$EZA_IGNORE" "$@"
  else
    eza --icons --group-directories-first --color=auto "$@"
  fi
}

alias ls='_eza'
alias ll='_eza -lh --git'
alias la='_eza -la --git'
alias lt='_eza --tree --level=2'
alias lta='_eza --tree --level=2 -a'

# Navigasi cepat
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias ~='cd ~'
alias -- -='cd -'
alias zshconfig='cd ~/ZSH-Config'

# Git
alias g='git'
alias gs='git status -sb'
alias gl='git log --oneline -15'
alias gb='git branch'
alias gc='git commit'
alias gp='git push'
alias gpl='git pull'
alias gd='git diff'
alias gco='git checkout'
alias gcb='git checkout -b'

# Build
alias mk='make -j$(nproc)'
alias mkc='make clean -j$(nproc)'

# Pacman (Arch/CachyOS)
alias update='sudo pacman -Syu'
alias rmpkg='sudo pacman -Rsn'
alias cleanch='sudo pacman -Scc'
alias fixpacman='sudo rm /var/lib/pacman/db.lck'
alias cleanup='sudo pacman -Rsn $(pacman -Qtdq)'

# Clipboard
alias wl='wl-copy <'

# Alias lucu
alias apt='man pacman'
alias apt-get='man pacman'
alias please='sudo'

# Logs
alias jctl='journalctl -p 3 -xb'

# Misc
alias tb='nc termbin.com 9999'
alias f='fresh'
alias sail='sh $([ -f sail ] && echo sail || echo vendor/bin/sail)'

# rg + fzf
alias rgf='rg --line-number --no-heading . | fzf \
  --delimiter=":" \
  --nth=3.. \
  --preview "~/.local/bin/fzf-preview.sh {1}:{2} 2>/dev/null" \
  --preview-window "right:60%:+{2}-5" \
  --bind "focus:transform-header:echo {1} 2>/dev/null"'

# ──────────────────────────────────────────────────────────────────────────────
# PLUGINS (urutan penting!)
# ──────────────────────────────────────────────────────────────────────────────

# pkgfile "command not found"
source /usr/share/doc/pkgfile/command-not-found.zsh

# fzf keybind
source /usr/share/fzf/key-bindings.zsh

# Plugin order penting
source /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

# ──────────────────────────────────────────────────────────────────────────────
# FUNCTIONS
# ──────────────────────────────────────────────────────────────────────────────

# rmnoext — Hapus file tanpa ekstensi
rmnoext() {
  fd --type f --no-ignore-vcs \
    --exclude .git \
    --exclude node_modules \
    --exclude vendor \
    "^[^.]+$" -0 |
  tee /dev/stderr |
  xargs -0 -r -p rm --
}

# mkcd — Buat folder dan langsung masuk
mkcd() {
  [[ -z "$1" ]] && return 1
  mkdir -p -- "$1" && cd -- "$1"
}

# compile — Compile & run C
compile() {
  [[ -z "$1" ]] && echo "Usage: compile <file.c>" && return 1
  (( ! $+commands[clang] )) && echo "clang not installed" && return 1

  local src="$1"
  shift

  [[ ! -f "$src" ]] && echo "File not found: $src" && return 1

  mkdir -p bin
  local out="bin/${src:t:r}"

  echo "⚙️ compiling..."

  if clang -O2 -Wall -Wextra -std=c23 "$src" -o "$out"; then
    echo "▶ running..."
    "$out" "$@"
  else
    echo "❌ compile failed"
    return 1
  fi
}

# gacp — Add + Commit + Push
gacp() {
  if [[ -z "$1" ]]; then
    echo "⚠️  Penggunaan: gacp \"pesan commit\""
    return 1
  fi

  local branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
  [[ -z "$branch" ]] && echo "❌ Bukan repositori Git!" && return 1

  local remote_url=$(git remote get-url origin 2>/dev/null)
  if [[ "$remote_url" =~ ^https:// ]]; then
    echo "⚠️  Repo masih menggunakan HTTPS: $remote_url"
    echo "👉 Disarankan menggunakan SSH."
    echo ""
  fi

  echo "📦 Commit ke branch: $branch"
  git add . && git commit -m "$1" || return 1

  if git ls-remote origin &>/dev/null; then
    git push -u origin "$branch" && echo "🚀 Berhasil push ke $branch!"
  else
    echo "⚠️  Offline. Jalankan 'git push' saat online."
  fi
}

# gac — Add + Commit
gac() {
  if [[ -z "$1" ]]; then
    echo "⚠️  Penggunaan: gac \"pesan commit\""
    return 1
  fi

  local branch
  branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
  [[ -z "$branch" ]] && { echo "❌ Bukan repositori Git!"; return 1; }

  echo "📦 Commit ke branch: $branch"
  git add . && git commit -m "$1"
}

# gaacp — AI commit
gaacp() {
  local branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
  [[ -z "$branch" ]] && echo "❌ Bukan repositori Git!" && return 1
  [[ -z "$(git status --porcelain)" ]] && echo "⚠️  Tidak ada perubahan." && return 1

  if ! command -v aicommits >/dev/null 2>&1; then
    echo "❌ 'aicommits' belum terinstall."
    echo "👉 https://github.com/Nutlope/aicommits"
    return 1
  fi

  echo "📦 Membuat pesan commit dengan AI..."
  git add . || return 1
  aicommits || return 1

  if git ls-remote origin &>/dev/null; then
    git push -u origin "$branch" && echo "🚀 Berhasil push ke $branch!"
  else
    echo "⚠️  Offline. Jalankan 'git push' saat online."
  fi
}

# zpush — Commit & push ZSH-Config
zpush() {
  local repo="$HOME/ZSH-Config"
  [[ -d "$repo/.git" ]] || { echo "❌ Repository tidak ditemukan: $repo"; return 1; }
  [[ -n "$(git -C "$repo" status --porcelain)" ]] || { echo "⚠️ Tidak ada perubahan untuk di-commit."; return 0; }

  local branch
  branch=$(git -C "$repo" rev-parse --abbrev-ref HEAD)

  git -C "$repo" add . || return 1

  if [[ -n "$1" ]]; then
    git -C "$repo" commit -m "$1" || return 1
  else
    command -v aicommits >/dev/null 2>&1 || { echo "❌ 'aicommits' belum terinstall."; return 1; }
    echo "🤖 Membuat commit dengan AI..."
    (cd "$repo" && aicommits) || return 1
  fi

  echo "🌐 Mengecek koneksi ke remote..."
  git -C "$repo" ls-remote origin &>/dev/null || { echo "⚠️ Tidak dapat menghubungi remote."; return 1; }

  echo "🚀 Push ke branch '$branch'..."
  git -C "$repo" push -u origin "$branch" || { echo "❌ Push gagal."; return 1; }

  echo "✅ ZSH-Config berhasil dipush!"
}

# githack — Convert GitHub URL ke raw.githack.com
githack() {
  if [[ -z "$1" ]]; then
    echo "⚠️  Penggunaan: githack <github-url>"
    return 1
  fi

  local url="$1" out=""

  case "$url" in
    *raw.githack.com*)
      out="$url"
      ;;
    *raw.githubusercontent.com*)
      if [[ "$url" =~ 'raw.githubusercontent.com/([^/]+)/([^/]+)/([^/]+)/(.*)' ]]; then
        out="https://raw.githack.com/${match[1]}/${match[2]}/${match[3]}/${match[4]}"
      fi
      ;;
    *github.com*/blob/*)
      if [[ "$url" =~ 'github.com/([^/]+)/([^/]+)/blob/([^/]+)/(.*)' ]]; then
        out="https://raw.githack.com/${match[1]}/${match[2]}/${match[3]}/${match[4]}"
      fi
      ;;
    *)
      echo "❌ URL GitHub tidak valid"
      return 1
      ;;
  esac

  echo "🌐 $out"

  if (( $+commands[xclip] )); then
    echo -n "$out" | xclip -selection clipboard
    echo "📋 Disalin ke clipboard!"
  fi
}

# bench — Benchmark command
bench() {
  command time -f "\n⏱ real %E\n🧠 user %U\n⚙ sys %S" "$@"
}

# y — Yazi wrapper (auto cd on exit)
function y() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
  command yazi "$@" --cwd-file="$tmp"
  IFS= read -r -d '' cwd < "$tmp"
  [ "$cwd" != "$PWD" ] && [ -d "$cwd" ] && builtin cd -- "$cwd"
  rm -f -- "$tmp"
}

# Auto ls saat pindah folder
chpwd() {
  eza --icons --group-directories-first
}

# ──────────────────────────────────────────────────────────────────────────────
# HELP
# ──────────────────────────────────────────────────────────────────────────────

zhelp() {
  echo "🚀 ZSH Custom Commands"
  echo ""
  echo "mkcd <dir>       → buat folder & masuk"
  echo "compile file.c   → compile & run C"
  echo "gacp \"msg\"      → add + commit + push"
  echo "gaacp            → AI commit"
  echo "zpush            → backup .zshrc"
  echo "githack <url>    → convert GitHub URL"
  echo "bench <cmd>      → benchmark command"
  echo "y                → yazi wrapper"
}

# ──────────────────────────────────────────────────────────────────────────────
# PROMPT
# ──────────────────────────────────────────────────────────────────────────────

eval "$(starship init zsh)"

# Disable flow control (Ctrl+S/Ctrl+Q)
stty -ixon