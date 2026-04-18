# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

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

export JAVA_HOME=/usr/lib/jvm/default
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

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias -- -='cd -'          # Kembali ke direktori sebelumnya

# ── Sistem & Produktivitas ────────────────────────────────────────────────────
alias c='clear'
alias x='exit'
alias q='exit'
alias zconfig='code ~/.zshrc'                        # Edit konfigurasi ini
alias zreload='exec zsh && echo "✅ ZSH direload!"'  # Reload konfigurasi shell

# Info Jaringan & Sistem
alias ports='ss -tulanp'                       # Tampilkan semua port terbuka
alias myip='curl -s ifconfig.me && echo'       # IP publik
alias weather='curl -s "wttr.in/?format=3"'   # Info cuaca singkat
alias diskspace='df -h | grep -E "^/dev"'      # Penggunaan disk
alias meminfo='free -h'                        # Penggunaan memori
alias cd='z'                                   # Ganti cd dengan zoxide

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

# extract — Ekstrak semua format arsip secara otomatis
# Penggunaan: extract arsip.zip
# Format: .tar.bz2 .tar.gz .tar.xz .tar .bz2 .gz .zip .rar .7z
extract() {
  if [[ -z "$1" ]]; then
    echo "⚠️  Penggunaan: extract <file>"
    return 1
  fi

  if [[ ! -f "$1" ]]; then
    echo "❌ File tidak ditemukan: $1"
    return 1
  fi

  case "$1" in
    *.tar.bz2) tar xjf "$1" ;;
    *.tar.gz)  tar xzf "$1" ;;
    *.tar.xz)  tar xJf "$1" ;;
    *.tar)     tar xf  "$1" ;;
    *.bz2)     bunzip2 "$1" ;;
    *.gz)      gunzip  "$1" ;;
    *.zip)     unzip   "$1" ;;
    *.rar)     unrar x "$1" ;;
    *.7z)      7z x    "$1" ;;
    *)         echo "❌ Format tidak didukung: $1" ;;
  esac
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

# debug-compile — Kompilasi dengan simbol debug & AddressSanitizer
# Penggunaan: debug-compile program.c  →  jalankan dengan: gdb ./program
debug-compile() {
  if [[ -z "$1" ]]; then
    echo "⚠️  Penggunaan: debug-compile <file.c>"
    return 1
  fi

  local out="${1%.c}"
  clang -Wall -Wextra -std=c99 -g -O0 -fsanitize=address "$1" -o "$out" && \
    echo "✅ Debug build: $out\n💡 Jalankan: gdb ./$out"
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
    echo "⚠️  Offline. Jalankan 'git push' nanti."
  fi
}

# init-repo — Inisialisasi repo Git dengan akun tertentu
# Penggunaan: init-repo personal   atau: init-repo kampus
init-repo() {
  local account="${GIT_ACCOUNTS[$1]}"

  if [[ -z "$account" ]]; then
    echo "⚠️  Penggunaan: init-repo <personal|kampus>"
    return 1
  fi

  local name="${account%%|*}"
  local email="${${account#*|}%%|*}"

  git init
  git config user.name "$name"
  git config user.email "$email"
  echo "✅ Repo diinisialisasi dengan: $name <$email>"
}

# use-git — Ganti akun Git di repo yang sudah ada
# Penggunaan: use-git personal   atau: use-git kampus
# Otomatis memperbarui remote URL jika perlu
use-git() {
  if [[ ! -d .git ]]; then
    echo "⚠️  Bukan repositori Git!"
    return 1
  fi

  local account="${GIT_ACCOUNTS[$1]}"

  if [[ -z "$account" ]]; then
    echo "⚙️  Penggunaan: use-git <personal|kampus>"
    return 1
  fi

  local name="${account%%|*}"
  local email="${${account#*|}%%|*}"
  local host="${account##*|}"
  local other_host=$([[ "$1" == "personal" ]] && echo "github.com-kampus" || echo "github.com-personal")

  git config user.name "$name"
  git config user.email "$email"

  local url=$(git remote get-url origin 2>/dev/null)
  if [[ "$url" == *"$other_host"* ]]; then
    git remote set-url origin "${url/$other_host/$host}"
  fi

  echo "✅ Beralih ke: $name (akun $1)"
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

# note — Sistem catatan cepat
# Penggunaan:
#   note              → Buka catatan di editor
#   note "teks"       → Tambah catatan bertimestamp
#   note -l           → Lihat semua catatan
#   note -c           → Hapus semua catatan
note() {
  local file="$HOME/.notes.md"

  case "$1" in
    -l|--list)  [[ -f "$file" ]] && cat "$file" || echo "📝 Belum ada catatan." ;;
    -c|--clear) : > "$file" && echo "🗑️  Semua catatan dihapus!" ;;
    "")         ${EDITOR:-nano} "$file" ;;
    *)          echo "- $(date '+%Y-%m-%d %H:%M'): $*" >> "$file" && echo "📝 Catatan disimpan!" ;;
  esac
}

