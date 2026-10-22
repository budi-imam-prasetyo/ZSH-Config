# Plugins, prompt, and history search. Keep this order.
source /usr/share/doc/pkgfile/command-not-found.zsh
source /usr/share/fzf/key-bindings.zsh
[[ -r /usr/share/fzf/completion.zsh ]] && source /usr/share/fzf/completion.zsh
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

eval "$(starship init zsh)"
[[ -r "$HOME/.atuin/bin/env" ]] && source "$HOME/.atuin/bin/env"
(( $+commands[atuin] )) && eval "$(atuin init zsh)"
(( $+commands[zsh-patina] )) && eval "$(zsh-patina activate)"
[[ -s "$HOME/.bun/_bun" ]] && source "$HOME/.bun/_bun"
