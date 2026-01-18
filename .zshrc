# ╔══════════════════════════════════════════════════════════════════════════════╗
# ║                     🚀 PERSONAL ZSH CONFIG FOR CACHYOS                       ║
# ║                  Extends: cachyos-config.zsh (system-wide)                   ║
# ╚══════════════════════════════════════════════════════════════════════════════╝

# ┌──────────────────────────────────────────────────────────────────────────────┐
# │ 🔌 PLUGINS & BASE CONFIG                                                     │
# └──────────────────────────────────────────────────────────────────────────────┘
plugins=(git fzf extract)
source /usr/share/cachyos-zsh-config/cachyos-config.zsh

# ┌──────────────────────────────────────────────────────────────────────────────┐
# │ 🌍 ENVIRONMENT & PATH                                                        │
# └──────────────────────────────────────────────────────────────────────────────┘
typeset -U path
path=($HOME/{bin,.local/bin,.fnm,.local/share/fnm,.cargo/bin,.bun/bin} $path)
export PATH

# Tool Initializations (lazy-load style)
(( $+commands[fnm] ))    && eval "$(fnm env --use-on-cd --shell zsh)"
(( $+commands[zoxide] )) && eval "$(zoxide init zsh)"
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# ┌──────────────────────────────────────────────────────────────────────────────┐
# │ ⚙️  ZSH OPTIONS                                                              │
# └──────────────────────────────────────────────────────────────────────────────┘
HIST_STAMPS="yyyy-mm-dd"
setopt AUTO_CD              # cd tanpa ketik 'cd'
setopt AUTO_PUSHD           # cd otomatis push ke stack
setopt PUSHD_IGNORE_DUPS    # Tidak duplikat di stack
setopt CORRECT              # Koreksi typo command
setopt INTERACTIVE_COMMENTS # Komentar di terminal

# ┌──────────────────────────────────────────────────────────────────────────────┐
# │ 🎨 ALIASES                                                                   │
# └──────────────────────────────────────────────────────────────────────────────┘

# ── File & Navigation ─────────────────────────────────────────────────────────
alias ls='eza --icons --group-directories-first'
alias ll='eza -lh --icons --git'
alias la='eza -la --icons --git'
alias lt='eza -T --icons --level=2'       # Tree view
alias lta='eza -Ta --icons --level=2'     # Tree all
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias -- -='cd -'                         # Kembali ke dir sebelumnya

# ── Quick Access ──────────────────────────────────────────────────────────────
alias dl='cd /home/data/$USER/Downloads'
alias desk='cd ~/Desktop'
alias proj='cd ~/Projects 2>/dev/null || cd ~/Kuliah'

# ── System & Tools ────────────────────────────────────────────────────────────
alias x='exit'
alias q='exit'
alias zconfig='${EDITOR:-code} ~/.zshrc'
alias zreload='exec zsh && echo "✅ ZSH reloaded!"'
alias ports='ss -tulanp'
alias myip='curl -s ifconfig.me && echo'
alias weather='curl -s "wttr.in/?format=3"'
alias diskspace='df -h | grep -E "^/dev"'
alias meminfo='free -h'

# ── Development ───────────────────────────────────────────────────────────────
alias ga='git add .'
alias gs='git status -sb'
alias gl='git log --oneline -15'
alias gd='git diff'
alias serve='php artisan serve'
alias dev='npm run dev'
alias build='npm run build'

# ┌──────────────────────────────────────────────────────────────────────────────┐
# │ 🛠️  FUNCTIONS                                                                │
# └──────────────────────────────────────────────────────────────────────────────┘

# ── Directory Operations ──────────────────────────────────────────────────────

# Buat direktori dan langsung masuk
mkcd() { mkdir -p "$1" && cd "$1" }

