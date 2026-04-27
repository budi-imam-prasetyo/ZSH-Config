# ╔══════════════════════════════════════════════════════════════════════════════╗
# ║                     🚀 KONFIGURASI ZSH PRIBADI - CACHYOS                     ║
# ╚══════════════════════════════════════════════════════════════════════════════╝

# ┌──────────────────────────────────────────────────────────────────────────────┐
# │ 🔌 PLUGIN & KONFIGURASI DASAR                                                │
# └──────────────────────────────────────────────────────────────────────────────┘
plugins=(
  git      # Pintasan git & status di prompt
  fzf      # Fuzzy finder (Ctrl+R: riwayat, Ctrl+T: file)
  extract  # Ekstrak arsip dengan perintah 'x'
)

source /usr/share/cachyos-zsh-config/cachyos-config.zsh

# ┌──────────────────────────────────────────────────────────────────────────────┐
# │ 🌍 ENVIRONMENT & PATH                                                        │
# └──────────────────────────────────────────────────────────────────────────────┘
typeset -U path  # Cegah duplikasi path

path=(
  $JAVA_HOME/bin
  $HOME/bin           # Skrip pribadi
  $HOME/.local/bin    # Binary user-install\
  $HOME/.local/share/fnm
  $HOME/.cargo/bin    # Binary Rust
  $HOME/.bun/bin      # Runtime Bun
  $path
)
export PATH
export "MICRO_TRUECOLOR=1"

# ── Inisialisasi Tool ─────────────────────────────────────────────────────────
# Hanya diload jika tersedia (mempercepat startup)

(( $+commands[fnm] ))    && eval "$(fnm env --use-on-cd --shell zsh)"  # Node.js version manager
(( $+commands[zoxide] )) && eval "$(zoxide init zsh)"                  # cd pintar
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"                   # Bun completions

# ┌──────────────────────────────────────────────────────────────────────────────┐
# │ ⚙️  OPSI ZSH                                                                 │
# └──────────────────────────────────────────────────────────────────────────────┘

# Open in a popup if on tmux or Zellij, otherwise use --height mode
export FZF_DEFAULT_OPTS="--height 70% \
--layout=reverse \
--border=top \
--style=full \
--preview '~/.local/bin/fzf-preview.sh {}' \
--bind 'focus:transform-header:file --brief {}'"
BAT_THEME="Catppuccin Mocha"

HIST_STAMPS="yyyy-mm-dd"    # Format tanggal di history (misal: 2025-04-23 ls)
HISTSIZE=10000               # Jumlah perintah yang disimpan di memori per sesi
SAVEHIST=10000               # Jumlah perintah yang ditulis ke ~/.zsh_history

setopt NO_CLOBBER
setopt EXTENDED_GLOB
setopt PIPE_FAIL
setopt SHARE_HISTORY         # Sync history realtime antar semua terminal yang terbuka
setopt HIST_IGNORE_ALL_DUPS  # Hapus entri lama jika perintah sama diketik lagi
setopt HIST_FIND_NO_DUPS     # Saat Ctrl+R, skip hasil duplikat

setopt AUTO_CD               # Ketik nama folder langsung masuk (tanpa 'cd')
setopt AUTO_PUSHD            # cd otomatis push direktori lama ke stack
setopt PUSHD_IGNORE_DUPS     # Jangan push direktori duplikat ke stack
setopt CORRECT               # Sarankan koreksi typo perintah
setopt INTERACTIVE_COMMENTS  # Izinkan komentar (#) di shell interaktif

# ┌──────────────────────────────────────────────────────────────────────────────┐
# │ 🎨 ALIAS                                                                     │
# └──────────────────────────────────────────────────────────────────────────────┘

# ── Listing & Navigasi ────────────────────────────────────────────────────────
# Menggunakan 'eza' — pengganti modern untuk 'ls'

alias ls='eza --icons --group-directories-first --color=auto'  # Listing dasar
alias ll='eza -lh --icons --git'                               # Format panjang + status git
alias la='eza -la --icons --git'                               # Tampilkan file tersembunyi
alias lt='eza -T --icons --level=2'                            # Tampilan tree 2 level
alias lta='eza -Ta --icons --level=2'                          # Tree + file tersembunyi

if (( $+commands[zoxide] )); then
  alias cd='z'
fi
alias ..='cd ..'
alias -- -='cd -'          # Kembali ke direktori sebelumnya

