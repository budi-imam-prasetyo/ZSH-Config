export DOCKER_HOST=unix:///run/user/$(id -u)/podman/podman.sock

# ╔══════════════════════════════════════════════════════════════════════════════╗
# ║                     🚀 KONFIGURASI ZSH PRIBADI - CACHYOS                     ║
# ╚══════════════════════════════════════════════════════════════════════════════╝

# ┌──────────────────────────────────────────────────────────────────────────────┐
# │ 🔌 PLUGIN & KONFIGURASI DASAR                                                │
# └──────────────────────────────────────────────────────────────────────────────┘

plugins=(
  git      # Pintasan git & status di prompt
  fzf      # Fuzzy finder
  extract  # Ekstrak arsip dengan perintah 'x'
)

# Load konfigurasi bawaan CachyOS
source /usr/share/cachyos-zsh-config/cachyos-config.zsh

# ┌──────────────────────────────────────────────────────────────────────────────┐
# │ ⚠️  FIX HISTORY, AUTOSUGGEST & COMPLETION                                    │
# └──────────────────────────────────────────────────────────────────────────────┘

# PROMPT_COMMAND milik bash, bukan zsh
unset PROMPT_COMMAND

# History
HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000
SAVEHIST=10000
HIST_STAMPS="yyyy-mm-dd"

# Format history
setopt EXTENDED_HISTORY

# Sync history realtime antar terminal
setopt SHARE_HISTORY

# Hindari duplicate history
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_FIND_NO_DUPS
setopt HIST_SAVE_NO_DUPS
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_VERIFY

# Completion system (zmodload harus sebelum compinit)
zmodload zsh/complist
autoload -Uz compinit
compinit

# Completion behavior
setopt AUTO_MENU
setopt MENU_COMPLETE

# Interactive completion menu
zstyle ':completion:*' menu select
zstyle ':completion:*' group-name ''
zstyle ':completion:*' verbose yes
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# Autosuggestion
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_USE_ASYNC=1
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=50

# Keybindings
bindkey '^[[A' up-line-or-history
bindkey '^[[B' down-line-or-history
bindkey '^[[C' forward-char
bindkey '^[[D' backward-char
bindkey '^[[1;5D' backward-word
bindkey '^[[1;5C' forward-word
bindkey -r '^S'

autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^x^x' edit-command-line

# Accept autosuggestion
bindkey '^ ' autosuggest-accept

# ┌──────────────────────────────────────────────────────────────────────────────┐
# │ 🌍 ENVIRONMENT & PATH                                                        │
# └──────────────────────────────────────────────────────────────────────────────┘

typeset -U path  # Cegah duplikasi path

path=(
  $JAVA_HOME/bin
  $HOME/bin
  $HOME/.local/bin
  $HOME/.local/share/fnm
  $HOME/.cargo/bin
  $HOME/.bun/bin
  $HOME/go/bin
  $HOME/.config/herd-lite/bin
  $path
)

export PATH
export MICRO_TRUECOLOR=1
export BAT_THEME="Catppuccin Mocha"
export PHP_INI_SCAN_DIR="/home/ryoukaii/.config/herd-lite/bin:$PHP_INI_SCAN_DIR"

# ── Inisialisasi Tool ─────────────────────────────────────────────────────────

# fnm
(( $+commands[fnm] )) && eval "$(fnm env --use-on-cd --shell zsh)"

# zoxide (replace cd tanpa merusak completion)
(( $+commands[zoxide] )) && eval "$(zoxide init zsh --cmd cd)"

# Bun completion
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# ┌──────────────────────────────────────────────────────────────────────────────┐
# │ 🔎 FZF                                                                       │
# └──────────────────────────────────────────────────────────────────────────────┘

export FZF_DEFAULT_OPTS="--height 70% \
--layout=reverse \
--border=top \
--style=full \
--preview '~/.local/bin/fzf-preview.sh {}' \
--bind 'focus:transform-header:file --brief {} 2>/dev/null || echo {}'"

export FZF_BASE=/usr/share/fzf

# ┌──────────────────────────────────────────────────────────────────────────────┐
# │ ⚙️  OPSI ZSH                                                                 │
# └──────────────────────────────────────────────────────────────────────────────┘

setopt AUTO_CD
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS
setopt CORRECT
setopt INTERACTIVE_COMMENTS

# ┌──────────────────────────────────────────────────────────────────────────────┐
# │ 🎨 ALIAS                                                                     │
# └──────────────────────────────────────────────────────────────────────────────┘

