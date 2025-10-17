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
  zsh-syntax-highlighting
  fzf
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
    echo "Usage: compile <path/to/file.c>"
    return 1
  fi

  local output="${1%.c}"
  if gcc "$1" -o "$output"; then
    echo "✅ Compiled -> $output"
    "./$output"
  else
    echo "❌ Compilation failed"
    return 1
  fi
}

gacp() {
  if [ -z "$1" ]; then
    echo "Usage: gacp \"commit message\""
    return 1
  fi

  local branch
  branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
  if [ -z "$branch" ]; then
    echo "❌ Bukan repository git!"
    return 1
  fi

  echo "📦 Commiting to branch: $branch"
  if ! git add .; then
    echo "❌ Gagal menjalankan git add"
    return 1
  fi

  if ! git commit -m "$1"; then
    echo "❌ Commit gagal. Pastikan ada perubahan."
    return 1
  fi

  if ! git push -u origin "$branch"; then
    echo "❌ Push gagal. Cek koneksi atau permission."
    return 1
  fi

  echo "✅ Changes pushed successfully!"
}

zpush() {
  if [ -z "$1" ]; then
    echo "Usage: zpush \"commit message\""
    return 1
  fi

  local repo_dir="$HOME/dotfiles"
  local file="$HOME/.zshrc"
  local prev_dir="$PWD"

  if [ ! -d "$repo_dir" ]; then
    echo "❌ Folder dotfiles nggak ketemu di $repo_dir"
    return 1
  fi

  cd "$repo_dir" || return 1
  if ! cp "$file" .; then
    echo "❌ Gagal copy $file"
    cd "$prev_dir"
    return 1
  fi

  if ! git add .; then
    echo "❌ Git add gagal"
    cd "$prev_dir"
    return 1
  fi

  if ! git commit -m "$1"; then
    echo "❌ Commit gagal"
    cd "$prev_dir"
    return 1
  fi

  # Auto detect main branch
  local main_branch
  main_branch=$(git symbolic-ref --short refs/remotes/origin/HEAD 2>/dev/null | cut -d'/' -f2)
  main_branch=${main_branch:-main}

  if ! git push -u origin "$main_branch"; then
    echo "❌ Push gagal"
    cd "$prev_dir"
    return 1
  fi

  cd "$prev_dir"
  echo "✅ Zshrc pushed successfully!"
}

#* ==============================================
#? PROMPT CONFIGURATION
#* ==============================================

[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

#* ==============================================
#? ZINIT CONFIGURATION - Lazy Load
#* ==============================================

if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
  print -P "%F{33} Installing %F{220}Zinit%f..."
  command mkdir -p "$HOME/.local/share/zinit" && \
  command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

#* Lazy load non-critical plugins to improve startup
zinit wait lucid light-mode for \
  zdharma-continuum/zinit-annex-as-monitor \
  zdharma-continuum/zinit-annex-bin-gem-node \
  zdharma-continuum/zinit-annex-patch-dl \
  zdharma-continuum/zinit-annex-rust \
  MichaelAquilina/zsh-you-should-use

export PATH
