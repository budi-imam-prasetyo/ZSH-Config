# ╔══════════════════════════════════════════════════════════════════════════════╗
# ║                     🚀 PERSONAL ZSH CONFIG FOR CACHYOS                       ║
# ║                  Extends: cachyos-config.zsh (system-wide)                   ║
# ╚══════════════════════════════════════════════════════════════════════════════╝

# ┌──────────────────────────────────────────────────────────────────────────────┐
# │ 🔌 PLUGINS & BASE CONFIG                                                     │
# └──────────────────────────────────────────────────────────────────────────────┘
# Load Oh-My-Zsh plugins for enhanced functionality
plugins=(
  git      # Git shortcuts and status in prompt
  fzf      # Fuzzy finder integration (Ctrl+R for history, Ctrl+T for files)
  extract  # Smart archive extraction with 'x' command
)

# Load CachyOS base configuration (provides theme, completions, etc.)
source /usr/share/cachyos-zsh-config/cachyos-config.zsh

# ┌──────────────────────────────────────────────────────────────────────────────┐
# │ 🌍 ENVIRONMENT & PATH                                                        │
# └──────────────────────────────────────────────────────────────────────────────┘
# Ensure no duplicate paths (-U flag)
typeset -U path

# Add custom binary directories to PATH
# Order matters: first paths have priority
path=(
  $HOME/bin                    # Personal scripts
  $HOME/.local/bin             # User-installed binaries
  $HOME/.fnm                   # Fast Node Manager
  $HOME/.local/share/fnm       # FNM shared files
  $HOME/.cargo/bin             # Rust binaries
  $HOME/.bun/bin               # Bun runtime
  $path                        # Keep existing PATH entries
)
export PATH

# ── Tool Initializations ──────────────────────────────────────────────────────
# Initialize tools only if they're installed (lazy-load for faster startup)

# Fast Node Manager - Node.js version manager
(( $+commands[fnm] )) && eval "$(fnm env --use-on-cd --shell zsh)"

# Zoxide - Smarter cd command (learns your habits, use with 'z <dir>')
(( $+commands[zoxide] )) && eval "$(zoxide init zsh)"

# Bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# ┌──────────────────────────────────────────────────────────────────────────────┐
# │ ⚙️  ZSH OPTIONS                                                              │
# └──────────────────────────────────────────────────────────────────────────────┘
# Configure history timestamp format (shown with 'history' command)
HIST_STAMPS="yyyy-mm-dd"

# Quality of life improvements
setopt AUTO_CD              # Type directory name to cd into it (no 'cd' needed)
setopt AUTO_PUSHD           # Make cd push old directory onto directory stack
setopt PUSHD_IGNORE_DUPS    # Don't push duplicate directories onto stack
setopt CORRECT              # Suggest corrections for typos in commands
setopt INTERACTIVE_COMMENTS # Allow comments in interactive shell (# comment)

# ┌──────────────────────────────────────────────────────────────────────────────┐
# │ 🎨 ALIASES                                                                   │
# └──────────────────────────────────────────────────────────────────────────────┘

# ── File Listing & Navigation ─────────────────────────────────────────────────
# Using 'eza' - modern replacement for 'ls' with icons and git integration

alias ls='eza --icons --group-directories-first'  # Basic listing with icons
alias ll='eza -lh --icons --git'                  # Long format with git status
alias la='eza -la --icons --git'                  # Show hidden files
alias lt='eza -T --icons --level=2'               # Tree view (2 levels)
alias lta='eza -Ta --icons --level=2'             # Tree view with hidden files

# Quick directory navigation
alias ..='cd ..'                  # Go up one directory
alias ...='cd ../..'              # Go up two directories
alias ....='cd ../../..'          # Go up three directories
alias -- -='cd -'                 # Return to previous directory

# ── Quick Access Shortcuts ────────────────────────────────────────────────────
alias dl='cd /home/data/$USER/Downloads'          # Jump to Downloads
alias desk='cd ~/Desktop'                         # Jump to Desktop
alias proj='cd ~/Projects 2>/dev/null || cd ~/Kuliah'  # Projects or Kuliah folder

# ── System & Productivity Tools ───────────────────────────────────────────────
alias x='exit'                    # Quick exit
alias q='exit'                    # Alternative quick exit
alias zconfig='${EDITOR:-code} ~/.zshrc'          # Edit this config (default: VS Code)
alias zreload='exec zsh && echo "✅ ZSH reloaded!"'  # Reload shell configuration

