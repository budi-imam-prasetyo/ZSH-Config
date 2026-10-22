# Tool integrations and completion adapters.
(( $+commands[fnm] )) && eval "$(fnm env --use-on-cd --shell zsh)"
(( $+commands[zoxide] )) && eval "$(zoxide init zsh --cmd cd)"
[[ -s "$HOME/.bun/_bun" ]] && source "$HOME/.bun/_bun"
[[ -r "$HOME/.config/broot/launcher/bash/br" ]] && source "$HOME/.config/broot/launcher/bash/br"
[[ -r "$HOME/.openclaw/completions/openclaw.zsh" ]] && source "$HOME/.openclaw/completions/openclaw.zsh"

_opencode_yargs_completions() {
  local reply si=$IFS
  IFS=$'\n' reply=($(COMP_CWORD="$((CURRENT-1))" COMP_LINE="$BUFFER" COMP_POINT="$CURSOR" opencode --get-yargs-completions "${words[@]}"))
  IFS=$si
  if (( ${#reply} )); then
    _describe 'values' reply
  else
    _default
  fi
}
(( $+commands[opencode] )) && compdef _opencode_yargs_completions opencode
