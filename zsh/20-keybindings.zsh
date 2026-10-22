# Interactive keybindings. Atuin owns history arrows later in the load order.
[[ -t 0 ]] && stty -ixon
bindkey '^[[C' forward-char
bindkey '^[[D' backward-char
bindkey '^[[1;5D' backward-word
bindkey '^[[1;5C' forward-word
bindkey -r '^S'
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^x^x' edit-command-line
bindkey '^ ' autosuggest-accept
