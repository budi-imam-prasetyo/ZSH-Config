# ╔══════════════════════════════════════════════════════════════════════════════╗
# ║                     🚀 KONFIGURASI ZSH PRIBADI - CACHYOS                     ║
# ║                  Memperluas: cachyos-config.zsh (sistem)                     ║
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
  $HOME/.local/bin    # Binary user-install
  $HOME/.fnm          # Fast Node Manager
  $HOME/.local/share/fnm
  $HOME/.cargo/bin    # Binary Rust
  $HOME/.bun/bin      # Runtime Bun
  $path
)
export PATH

# ── Inisialisasi Tool ─────────────────────────────────────────────────────────
# Hanya diload jika tersedia (mempercepat startup)

(( $+commands[fnm] ))    && eval "$(fnm env --use-on-cd --shell zsh)"  # Node.js version manager
(( $+commands[zoxide] )) && eval "$(zoxide init zsh)"                  # cd pintar
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"                   # Bun completions

# ┌──────────────────────────────────────────────────────────────────────────────┐
# │ ⚙️  OPSI ZSH                                                                 │
# └──────────────────────────────────────────────────────────────────────────────┘
HIST_STAMPS="yyyy-mm-dd"

setopt AUTO_CD              # Ketik nama folder langsung masuk (tanpa 'cd')
setopt AUTO_PUSHD           # cd otomatis push direktori lama ke stack
setopt PUSHD_IGNORE_DUPS    # Jangan push direktori duplikat
setopt CORRECT              # Sarankan koreksi typo perintah
setopt INTERACTIVE_COMMENTS # Izinkan komentar (#) di shell interaktif

# ┌──────────────────────────────────────────────────────────────────────────────┐
# │ 🎨 ALIAS                                                                     │
# └──────────────────────────────────────────────────────────────────────────────┘

# ── Listing & Navigasi ────────────────────────────────────────────────────────
# Menggunakan 'eza' — pengganti modern untuk 'ls'

alias ls='eza --icons --group-directories-first'  # Listing dasar
alias ll='eza -lh --icons --git'                  # Format panjang + status git
alias la='eza -la --icons --git'                  # Tampilkan file tersembunyi
alias lt='eza -T --icons --level=2'               # Tampilan tree 2 level
alias lta='eza -Ta --icons --level=2'             # Tree + file tersembunyi

alias cd='z'                                   # Ganti cd dengan zoxide
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

# Hapus file tanpa ekstensi (dengan konfirmasi)
rmnoext() {
  files=$(fd --type f --no-ignore-vcs \
    --exclude .git \
    --exclude node_modules \
    --exclude vendor \
    "^[^.]+$")
  
  echo "$files"
  echo
  read "confirm?Hapus semua file di atas? (y/n): "
  
  if [[ $confirm == "y" ]]; then
    echo "$files" | xargs rm
  fi
}

# ┌──────────────────────────────────────────────────────────────────────────────┐
# │ 🛠️  FUNGSI                                                                   │
# └──────────────────────────────────────────────────────────────────────────────┘

# mkcd — Buat folder dan langsung masuk ke dalamnya
# Penggunaan: mkcd nama-folder
mkcd() {
  mkdir -p "$1" && cd "$1"
}

# ── Fungsi C Programming ──────────────────────────────────────────────────────

# compile — Kompilasi dan jalankan program C sekaligus
# Penggunaan: compile program.c [argumen...]
compile() {
  if [[ -z "$1" ]]; then
    echo "Penggunaan: compile <file.c> [argumen...]"
    return 1
  fi

  local src="$1"

  [[ ! -f "$src" ]]    && echo "File tidak ditemukan: $src" && return 1
  [[ "$src" != *.c ]]  && echo "Hanya file .c yang didukung" && return 1
  (( ! $+commands[clang] )) && echo "clang tidak ditemukan. Install: sudo pacman -S clang" && return 1

  # pastikan folder bin ada
  mkdir -p bin

  # ambil nama file tanpa path + ekstensi
  local filename=$(basename "$src" .c)
  local out="bin/$filename"

  shift

  echo "Mengompilasi: $src"
  if clang -Wall -Wextra -std=c99 -g "$src" -o "$out"; then
    echo "Output: $out"
    echo
    "$out" "$@"
  else
    echo "Kompilasi gagal"
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

  if curl -s --connect-timeout 2 https://github.com >/dev/null 2>&1; then
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
  if curl -s --connect-timeout 2 https://github.com >/dev/null 2>&1; then
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

  if curl -s --connect-timeout 2 https://github.com >/dev/null 2>&1; then
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
# Penggunaan: bench npm run build
bench() {
  local start=$(date +%s%N)
  "$@"
  local end=$(date +%s%N)
  local diff=$(( (end - start) / 1000000 ))
  echo "\n⏱️  Waktu eksekusi: ${diff} ms"
}

# Yazi
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	command yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ "$cwd" != "$PWD" ] && [ -d "$cwd" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
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