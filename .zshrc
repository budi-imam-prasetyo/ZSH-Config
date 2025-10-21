#* ==============================================
#? ZSH CONFIGURATION - Optimized & Secure Edition
#* ==============================================

#! ----- Powerlevel10k Instant Prompt -----
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

#! ----- Oh My Zsh Path -----
export ZSH="$HOME/.oh-my-zsh"

#! ----- Theme -----
ZSH_THEME="powerlevel10k/powerlevel10k"

#! ----- Plugins -----
plugins=(
  git
  zsh-autosuggestions
  fzf
  zsh-syntax-highlighting
)

#! ----- Load Oh My Zsh -----
source "$ZSH/oh-my-zsh.sh"

#* ==============================================
#? ENVIRONMENT CONFIGURATION
#* ==============================================

#! ----- PATH (idempotent version) -----
paths=(
  "$HOME/bin"
  "$HOME/.local/bin"
  "$HOME/.fnm"
  "$HOME/.local/share/fnm"
  "$HOME/.cargo/bin"
  "$HOME/.bun/bin"
)
for p in "${paths[@]}"; do
  [[ ":$PATH:" != *":$p:"* ]] && PATH="$p:$PATH"
done
export PATH

#! ----- FNM (Fast Node Manager) -----
if command -v fnm >/dev/null 2>&1; then
  eval "$(fnm env --use-on-cd --shell zsh)"
fi

#! ----- Zoxide -----
if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh)"
fi

#! ----- FZF -----
if command -v fzf >/dev/null 2>&1; then
  [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
fi

#! ----- Bun completions -----
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

#* ==============================================
#? ZSH BEHAVIOR SETTINGS
#* ==============================================

ENABLE_CORRECTION="true"
HIST_STAMPS="yyyy-mm-dd"

#* ==============================================
#? CUSTOM ALIASES
#* ==============================================

alias ls='eza --icons --group-directories-first'
alias ll='eza -lh --icons --git'
alias la='eza -la --icons'
alias download='cd /home/data/ryoukaii/Downloads/'
alias zconfig='code ~/.zshrc'
alias c='clear'
alias x='exit'
alias ga='git add .'
alias serve='php artisan serve'
alias dev='npm run dev'
alias ..='cd ..'
alias ...='cd ../..'

#* ==============================================
#? CUSTOM FUNCTIONS - Secured
#* ==============================================

compile() {
  if [ -z "$1" ]; then
    echo "⚠️  Penggunaan: compile <path/ke/file.c>"
    return 1
  fi

  local output="${1%.c}"
  if gcc "$1" -o "$output"; then
    echo "✅ Kompilasi berhasil! Menjalankan file → $output"
    "./$output"
  else
    echo "❌ Kompilasi gagal. Periksa kembali kode sumbermu."
    return 1
  fi
}

gacp() {
  if [ -z "$1" ]; then
    echo "⚠️  Penggunaan: gacp \"pesan commit\""
    return 1
  fi

  local branch
  branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
  if [ -z "$branch" ]; then
    echo "❌ Direktori ini bukan repository Git!"
    return 1
  fi

  echo "📦 Melakukan commit ke branch: $branch"
  if ! git add .; then
    echo "❌ Gagal menambahkan perubahan ke staging area."
    return 1
  fi

  if ! git commit -m "$1"; then
    echo "❌ Commit gagal. Pastikan ada perubahan sebelum commit."
    return 1
  fi

  echo "🌐 Mengecek koneksi internet..."
  if ping -c 1 -W 1 github.com &>/dev/null; then
    echo "✅ Internet terhubung. Mengirim perubahan ke remote..."
    if ! git push -u origin "$branch"; then
      echo "❌ Gagal mengirim perubahan. Periksa izin repository atau remote branch."
      return 1
    fi
    echo "🚀 Perubahan berhasil dikirim ke branch \"$branch\"!"
  else
    echo "⚠️  Tidak ada koneksi internet."
    echo "💾 Commit tetap tersimpan di lokal. Jalankan 'git push' nanti saat online."
  fi
}

zpush() {
  if [ -z "$1" ]; then
    echo "⚠️  Penggunaan: zpush \"pesan commit\""
    return 1
  fi

  local repo_dir="$HOME/dotfiles"
  local file="$HOME/.zshrc"
  local prev_dir="$PWD"

  if [ ! -d "$repo_dir" ]; then
    echo "❌ Folder dotfiles tidak ditemukan di $repo_dir"
    return 1
  fi

  cd "$repo_dir" || return 1
  if ! cp "$file" .; then
    echo "❌ Gagal menyalin file konfigurasi Zsh dari $file"
    cd "$prev_dir"
    return 1
  fi

  if ! git add .; then
    echo "❌ Gagal menambahkan file ke Git."
    cd "$prev_dir"
    return 1
  fi

  if ! git commit -m "$1"; then
    echo "❌ Gagal membuat commit. Mungkin tidak ada perubahan."
    cd "$prev_dir"
    return 1
  fi

  # Deteksi branch utama secara otomatis
  local main_branch
  main_branch=$(git symbolic-ref --short refs/remotes/origin/HEAD 2>/dev/null | cut -d'/' -f2)
  main_branch=${main_branch:-master}

  if ! git push -u origin "$main_branch"; then
    echo "❌ Gagal mengirim perubahan ke branch utama ($main_branch)."
    cd "$prev_dir"
    return 1
  fi

  cd "$prev_dir"
  echo "✅ File .zshrc berhasil diperbarui dan dikirim ke repository!"
}


#* ==============================================
#? PROMPT CONFIGURATION
#* ==============================================

[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh
