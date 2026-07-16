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

# Clipboard on accept (detected once; no-op if none available)
if command -v wl-copy >/dev/null 2>&1; then
  _FZF_CLIP_BIND="--bind 'enter,double-click:execute-silent(cat {+f} | wl-copy)+accept'"
elif command -v xclip >/dev/null 2>&1; then
  _FZF_CLIP_BIND="--bind 'enter,double-click:execute-silent(cat {+f} | xclip -selection clipboard)+accept'"
elif command -v xsel >/dev/null 2>&1; then
  _FZF_CLIP_BIND="--bind 'enter,double-click:execute-silent(cat {+f} | xsel --clipboard --input)+accept'"
elif command -v pbcopy >/dev/null 2>&1; then
  _FZF_CLIP_BIND="--bind 'enter,double-click:execute-silent(cat {+f} | pbcopy)+accept'"
else
  _FZF_CLIP_BIND=
fi

export FZF_DEFAULT_OPTS="--height 70% \
--layout=reverse \
--border=top \
--style=full \
--preview '~/.local/bin/fzf-preview.sh {}' \
--bind 'focus:transform-header:file --brief {} 2>/dev/null || echo {}' \
${_FZF_CLIP_BIND}"
unset _FZF_CLIP_BIND

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

# ── Pacman ────────────────────────────────────────────────────────────────────

alias update="sudo pacman -Syu"

# Cleanup orphaned packages
alias cleanup="sudo pacman -Rsn \$(pacman -Qtdq)"

# ── Arch Helper ───────────────────────────────────────────────────────────────

alias wl="wl-copy <"

# ── Logs ──────────────────────────────────────────────────────────────────────

alias jctl="journalctl -p 3 -xb"

# ── Misc ──────────────────────────────────────────────────────────────────────

alias f="fresh"

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

# day — Tambah baris materi belajar ke file, lalu commit+push otomatis
# Usage: day rust.txt "day 1 | Rust Book | https://doc.rust-lang.org/book/"
# Workflow: cd → validasi git/main → pull --rebase → validasi file → append → add/commit/push
day() {
  emulate -L zsh
  setopt localoptions err_return nounset

  local project_dir="/home/ryoukaii/Projects/day"
  local data_dir="$project_dir/src/data"
  local expected_branch="main"
  local filename="$1"
  local input="$2"
  local old_pwd="$PWD"

  # Pulihkan directory saat keluar (Ctrl+C/error)
  trap 'cd -- "$old_pwd" 2>/dev/null; trap - EXIT INT TERM' EXIT INT TERM

  # 1) Validasi parameter
  [[ -n "$filename" ]] || { print -u2 "❌ Error: nama file tidak boleh kosong."; return 1 }
  [[ -n "$input" ]] || { print -u2 "❌ Error: string yang ingin ditambahkan tidak boleh kosong."; return 1 }

  # 2) Cegah path traversal (tolak / dan \)
  [[ "$filename" != *" "* ]] || { print -u2 "❌ Error: nama file tidak boleh mengandung spasi."; return 1 }
  [[ "$filename" != *"/"* ]] || { print -u2 "❌ Error: nama file tidak boleh mengandung '/'."; return 1 }
  [[ "$filename" != *".."* ]] || { print -u2 "❌ Error: nama file tidak boleh mengandung '..'."; return 1 }

  # 3) Masuk ke project
  [[ -d "$project_dir" ]] || { print -u2 "❌ Directory tidak ditemukan: $project_dir"; return 1 }
  cd -- "$project_dir" || { print -u2 "❌ Gagal masuk ke: $project_dir"; return 1 }

  # 4) Pastikan repo Git valid
  git rev-parse --is-inside-work-tree &>/dev/null || { print -u2 "❌ Bukan repositori Git: $project_dir"; return 1 }

  # 5) Pastikan branch main
  local branch
  branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null) || { print -u2 "❌ Gagal membaca branch saat ini."; return 1 }
  [[ "$branch" == "$expected_branch" ]] || { print -u2 "❌ Branch harus '$expected_branch' (sekarang: $branch). Jalankan: git checkout $expected_branch"; return 1 }

  # 6) Pull origin/main dengan rebase
  print "⬇️  git pull --rebase origin $expected_branch..."
  git pull --rebase origin "$expected_branch" || { print -u2 "❌ git pull gagal. Selesaikan konflik/diverged dulu."; return 1 }

  # 7) Validasi file (hanya di dalam $data_dir)
  local target="$data_dir/$filename"
  [[ -f "$target" ]] || { print -u2 "❌ File tidak ditemukan: $target"; return 1 }

  # 8) Cek baris terakhir identik? (skip jika sudah sama)
  local last_line
  last_line=$(tail -n 1 -- "$target" 2>/dev/null) || last_line=""
  if [[ "$last_line" == "$input" ]]; then
    print "⚠️  Data terakhir sudah sama. Tidak ada yang diubah."
    return 0
  fi

  # 9) Append dengan newline yang benar
  # Cek apakah file diakhiri newline
  if [[ -s "$target" ]]; then
    local last_byte
    last_byte=$(tail -c 1 -- "$target" | od -An -tx1)
    if [[ "$last_byte" != " 0a" ]]; then
      printf '\n' >> "$target" || { print -u2 "❌ Gagal menambahkan newline."; return 1 }
    fi
  fi

  # Append baris baru
  printf '%s\n' "$input" >> "$target" || { print -u2 "❌ Gagal append ke file."; return 1 }

  # 10) git add .
  git add . || { print -u2 "❌ git add gagal."; return 1 }

  # 11) Commit dengan timestamp WIB
  local msg
  msg=$(TZ=Asia/Jakarta date '+%Y-%m-%d %H:%M:%S WIB')
  git commit -m "$msg" || { print -u2 "❌ git commit gagal."; return 1 }

  # 12) Push ke origin/main
  git push -u origin "$expected_branch" || { print -u2 "❌ git push gagal."; return 1 }

  print "✅ Selesai. Commit: $msg"
  return 0
}

# bench — Benchmark command
bench() {
  emulate -L zsh

  local timer
  timer=${commands[gtime]:-${commands[time]}}

  [[ -n $timer ]] || {
    print -u2 "bench: GNU time (gtime/time) tidak ditemukan"
    return 127
  }

  {
    "$timer" -f '%e %U %S' "$@"
  } 2> >(
    awk '
    {
        real = $1 * 1000
        user = $2 * 1000
        sys  = $3 * 1000
        cpu  = user + sys
        pct  = (real > 0) ? cpu / real * 100 : 0

        printf "\n"
        printf "⏱  Real : %9.3f ms\n", real
        printf "🧠 User : %9.3f ms\n", user
        printf "⚙  Sys  : %9.3f ms\n", sys
        printf "🔥 CPU  : %9.3f ms (%5.1f%%)\n", cpu, pct
    }'
  )

  return ${pipestatus[1]}
}

# Auto ls saat pindah folder
autoload -Uz add-zsh-hook

do-ls() {
  emulate -L zsh
  eza --icons --group-directories-first --color=auto -I "$EZA_IGNORE"
}

add-zsh-hook chpwd do-ls

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
