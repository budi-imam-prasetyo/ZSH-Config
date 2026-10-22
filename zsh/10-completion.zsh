# Completion setup and autosuggestion defaults.
fpath=($HOME/.local/share/zsh/site-functions(N-/) $fpath)
zmodload zsh/complist
autoload -Uz compinit
() {
  local dump="${ZDOTDIR:-$HOME}/.zcompdump"
  local -a fresh=( $dump(N.mh-24) )
  if (( $#fresh )); then
    compinit -C -d "$dump"
  else
    compinit -d "$dump"
  fi
}

setopt MENU_COMPLETE
zstyle ':completion:*' menu select
zstyle ':completion:*' group-name ''
zstyle ':completion:*' verbose yes
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompcache"

ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_USE_ASYNC=1
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=50
