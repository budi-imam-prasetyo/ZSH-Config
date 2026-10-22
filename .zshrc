# Modular Zsh configuration.
typeset config_dir="${${(%):-%x}:A:h}/zsh"

source "$config_dir/00-base.zsh"
source "$config_dir/10-completion.zsh"
source "$config_dir/20-keybindings.zsh"
source "$config_dir/30-fzf.zsh"
source "$config_dir/40-aliases.zsh"
source "$config_dir/50-functions.zsh"
source "$config_dir/60-hooks.zsh"
source "$config_dir/70-integrations.zsh"
source "$config_dir/80-plugins.zsh"

unset config_dir