# ── Listing & Navigasi ────────────────────────────────────────────────────────

EZA_IGNORE='node_modules|vendor|dist|build|coverage|.git|.next|.nuxt|target'

_eza() {
  emulate -L zsh
  local has_tree=false
  for arg in "$@"; do
    [[ "$arg" == "--tree" || "$arg" == "-T" ]] && has_tree=true
  done

  if $has_tree; then
    command eza --icons --group-directories-first --color=auto -I "$EZA_IGNORE" "$@"
  else
    command eza --icons --group-directories-first --color=auto "$@"
  fi
}

alias ls='_eza'
alias ll='_eza -lh --git'
alias la='_eza -la --git'
alias lt='_eza -T --level=2'
alias lta='_eza -Ta --level=2'

alias ..='cd ..'
alias -- -='cd -'

# ── Sistem & Produktivitas ────────────────────────────────────────────────────

alias c='clear'
alias q='exit'

alias zconfig='code ~/ZSH-Config'
alias zreload='exec zsh'

# ── Pintasan Pengembangan ─────────────────────────────────────────────────────

alias ga='git add .'
alias gs='git status -sb'
alias gl='git log --oneline -15'
alias gd='git diff'

# Docker Laravel
alias artisan='docker compose exec app php artisan'
alias composer='docker compose exec app composer'

# ── Build ─────────────────────────────────────────────────────────────────────

alias make="make -j$(nproc)"
alias n="ninja -j$(nproc)"

# ── Pacman ────────────────────────────────────────────────────────────────────

alias rmpkg="sudo pacman -Rsn"
alias cleanch="sudo pacman -Scc"
alias fixpacman="sudo rm /var/lib/pacman/db.lck"
alias update="sudo pacman -Syu"

# Cleanup orphaned packages
alias cleanup="sudo pacman -Rsn \$(pacman -Qtdq)"

# ── Arch Helper ───────────────────────────────────────────────────────────────

alias wl="wl-copy <"
alias apt="man pacman"
alias apt-get="man pacman"
alias please="sudo"

# ── Logs ──────────────────────────────────────────────────────────────────────

alias jctl="journalctl -p 3 -xb"

# ── Misc ──────────────────────────────────────────────────────────────────────

alias tb="nc termbin.com 9999"

alias f="fresh"

alias sail='sh $([ -f sail ] && echo sail || echo vendor/bin/sail)'

alias rgf='rg --line-number --no-heading . | fzf \
  --delimiter=":" \
  --nth=3.. \
  --preview "~/.local/bin/fzf-preview.sh {1}:{2} 2>/dev/null" \
  --preview-window "right:60%:+{2}-5" \
  --bind "focus:transform-header:echo {1} 2>/dev/null"'

# ┌──────────────────────────────────────────────────────────────────────────────┐
# │ 🔌 PLUGINS                                                                   │
# └──────────────────────────────────────────────────────────────────────────────┘

# pkgfile "command not found"
source /usr/share/doc/pkgfile/command-not-found.zsh

# fzf keybind
source /usr/share/fzf/key-bindings.zsh

# Plugin order: autosuggestions → syntax-highlighting → history-substring-search
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh

# ┌──────────────────────────────────────────────────────────────────────────────┐
# │ 🛠️  FUNCTIONS                                                                │
# └──────────────────────────────────────────────────────────────────────────────┘

# rmnoext — Hapus file tanpa ekstensi
rmnoext() {
  emulate -L zsh
  local files
  files=$(fd --type f --no-ignore-vcs \
    --exclude .git \
    --exclude node_modules \
    --exclude vendor \
    --print0 "^[^.]+$" 2>/dev/null)

  if [[ -z "$files" ]]; then
    echo "✅ Tidak ada file tanpa ekstensi"
    return 0
  fi

  printf '%s\0' "$files" | tee /dev/stderr | xargs -0 -r -p rm --
}

# mkcd — Buat folder dan langsung masuk
mkcd() {
  emulate -L zsh
  [[ -z "$1" ]] && { echo "⚠️  Penggunaan: mkcd <directory>"; return 1 }
  mkdir -p -- "$1" || return 1
  cd -- "$1" || return 1
}