# bench — Ukur waktu eksekusi perintah
# Penggunaan: bench npm run build
bench() {
  local start=$(date +%s.%N)
  "$@"
  local end=$(date +%s.%N)
  echo "\n⏱️  Waktu eksekusi: $(echo "$end - $start" | bc)s"
}

# fkill — Cari dan kill proses dengan fuzzy finder
# Penggunaan: fkill  →  pilih proses dari daftar fzf
fkill() {
  local pid=$(ps aux | fzf --header="Pilih proses yang akan dimatikan" | awk '{print $2}')

  if [[ -n "$pid" ]]; then
    kill -9 "$pid"
    echo "💀 Proses PID $pid dimatikan"
  fi
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
║  .. / ... / ....      Naik 1/2/3 direktori                                   ║
║  -                    Kembali ke direktori sebelumnya                        ║
║                                                                              ║
║  💻 PENGEMBANGAN                                                             ║
║  ─────────────────────────────────────────────────────────────────────────   ║
║  compile <file.c> [args]    Kompilasi dan jalankan program C                 ║
║  debug-compile <file.c>     Kompilasi dengan simbol debug untuk GDB          ║
║  bench <perintah>           Ukur waktu eksekusi perintah                     ║
║                                                                              ║
║  🔧 ALUR KERJA GIT                                                           ║
║  ─────────────────────────────────────────────────────────────────────────   ║
║  gacp "pesan"               Add + commit + push (satu perintah)              ║
║  gaacp                      Seperti gacp, pesan commit dibuat AI             ║
║  init-repo <personal|kampus>   Inisialisasi repo dengan akun tertentu       ║
║  use-git <personal|kampus>     Ganti akun Git di repo saat ini              ║
║  zpush ["pesan"]            Sinkronisasi .zshrc ke repo backup               ║
║  ga / gs / gl / gd          Pintasan git (add, status, log, diff)            ║
║                                                                              ║
║  🛠️  UTILITAS                                                                ║
║  ─────────────────────────────────────────────────────────────────────────   ║
║  githack <url>              Konversi URL GitHub ke CDN link                  ║
║  note "teks"                Tambah catatan bertimestamp                      ║
║  note -l                    Lihat semua catatan                              ║
║  note -c                    Hapus semua catatan                              ║
║  note                       Buka catatan di editor                           ║
║  fkill                      Cari dan matikan proses (fuzzy)                  ║
║  rmnoext                    Hapus file tanpa ekstensi (dengan konfirmasi)    ║
║                                                                              ║
║  ℹ️  INFO SISTEM                                                             ║
║  ─────────────────────────────────────────────────────────────────────────   ║
║  myip                       Tampilkan IP publik                              ║
║  weather                    Info cuaca singkat                               ║
║  ports                      Daftar semua port terbuka                        ║
║  diskspace                  Penggunaan disk                                  ║
║  meminfo                    Penggunaan memori                                ║
║                                                                              ║
║  ⚙️  KONFIGURASI                                                              ║
║  ─────────────────────────────────────────────────────────────────────────   ║
║  zconfig                    Edit konfigurasi ini                             ║
║  zreload                    Reload konfigurasi ZSH                           ║
║  zhelp                      Tampilkan referensi ini                          ║
║  x / q                      Keluar dari terminal                             ║
║                                                                              ║
╠══════════════════════════════════════════════════════════════════════════════╣
║  💡 TIP: Ketik 'zhelp' kapanpun untuk melihat referensi ini!                 ║
╚══════════════════════════════════════════════════════════════════════════════╝
EOF
}

[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
