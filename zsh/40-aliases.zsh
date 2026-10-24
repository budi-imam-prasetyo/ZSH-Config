# Aliases and directory listing helper.
EZA_IGNORE='node_modules|vendor|dist|build|coverage|.git|.next|.nuxt|target'
ez() {
  emulate -L zsh
  local arg has_tree=0
  for arg in "$@"; do [[ $arg == (--tree|-T) ]] && has_tree=1; done
  if (( has_tree )); then
    command eza --icons --group-directories-first --color=auto -I "$EZA_IGNORE" "$@"
  else
    command eza --icons --group-directories-first --color=auto "$@"
  fi
}

alias ls='ez' ll='ez -lh --git' la='ez -la --git'
alias lt='ez -T --level=2' lta='ez -Ta --level=2'
alias ..='cd ..' ...='cd ../..' ....='cd ../../..' -='cd -' d='cd /data'
alias esco='zeditor ~/.config/espanso/match/base.yml' ncdu='sudo ncdu'
alias c='printf "\033c"' q='exit'
alias zconfig='zeditor ~/ZSH-Config' zfast='fresh ~/ZSH-Config' zreload='exec zsh'
alias yay='paru' i='paru -S' Rns='paru -Rns' Syu='paru -Syu'
alias Ss='paru -Ss' Qs='paru -Qs' Si='paru -Si' orphan='paru -Qdt'
alias clean-cache='paru -Sc' clean-cache-all='paru -Scc' clean-orphan='_clean_orphan'
alias wl='wl-copy <' jctl='journalctl -p 3 -xb' f='fresh'
alias reboot="systemctl reboot --dry-run >/dev/null && read -q '?Reboot sekarang? [y/N] ' && sudo systemctl reboot"
alias z='zellij' za='zellij attach --create' zls='zellij list-sessions'
alias zk='zellij kill-all-sessions' zr='zellij run --' ze='zellij edit'