# ── Sistem & Produktivitas ────────────────────────────────────────────────────
alias c='clear'
alias q='exit'
alias zconfig='code ~/config/'                        # Edit konfigurasi ini
alias zreload='exec zsh'                             # Reload konfigurasi shell

# ── Pintasan Pengembangan ─────────────────────────────────────────────────────
alias ga='git add .'          # Stage semua perubahan
alias gs='git status -sb'     # Status singkat + info branch
alias gl='git log --oneline -15'  # 15 commit terakhir (ringkas)
alias gd='git diff'           # Tampilkan perubahan

alias artisan='docker compose exec app php artisan'
alias composer='docker compose exec app composer'

# ┌──────────────────────────────────────────────────────────────────────────────┐
# │ 🛠️  FUNGSI                                                                   │
# └──────────────────────────────────────────────────────────────────────────────┘

# Hapus file tanpa ekstensi (dengan konfirmasi)
rmnoext() {
  fd --type f --no-ignore-vcs \
    --exclude .git \
    --exclude node_modules \
    --exclude vendor \
    "^[^.]+$" -0 |
  tee /dev/stderr |
  xargs -0 -r -p rm --
}

# mkcd — Buat folder dan langsung masuk ke dalamnya
# Penggunaan: mkcd nama-folder
mkcd() {
  [[ -z "$1" ]] && return 1
  mkdir -p -- "$1" && cd -- "$1"
}

# ── Fungsi C Programming ──────────────────────────────────────────────────────

# compile — Kompilasi dan jalankan program C sekaligus
# Penggunaan: compile program.c [argumen...]
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

# ── Fungsi Git ────────────────────────────────────────────────────────────────