# Network & System Info
alias ports='ss -tulanp'                          # Show all open ports
alias myip='curl -s ifconfig.me && echo'          # Get public IP address
alias weather='curl -s "wttr.in/?format=3"'       # Quick weather info
alias diskspace='df -h | grep -E "^/dev"'         # Show disk usage
alias meminfo='free -h'                           # Show memory usage

# ── Development Shortcuts ─────────────────────────────────────────────────────
# Git shortcuts (additional to plugin)
alias ga='git add .'                # Stage all changes
alias gs='git status -sb'           # Short status with branch info
alias gl='git log --oneline -15'    # Show last 15 commits (compact)
alias gd='git diff'                 # Show changes

# Framework shortcuts
alias serve='php artisan serve'     # Laravel development server
alias dev='npm run dev'             # Start development server (Vite/Webpack)
alias build='npm run build'         # Build for production

# ┌──────────────────────────────────────────────────────────────────────────────┐
# │ 🛠️  FUNCTIONS                                                                │
# └──────────────────────────────────────────────────────────────────────────────┘

# ── Directory Operations ──────────────────────────────────────────────────────

# mkcd - Make directory and cd into it
# Usage: mkcd my-new-project
mkcd() { 
  mkdir -p "$1" && cd "$1" 
}

# extract - Extract any archive format automatically
# Usage: extract archive.zip
# Supports: .tar.bz2, .tar.gz, .tar.xz, .tar, .bz2, .gz, .zip, .rar, .7z
extract() {
  if [[ -z "$1" ]]; then
    echo "⚠️  Usage: extract <file>"
    return 1
  fi
  
  if [[ ! -f "$1" ]]; then
    echo "❌ File not found: $1"
    return 1
  fi
  
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
    *)         echo "❌ Unsupported format: $1" ;;
  esac
}

# ── C Programming Helper Functions ───────────────────────────────────────────

# compile - Compile and run C programs in one command
# Usage: compile program.c [args for program]
# Example: compile hello.c
#          compile calculator.c 5 10
compile() {
  if [[ -z "$1" ]]; then
    echo "⚠️  Usage: compile <file.c> [program arguments...]"
    return 1
  fi
  
  if [[ ! -f "$1" ]]; then
    echo "❌ File not found: $1"
    return 1
  fi
  
  local src="$1"
  local out="${1%.c}"  # Remove .c extension for output
  shift  # Remaining args are for the program
  
  # Check if clang is installed
  if (( ! $+commands[clang] )); then
    echo "❌ clang not found. Install with: sudo pacman -S clang"
    return 1
  fi
  
  echo "🛠️  Compiling: $src"
  if clang -Wall -Wextra -std=c99 -g "$src" -o "$out"; then
    echo "✅ Output binary: $out"
    echo "🚀 Running...\n"
    "./$out" "$@"
  else
    echo "❌ Compilation failed!"
    return 1
  fi
}

# debug-compile - Compile with debug symbols and AddressSanitizer
# Usage: debug-compile program.c
# Run with: gdb ./program
debug-compile() {
  if [[ -z "$1" ]]; then
    echo "⚠️  Usage: debug-compile <file.c>"
    return 1
  fi
  
  local src="$1"
  local out="${1%.c}"
  
  clang -Wall -Wextra -std=c99 -g -O0 -fsanitize=address "$src" -o "$out" && \
    echo "✅ Debug build created: $out\n💡 Run with: gdb ./$out"
}

# ── Git Workflow Functions ────────────────────────────────────────────────────

# Multi-account Git configuration
# Format: "Name|email|ssh-host-alias"
typeset -A GIT_ACCOUNTS
GIT_ACCOUNTS=(
  [personal]="Budi Imam Prasetyo|budiimamprsty@gmail.com|github.com-personal"
  [kampus]="Budi Prasetyo|budi.prasetyo@satu.ac.id|github.com-kampus"
)

# gacp - Git Add, Commit, and Push in one command
# Usage: gacp "your commit message"
# Automatically detects internet connection and pushes only if online
gacp() {
  if [[ -z "$1" ]]; then
    echo "⚠️  Usage: gacp \"commit message\""
    return 1
  fi
  
  local branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
  if [[ -z "$branch" ]]; then
    echo "❌ Not a Git repository!"
    return 1
  fi
  
  echo "📦 Committing to branch: $branch"
  git add . && git commit -m "$1" || return 1
  
  # Check internet connectivity before pushing
  if curl -s --connect-timeout 2 https://github.com >/dev/null 2>&1; then
    git push -u origin "$branch" && echo "🚀 Successfully pushed to $branch!"
  else
    echo "⚠️  Offline. Run 'git push' when you're back online."
  fi
}