# Ekstrak berbagai format arsip
extract() {
  [[ -z "$1" ]] && { echo "⚠️  Usage: extract <file>"; return 1 }
  [[ ! -f "$1" ]] && { echo "❌ File tidak ditemukan: $1"; return 1 }
  
  case "$1" in
    *.tar.bz2) tar xjf "$1"    ;;
    *.tar.gz)  tar xzf "$1"    ;;
    *.tar.xz)  tar xJf "$1"    ;;
    *.tar)     tar xf "$1"     ;;
    *.bz2)     bunzip2 "$1"    ;;
    *.gz)      gunzip "$1"     ;;
    *.zip)     unzip "$1"      ;;
    *.rar)     unrar x "$1"    ;;
    *.7z)      7z x "$1"       ;;
    *)         echo "❌ Format tidak didukung: $1" ;;
  esac
}

# ── C Programming ─────────────────────────────────────────────────────────────

compile() {
  [[ -z "$1" ]] && { echo "⚠️  Usage: compile <file.c> [args...]"; return 1 }
  [[ ! -f "$1" ]] && { echo "❌ File tidak ditemukan: $1"; return 1 }
  
  local src="$1" out="${1%.c}"
  shift  # Args sisanya untuk program
  
  (( ! $+commands[clang] )) && { echo "❌ Install clang: sudo pacman -S clang"; return 1 }
  
  echo "🛠️  Compiling: $src"
  if clang -Wall -Wextra -std=c99 -g "$src" -o "$out"; then
    echo "✅ Output: $out"
    echo "🚀 Running...\n"
    "./$out" "$@"
  else
    echo "❌ Compilation failed!"
    return 1
  fi
}

# Compile dengan debug info untuk GDB
debug-compile() {
  [[ -z "$1" ]] && { echo "⚠️  Usage: debug-compile <file.c>"; return 1 }
  local src="$1" out="${1%.c}"
  
  clang -Wall -Wextra -std=c99 -g -O0 -fsanitize=address "$src" -o "$out" && \
    echo "✅ Debug build: $out (run with: gdb ./$out)"
}

# ── Git Workflow ──────────────────────────────────────────────────────────────

# Git config untuk multi-akun
typeset -A GIT_ACCOUNTS
GIT_ACCOUNTS=(
  [personal]="Budi Imam Prasetyo|budiimamprsty@gmail.com|github.com-personal"
  [kampus]="Budi Prasetyo|budi.prasetyo@satu.ac.id|github.com-kampus"
)

# Quick commit & push
gacp() {
  [[ -z "$1" ]] && { echo "⚠️  Usage: gacp \"commit message\""; return 1 }
  
  local branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
  [[ -z "$branch" ]] && { echo "❌ Not a Git repository!"; return 1 }
  
  echo "📦 Committing to: $branch"
  git add . && git commit -m "$1" || return 1
  
  # Check internet & push
  if curl -s --connect-timeout 2 https://github.com >/dev/null 2>&1; then
    git push -u origin "$branch" && echo "🚀 Pushed to $branch!"
  else
    echo "⚠️  Offline. Run 'git push' later."
  fi
}

# Initialize repo dengan akun
init-repo() {
  local account="${GIT_ACCOUNTS[$1]}"
  [[ -z "$account" ]] && { echo "⚠️  Usage: init-repo <personal|kampus>"; return 1 }
  
  local name="${account%%|*}"
  local email="${${account#*|}%%|*}"
  
  git init
  git config user.name "$name"
  git config user.email "$email"
  echo "✅ Initialized with: $name <$email>"
}

# Switch akun di repo yang ada
use-git() {
  [[ ! -d .git ]] && { echo "⚠️  Not a Git repository!"; return 1 }
  
  local account="${GIT_ACCOUNTS[$1]}"
  [[ -z "$account" ]] && { echo "⚙️  Usage: use-git <personal|kampus>"; return 1 }
  
  local name="${account%%|*}"
  local email="${${account#*|}%%|*}"
  local host="${account##*|}"
  local other_host=$([[ "$1" == "personal" ]] && echo "github.com-kampus" || echo "github.com-personal")
  
  git config user.name "$name"
  git config user.email "$email"
  
  # Update remote URL jika perlu
  local url=$(git remote get-url origin 2>/dev/null)
  [[ "$url" == *"$other_host"* ]] && git remote set-url origin "${url/$other_host/$host}"
  
  echo "✅ Switched to: $name ($1)"
}