# gacp — Git add, commit, dan push dalam satu perintah
# Penggunaan: gacp "pesan commit"
gacp() {
  if [[ -z "$1" ]]; then
    echo "⚠️  Penggunaan: gacp \"pesan commit\""
    return 1
  fi

  local branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
  [[ -z "$branch" ]] && echo "❌ Bukan repositori Git!" && return 1

  local remote_url=$(git remote get-url origin 2>/dev/null)

  if [[ "$remote_url" =~ ^https:// ]]; then
    echo "⚠️  Repo masih menggunakan HTTPS:"
    echo "   $remote_url"
    echo "👉 Disarankan menggunakan SSH."
    echo ""
    # return 1  # <- aktifkan kalau mau HARD BLOCK
  fi

  echo "📦 Commit ke branch: $branch"
  git add . && git commit -m "$1" || return 1

  if git ls-remote origin &>/dev/null; then
    git push -u origin "$branch" && echo "🚀 Berhasil push ke $branch!"
  else
    echo "⚠️  Offline. Jalankan 'git push' saat online."
  fi
}

# gaacp — Seperti gacp tapi pesan commit dibuat otomatis oleh AI (aicommits)
# Penggunaan: gaacp
gaacp() {
  local branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
  [[ -z "$branch" ]] && echo "❌ Bukan repositori Git!" && return 1
  [[ -z "$(git status --porcelain)" ]] && echo "⚠️  Tidak ada perubahan." && return 1

  if ! command -v aicommits >/dev/null 2>&1; then
    echo "❌ 'aicommits' belum terinstall."
    echo "👉 https://github.com/Nutlope/aicommits"
    return 1
  fi

  local remote_url=$(git remote get-url origin 2>/dev/null)

  if [[ "$remote_url" =~ ^https:// ]]; then
    echo "⚠️  Repo masih menggunakan HTTPS:"
    echo "   $remote_url"
    echo "👉 Disarankan menggunakan SSH."
    echo ""
    # return 1  # <- aktifkan kalau mau HARD BLOCK
  fi

  echo "📦 Membuat pesan commit dengan AI..."
  git add . || return 1
  aicommits || return 1

  echo "📦 Commit ke branch: $branch"
  if git ls-remote origin &>/dev/null; then
    git push -u origin "$branch" && echo "🚀 Berhasil push ke $branch!"
  else
    echo "⚠️  Offline. Jalankan 'git push' saat online."
  fi
}

# zpush — Sinkronisasi .zshrc ke repositori backup
# Penggunaan: zpush "pesan"  →  atau tanpa pesan untuk pakai AI commit
zpush() {
  local repo="$HOME/ZSH-Config"
  local source="$HOME/.zshrc"

  [[ ! -f "$source" ]]    && echo "❌ File tidak ditemukan: $source" && return 1
  [[ ! -d "$repo/.git" ]] && echo "❌ Repo backup belum diinisialisasi: $repo" && return 1

  cp -f "$source" "$repo/" || return 1

  if [[ -z "$(git -C "$repo" status --porcelain)" ]]; then
    echo "⚠️  Tidak ada perubahan pada .zshrc"
    return 1
  fi

  git -C "$repo" add . || return 1

  if [[ -n "$1" ]]; then
    git -C "$repo" commit -m "$1" || return 1
  else
    if ! command -v aicommits >/dev/null 2>&1; then
      echo "❌ 'aicommits' belum terinstall. 👉 https://github.com/Nutlope/aicommits"
      return 1
    fi
    echo "🤖 Membuat commit dengan AI..."
    (cd "$repo" && aicommits) || return 1
  fi

  if git ls-remote origin &>/dev/null; then
    git -C "$repo" push && echo "🚀 Backup berhasil dipush!"
  else
    echo "⚠️  Offline. Jalankan 'git push' nanti."
  fi
}

# ── Fungsi Utilitas ───────────────────────────────────────────────────────────

# githack — Konversi URL GitHub ke CDN raw.githack.com
# Penggunaan: githack https://github.com/user/repo/blob/main/script.js
# Otomatis copy ke clipboard jika xclip tersedia
githack() {
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

# bench — Ukur waktu eksekusi perintah
bench() {
  command time -f "\n⏱ real %E\n🧠 user %U\n⚙ sys %S" "$@"
}

# Yazi
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	command yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ "$cwd" != "$PWD" ] && [ -d "$cwd" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}

chpwd() {
  eza --icons --group-directories-first
}
# ┌──────────────────────────────────────────────────────────────────────────────┐
# │ 📚 REFERENSI PERINTAH                                                        │
# └──────────────────────────────────────────────────────────────────────────────┘

# zhelp — Tampilkan semua perintah custom beserta kegunaannya
zhelp() {
  cat << 'EOF'
╔══════════════════════════════════════════════════════════════════════════════╗
║                      🚀 REFERENSI PERINTAH ZSH CUSTOM                        ║
╠══════════════════════════════════════════════════════════════════════════════╣
║                                                                              ║
║  📁 FILE & NAVIGASI                                                          ║
║  ─────────────────────────────────────────────────────────────────────────   ║
║  mkcd <dir>           Buat folder dan langsung masuk                         ║
║  extract <file>       Ekstrak semua format arsip otomatis                    ║
║  lt / lta             Tampilan tree 2 level / + file tersembunyi             ║
║  ..                   Naik 1 direktori                                       ║
║  -                    Kembali ke direktori sebelumnya                        ║
║                                                                              ║
║  💻 PENGEMBANGAN                                                             ║
║  ─────────────────────────────────────────────────────────────────────────   ║
║  compile <file.c> [args]    Kompilasi dan jalankan program C                 ║
║  bench <perintah>           Ukur waktu eksekusi perintah                     ║
║                                                                              ║
║  🔧 ALUR KERJA GIT                                                           ║
║  ─────────────────────────────────────────────────────────────────────────   ║
║  gacp "pesan"               Add + commit + push (satu perintah)              ║
║  gaacp                      Seperti gacp, pesan commit dibuat AI             ║
║  zpush ["pesan"]            Sinkronisasi .zshrc ke repo backup               ║
║  ga / gs / gl / gd          Pintasan git (add, status, log, diff)            ║
║                                                                              ║
║  🛠️  UTILITAS                                                                ║
║  ─────────────────────────────────────────────────────────────────────────   ║
║  githack <url>              Konversi URL GitHub ke CDN link                  ║
║  rmnoext                    Hapus file tanpa ekstensi (dengan konfirmasi)    ║
║                                                                              ║
║  ⚙️  KONFIGURASI                                                             ║
║  ─────────────────────────────────────────────────────────────────────────   ║
║  zconfig                    Edit konfigurasi ini                             ║
║  zreload                    Reload konfigurasi ZSH                           ║
║  zhelp                      Tampilkan referensi ini                          ║
║  q                        Keluar dari terminal                               ║
║                                                                              ║
╠══════════════════════════════════════════════════════════════════════════════╣
║  💡 TIP: Ketik 'zhelp' kapanpun untuk melihat referensi ini!                 ║
╚══════════════════════════════════════════════════════════════════════════════╝
EOF
}

export EDITOR=micro
eval "$(starship init zsh)"