# init-repo - Initialize new Git repository with specific account
# Usage: init-repo personal   # or: init-repo kampus
init-repo() {
  local account="${GIT_ACCOUNTS[$1]}"
  
  if [[ -z "$account" ]]; then
    echo "⚠️  Usage: init-repo <personal|kampus>"
    return 1
  fi
  
  local name="${account%%|*}"
  local email="${${account#*|}%%|*}"
  
  git init
  git config user.name "$name"
  git config user.email "$email"
  echo "✅ Repository initialized with: $name <$email>"
}

# use-git - Switch Git account in existing repository
# Usage: use-git personal   # or: use-git kampus
# Automatically updates remote URL if needed
use-git() {
  if [[ ! -d .git ]]; then
    echo "⚠️  Not a Git repository!"
    return 1
  fi
  
  local account="${GIT_ACCOUNTS[$1]}"
  
  if [[ -z "$account" ]]; then
    echo "⚙️  Usage: use-git <personal|kampus>"
    return 1
  fi
  
  local name="${account%%|*}"
  local email="${${account#*|}%%|*}"
  local host="${account##*|}"
  local other_host=$([[ "$1" == "personal" ]] && echo "github.com-kampus" || echo "github.com-personal")
  
  # Update git config
  git config user.name "$name"
  git config user.email "$email"
  
  # Update remote URL if it uses the other account's host
  local url=$(git remote get-url origin 2>/dev/null)
  if [[ "$url" == *"$other_host"* ]]; then
    git remote set-url origin "${url/$other_host/$host}"
  fi
  
  echo "✅ Switched to: $name ($1 account)"
}

# zpush - Sync .zshrc to backup repository
# Usage: zpush "updated aliases"
# Backs up your ZSH config to ~/ZSH-Config repository
zpush() {
  if [[ -z "$1" ]]; then
    echo "⚠️  Usage: zpush \"commit message\""
    return 1
  fi
  
  local repo="$HOME/ZSH-Config"
  
  if [[ ! -d "$repo" ]]; then
    echo "❌ Backup repository not found: $repo"
    echo "💡 Create it with: mkdir ~/ZSH-Config && cd ~/ZSH-Config && git init"
    return 1
  fi
  
  cp ~/.zshrc "$repo/" && \
  git -C "$repo" add -A && \
  git -C "$repo" commit -m "$1" && \
  git -C "$repo" push && \
  echo "✅ .zshrc synced to backup repository!"
}

# ── Utility Functions ─────────────────────────────────────────────────────────