# Push .zshrc ke repo backup
zpush() {
  [[ -z "$1" ]] && { echo "⚠️  Usage: zpush \"commit message\""; return 1 }
  
  local repo="$HOME/ZSH-Config"
  [[ ! -d "$repo" ]] && { echo "❌ Repo not found: $repo"; return 1 }
  
  cp ~/.zshrc "$repo/" && \
  git -C "$repo" add -A && \
  git -C "$repo" commit -m "$1" && \
  git -C "$repo" push && \
  echo "✅ .zshrc synced!"
}

# ── Utilities ─────────────────────────────────────────────────────────────────

# Convert GitHub URL ke raw.githack
githack() {
  [[ -z "$1" ]] && { echo "⚠️  Usage: githack <github-url>"; return 1 }
  
  local url="$1" out=""
  
  case "$url" in
    *raw.githack.com*) out="$url" ;;
    *raw.githubusercontent.com*)
      [[ "$url" =~ 'raw.githubusercontent.com/([^/]+)/([^/]+)/([^/]+)/(.*)' ]] && \
        out="https://raw.githack.com/${match[1]}/${match[2]}/${match[3]}/${match[4]}"
      ;;
    *github.com*/blob/*)
      [[ "$url" =~ 'github.com/([^/]+)/([^/]+)/blob/([^/]+)/(.*)' ]] && \
        out="https://raw.githack.com/${match[1]}/${match[2]}/${match[3]}/${match[4]}"
      ;;
    *) echo "❌ Invalid GitHub URL"; return 1 ;;
  esac
  
  echo "🌐 $out"
  (( $+commands[xclip] )) && echo -n "$out" | xclip -selection clipboard && echo "📋 Copied!"
}

# Quick notes
note() {
  local file="$HOME/.notes.md"
  case "$1" in
    -l|--list) cat "$file" 2>/dev/null || echo "No notes yet." ;;
    -c|--clear) : > "$file" && echo "🗑️  Notes cleared!" ;;
    "") ${EDITOR:-nano} "$file" ;;
    *) echo "- $(date '+%Y-%m-%d %H:%M'): $*" >> "$file" && echo "📝 Note saved!" ;;
  esac
}

# Benchmark command execution time
bench() {
  local start=$(date +%s.%N)
  "$@"
  local end=$(date +%s.%N)
  echo "\n⏱️  Elapsed: $(echo "$end - $start" | bc)s"
}

# Find proses & kill
fkill() {
  local pid=$(ps aux | fzf --header="Select process to kill" | awk '{print $2}')
  [[ -n "$pid" ]] && kill -9 "$pid" && echo "💀 Killed PID: $pid"
}

# ┌──────────────────────────────────────────────────────────────────────────────┐
# │ 📚 HELP                                                                      │
# └──────────────────────────────────────────────────────────────────────────────┘
zhelp() {
  cat << 'EOF'
╔══════════════════════════════════════════════════════════════════════════════╗
║                           🚀 CUSTOM ZSH COMMANDS                             ║
╠══════════════════════════════════════════════════════════════════════════════╣
║ NAVIGATION          │ DEVELOPMENT         │ GIT                              ║
║ ─────────────────── │ ─────────────────── │ ────────────────────────────────-║
║ mkcd <dir>          │ compile <file.c>    │ gacp "msg"   - add,commit,push   ║
║ extract <archive>   │ debug-compile <.c>  │ init-repo <personal|kampus>      ║
║ lt / lta            │ bench <cmd>         │ use-git <personal|kampus>        ║
║ dl / desk / proj    │ dev / serve / build │ zpush "msg"  - sync .zshrc       ║
╠══════════════════════════════════════════════════════════════════════════════╣
║ UTILITIES           │ SYSTEM                                                 ║
║ ─────────────────── │ ────────────────────────────────────────────────────── ║
║ githack <url>       │ myip / weather / ports / diskspace / meminfo           ║
║ note [-l|-c] [txt]  │ zconfig / zreload / zhelp                              ║
║ fkill               │ x / q (exit)                                           ║
╚══════════════════════════════════════════════════════════════════════════════╝
EOF
}