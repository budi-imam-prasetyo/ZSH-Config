#* ==============================================
#? ZSH CONFIGURATION - Clean & Optimized
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

#! ----- PATH -----
export PATH="$HOME/bin:$HOME/.local/bin:$HOME/.fnm:$PATH"

#! ----- FNM (Fast Node Manager) -----
FNM_PATH="$HOME/.local/share/fnm"
if [ -d "$FNM_PATH" ]; then
  export PATH="$FNM_PATH:$PATH"
  eval "$(fnm env)"
fi

#! ----- Zoxide -----
eval "$(zoxide init zsh)"

#! ----- FZF -----
if command -v fzf >/dev/null 2>&1; then
  [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
fi


#* ==============================================
#? ZSH BEHAVIOR SETTINGS
#* ==============================================

ENABLE_CORRECTION="true"     #* Auto-correct minor typos
HIST_STAMPS="yyyy-mm-dd"     #* History timestamp format
#* HYPHEN_INSENSITIVE="true"  #* Treat - and _ as the same
#* DISABLE_AUTO_TITLE="true"  #* Disable automatic terminal title updates


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
#? CUSTOM FUNCTIONS
#* ==============================================

compile() {
  if [ -z "$1" ]; then
    echo "Usage: compile <path/to/file.c>"
    return 1
  fi

  local output="${1%.c}"
  gcc "$1" -o "$output" && echo "Compiled -> $output" && "$output"
}

gacp() {
  if [ -z "$1" ]; then
    echo "Usage: gacp \"commit message\""
    return 1
  fi

  # Cek branch saat ini
  local branch
  branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)

  if [ -z "$branch" ]; then
    echo "❌ Bukan repository git!"
    return 1
  fi

  # Jalankan step git
  git add . || return 1
  git commit -m "$1" || return 1
  git push -u origin "$branch"
}

zpush() {
  if [ -z "$1" ]; then
    echo "Usage: zpush \"commit message\""
    return 1
  fi

  local repo_dir="$HOME/dotfiles"
  local file="$HOME/.zshrc"

  if [ ! -d "$repo_dir" ]; then
    echo "❌ Folder dotfiles nggak ketemu di $repo_dir"
    return 1
  fi

  cd "$repo_dir" || return 1

  # Copy file terbaru
  cp "$file" . || {
    echo "❌ Gagal copy $file"
    return 1
  }

  # Jalankan git steps
  git add . || return 1
  git commit -m "$1" || return 1
  git push -u origin master

  echo "✅ Zshrc pushed successfully!"
}


#* ==============================================
#? PROMPT CONFIGURATION
#* ==============================================

[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh


#* ==============================================
#? ZINIT CONFIGURATION
#* ==============================================

#! ----- Installer -----
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
  print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
  command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
  command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
    print -P "%F{33} %F{34}Installation successful.%f%b" || \
    print -P "%F{160} The clone has failed.%f%b"
fi

#! ----- Source & Setup -----
source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

#! ----- Load Annexes -----
zinit light-mode for \
  zdharma-continuum/zinit-annex-as-monitor \
  zdharma-continuum/zinit-annex-bin-gem-node \
  zdharma-continuum/zinit-annex-patch-dl \
  zdharma-continuum/zinit-annex-rust \
  MichaelAquilina/zsh-you-should-use
export PATH="$HOME/.cargo/bin:$PATH"

# bun completions
[ -s "/home/ryoukaii/.bun/_bun" ] && source "/home/ryoukaii/.bun/_bun"

eval "$(fnm env --use-on-cd --shell zsh)"
# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"