# githack - Convert GitHub URLs to raw.githack.com CDN links
# Usage: githack https://github.com/user/repo/blob/main/script.js
# Automatically copies to clipboard if xclip is installed
githack() {
  if [[ -z "$1" ]]; then
    echo "⚠️  Usage: githack <github-url>"
    return 1
  fi
  
  local url="$1"
  local out=""
  
  case "$url" in
    # Already a githack URL
    *raw.githack.com*)
      out="$url"
      ;;
    # raw.githubusercontent.com URL
    *raw.githubusercontent.com*)
      if [[ "$url" =~ 'raw.githubusercontent.com/([^/]+)/([^/]+)/([^/]+)/(.*)' ]]; then
        out="https://raw.githack.com/${match[1]}/${match[2]}/${match[3]}/${match[4]}"
      fi
      ;;
    # GitHub blob URL
    *github.com*/blob/*)
      if [[ "$url" =~ 'github.com/([^/]+)/([^/]+)/blob/([^/]+)/(.*)' ]]; then
        out="https://raw.githack.com/${match[1]}/${match[2]}/${match[3]}/${match[4]}"
      fi
      ;;
    *)
      echo "❌ Invalid GitHub URL"
      return 1
      ;;
  esac
  
  echo "🌐 $out"
  
  # Copy to clipboard if xclip is available
  if (( $+commands[xclip] )); then
    echo -n "$out" | xclip -selection clipboard
    echo "📋 Copied to clipboard!"
  fi
}

# note - Quick note-taking system
# Usage:
#   note                     # Open notes in editor
#   note "your note here"    # Add timestamped note
#   note -l                  # List all notes
#   note -c                  # Clear all notes
note() {
  local file="$HOME/.notes.md"
  
  case "$1" in
    -l|--list)
      if [[ -f "$file" ]]; then
        cat "$file"
      else
        echo "📝 No notes yet."
      fi
      ;;
    -c|--clear)
      : > "$file"
      echo "🗑️  All notes cleared!"
      ;;
    "")
      ${EDITOR:-nano} "$file"
      ;;
    *)
      echo "- $(date '+%Y-%m-%d %H:%M'): $*" >> "$file"
      echo "📝 Note saved!"
      ;;
  esac
}

# bench - Benchmark command execution time
# Usage: bench npm run build
bench() {
  local start=$(date +%s.%N)
  "$@"
  local end=$(date +%s.%N)
  echo "\n⏱️  Execution time: $(echo "$end - $start" | bc)s"
}

# fkill - Fuzzy search and kill process
# Usage: fkill
# Opens fzf to select process, then kills it
fkill() {
  local pid=$(ps aux | fzf --header="Select process to kill" | awk '{print $2}')
  
  if [[ -n "$pid" ]]; then
    kill -9 "$pid"
    echo "💀 Killed process with PID: $pid"
  fi
}

# ┌──────────────────────────────────────────────────────────────────────────────┐
# │ 📚 HELP & DOCUMENTATION                                                      │
# └──────────────────────────────────────────────────────────────────────────────┘

# zhelp - Display all custom commands and their usage
# Usage: zhelp
zhelp() {
  cat << 'EOF'
╔══════════════════════════════════════════════════════════════════════════════╗
║                        🚀 CUSTOM ZSH COMMANDS REFERENCE                      ║
╠══════════════════════════════════════════════════════════════════════════════╣
║                                                                              ║
║  📁 FILE & NAVIGATION                                                        ║
║  ───────────────────────────────────────────────────────────────────────     ║
║  mkcd <dir>           Create directory and cd into it                        ║
║  extract <file>       Extract any archive format automatically               ║
║  lt / lta             Tree view (2 levels) with/without hidden files         ║
║  dl / desk / proj     Quick jump to Downloads / Desktop / Projects           ║
║  .. / ... / ....      Navigate up 1/2/3 directories                          ║
║  -                    Return to previous directory                           ║
║                                                                              ║
║  💻 DEVELOPMENT                                                              ║
║  ───────────────────────────────────────────────────────────────────────     ║
║  compile <file.c> [args]    Compile and run C program                        ║
║  debug-compile <file.c>     Compile with debug symbols for GDB              ║
║  bench <command>            Measure command execution time                   ║
║  dev / serve / build        Start dev server / Laravel serve / production    ║
║                                                                              ║
║  🔧 GIT WORKFLOW                                                             ║
║  ───────────────────────────────────────────────────────────────────────     ║
║  gacp "message"             Git add, commit, and push (one command)          ║
║  init-repo <personal|kampus>   Initialize repo with specific account        ║
║  use-git <personal|kampus>     Switch Git account in current repo           ║
║  zpush "message"            Sync .zshrc to backup repository                 ║
║  ga / gs / gl / gd          Git shortcuts (add, status, log, diff)           ║
║                                                                              ║
║  🛠️  UTILITIES                                                               ║
║  ───────────────────────────────────────────────────────────────────────     ║
║  githack <url>              Convert GitHub URL to CDN link                   ║
║  note [text]                Quick note-taking (add/edit/list/clear)          ║
║    note "text"              Add timestamped note                             ║
║    note -l                  List all notes                                   ║
║    note -c                  Clear all notes                                  ║
║  fkill                      Fuzzy search and kill process                    ║
║                                                                              ║
║  ℹ️  SYSTEM INFO                                                             ║
║  ───────────────────────────────────────────────────────────────────────     ║
║  myip                       Show public IP address                           ║
║  weather                    Get current weather                              ║
║  ports                      List all open ports                              ║
║  diskspace                  Show disk usage                                  ║
║  meminfo                    Show memory usage                                ║
║                                                                              ║
║  ⚙️  CONFIG                                                                   ║
║  ───────────────────────────────────────────────────────────────────────     ║
║  zconfig                    Edit this configuration                          ║
║  zreload                    Reload ZSH configuration                         ║
║  zhelp                      Show this help message                           ║
║  x / q                      Exit terminal                                    ║
║                                                                              ║
╠══════════════════════════════════════════════════════════════════════════════╣
║  💡 TIP: Run 'zhelp' anytime to see this reference!                          ║
╚══════════════════════════════════════════════════════════════════════════════╝
EOF
}

# Show welcome message with quick tips (optional - comment out if not needed)
# Uncomment the lines below to show tips on shell startup
# echo "✨ Custom ZSH config loaded! Type 'zhelp' for available commands."