# compile — Compile & run C
compile() {
  emulate -L zsh
  [[ -z "$1" ]] && { echo "Usage: compile <file.c>"; return 1 }
  (( ! $+commands[clang] )) && { echo "clang not installed"; return 1 }

  local src="$1"
  shift

  [[ ! -f "$src" ]] && { echo "File not found: $src"; return 1 }

  mkdir -p bin || return 1
  local out="bin/${src:t:r}"

  echo "⚙️ compiling..."

  if clang -O2 -Wall -Wextra -std=c23 "$src" -o "$out"; then
    [[ ! -x "$out" ]] && { echo "❌ Binary tidak executable"; return 1 }
    echo "▶ running..."
    trap 'rm -f "$out"' INT TERM EXIT
    "$out" "$@"
    local ret=$?
    trap - INT TERM EXIT
    return $ret
  else
    echo "❌ compile failed"
    return 1
  fi
}

# gacp — Add + Commit + Push
gacp() {
  emulate -L zsh
  if [[ -z "$1" ]]; then
    echo "⚠️  Penggunaan: gacp \"pesan commit\""
    return 1
  fi

  local branch
  branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
  [[ -z "$branch" ]] && { echo "❌ Bukan repositori Git!"; return 1 }

  local remote_url
  remote_url=$(git remote get-url origin 2>/dev/null)
  if [[ "$remote_url" =~ ^https:// ]]; then
    echo "⚠️  Repo masih menggunakan HTTPS:"
    echo "   $remote_url"
    echo "👉 Disarankan menggunakan SSH."
    echo ""
  fi

  local changes
  changes=$(git status --porcelain)
  [[ -z "$changes" ]] && { echo "⚠️  Tidak ada perubahan."; return 0 }

  echo "📦 Commit ke branch: $branch"

  git add . && git commit -m "$1" || return 1

  if git ls-remote origin &>/dev/null; then
    git push -u origin "$branch" && echo "🚀 Berhasil push ke $branch!" || echo "❌ Push gagal."
  else
    echo "⚠️  Offline. Jalankan 'git push' saat online."
  fi
}

# gac — Add + Commit
gac() {
  emulate -L zsh
  if [[ -z "$1" ]]; then
    echo "⚠️  Penggunaan: gac \"pesan commit\""
    return 1
  fi

  local branch
  branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
  [[ -z "$branch" ]] && { echo "❌ Bukan repositori Git!"; return 1 }

  local changes
  changes=$(git status --porcelain)
  [[ -z "$changes" ]] && { echo "⚠️  Tidak ada perubahan."; return 0 }

  echo "📦 Commit ke branch: $branch"

  git add . && git commit -m "$1" || return 1
}

# gaacp — AI commit
gaacp() {
  emulate -L zsh
  local branch
  branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
  [[ -z "$branch" ]] && { echo "❌ Bukan repositori Git!"; return 1 }

  [[ -z "$(git status --porcelain)" ]] && { echo "⚠️  Tidak ada perubahan."; return 1 }

  if ! command -v aicommits >/dev/null 2>&1; then
    echo "❌ 'aicommits' belum terinstall."
    echo "👉 https://github.com/Nutlope/aicommits"
    return 1
  fi

  echo "📦 Membuat pesan commit dengan AI..."
  # aicommits melakukan git add + commit secara internal
  aicommits || return 1

  if git ls-remote origin &>/dev/null; then
    git push -u origin "$branch" && echo "🚀 Berhasil push ke $branch!" || echo "❌ Push gagal."
  else
    echo "⚠️  Offline. Jalankan 'git push' saat online."
  fi
}

# zpush — Commit & push ZSH-Config
zpush() {
  emulate -L zsh
  local repo="$HOME/ZSH-Config"

  [[ -d "$repo/.git" ]] || {
    echo "❌ Repository tidak ditemukan: $repo"
    return 1
  }

  [[ -n "$(git -C "$repo" status --porcelain)" ]] || {
    echo "⚠️ Tidak ada perubahan untuk di-commit."
    return 0
  }

  local branch
  branch=$(git -C "$repo" rev-parse --abbrev-ref HEAD 2>/dev/null)

  if [[ -z "$branch" || "$branch" == "HEAD" ]]; then
    echo "❌ HEAD detached. Checkout branch dulu."
    return 1
  fi

  git -C "$repo" add . || return 1

  if [[ -n "$1" ]]; then
    git -C "$repo" commit -m "$1" || return 1
  else
    command -v aicommits >/dev/null 2>&1 || {
      echo "❌ 'aicommits' belum terinstall."
      return 1
    }

    echo "🤖 Membuat commit dengan AI..."
    (cd "$repo" && aicommits) || return 1
  fi

  echo "🌐 Mengecek koneksi ke remote..."

  git -C "$repo" ls-remote origin &>/dev/null || {
    echo "⚠️ Tidak dapat menghubungi remote."
    echo "   Periksa koneksi internet, SSH key, atau URL remote."
    return 1
  }

  echo "🚀 Push ke branch '$branch'..."

  git -C "$repo" push -u origin "$branch" || {
    echo "❌ Push gagal."
    return 1
  }

  echo "✅ ZSH-Config berhasil dipush!"
}

# githack — Convert GitHub URL
githack() {
  emulate -L zsh
  if [[ -z "$1" ]]; then
    echo "⚠️  Penggunaan: githack <github-url>"
    return 1
  fi

  local url="$1"
  local out=""

  case "$url" in
    *raw.githack.com*)
      out="$url"
      ;;
    *raw.githubusercontent.com*)
      if [[ "$url" =~ raw\.githubusercontent\.com/([^/]+)/([^/]+)/([^/]+)/(.*) ]]; then
        out="https://raw.githack.com/${match[1]}/${match[2]}/${match[3]}/${match[4]}"
      fi
      ;;
    *github.com*/blob/*)
      if [[ "$url" =~ github\.com/([^/]+)/([^/]+)/blob/([^/]+)/(.*) ]]; then
        out="https://raw.githack.com/${match[1]}/${match[2]}/${match[3]}/${match[4]}"
      fi
      ;;
    *)
      echo "❌ URL GitHub tidak valid"
      return 1
      ;;
  esac

  if [[ -z "$out" ]]; then
    echo "❌ URL tidak valid atau format tidak dikenal"
    return 1
  fi

  echo "🌐 $out"

  if (( $+commands[xclip] )); then
    echo -n "$out" | xclip -selection clipboard
    echo "📋 Disalin ke clipboard!"
  fi
}

# bench — Benchmark command
bench() {
  emulate -L zsh
  local ret
  if (( $+commands[gtime] )); then
    command gtime -f "\n⏱ real %E\n🧠 user %U\n⚙ sys %S" "$@"
    ret=$?
  else
    command time -f "\n⏱ real %E\n🧠 user %U\n⚙ sys %S" "$@"
    ret=$?
  fi
  return $ret
}

# y — Yazi wrapper
function y() {
  emulate -L zsh
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
  [[ -z "$tmp" ]] && { echo "❌ Gagal membuat temp file"; return 1 }

  trap 'rm -f -- "$tmp"' INT TERM EXIT

  command yazi "$@" --cwd-file="$tmp"

  local ret=$?
  trap - INT TERM EXIT

  if [[ -r "$tmp" ]]; then
    IFS= read -r -d '' cwd < "$tmp"
    [[ "$cwd" != "$PWD" ]] && [[ -d "$cwd" ]] && builtin cd -- "$cwd"
  fi

  rm -f -- "$tmp"
  return $ret
}

# Auto ls saat pindah folder
autoload -Uz add-zsh-hook

do-ls() {
  emulate -L zsh
  eza --icons --group-directories-first --color=auto -I "$EZA_IGNORE"
}

add-zsh-hook chpwd do-ls


# ┌──────────────────────────────────────────────────────────────────────────────┐
# │ 📚 HELP                                                                      │
# └──────────────────────────────────────────────────────────────────────────────┘

zhelp() {
  emulate -L zsh
  echo "🚀 ZSH Custom Commands"
  echo ""
  echo "mkcd <dir>       → buat folder & masuk"
  echo "compile file.c   → compile & run C"
  echo "rmnoext          → hapus file tanpa ekstensi"
  echo "gac \"msg\"       → add + commit"
  echo "gacp \"msg\"      → add + commit + push"
  echo "gaacp            → AI commit + push"
  echo "zpush [msg]      → backup .zshrc (AI/auto)"
  echo "githack <url>    → convert GitHub URL"
  echo "bench <cmd>      → benchmark command"
  echo "y [dir]          → yazi wrapper"
}

# ┌──────────────────────────────────────────────────────────────────────────────┐
# │ 🚀 PROMPT                                                                    │
# └──────────────────────────────────────────────────────────────────────────────┘

export EDITOR=fresh

eval "$(starship init zsh)"

# OpenClaw Completion
[ -f "/home/ryoukaii/.openclaw/completions/openclaw.zsh" ] && source "/home/ryoukaii/.openclaw/completions/openclaw.zsh"

. "$HOME/.atuin/bin/env"

eval "$(atuin init zsh)"
stty -ixon
