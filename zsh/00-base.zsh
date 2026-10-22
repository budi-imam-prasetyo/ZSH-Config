# Base system configuration, environment, history, and shell options.
export DOCKER_HOST="unix:///run/user/${UID}/podman/podman.sock"
source /usr/share/cachyos-zsh-config/cachyos-config.zsh
unset PROMPT_COMMAND

typeset -U path fpath
path=(
  ${JAVA_HOME:+$JAVA_HOME/bin}(N-/)
  $HOME/bin(N-/)
  $HOME/.local/bin(N-/)
  $HOME/.local/share/fnm(N-/)
  $HOME/.cargo/bin(N-/)
  $HOME/.bun/bin(N-/)
  $HOME/go/bin(N-/)
  $HOME/.config/herd-lite/bin(N-/)
  $HOME/.local/share/pnpm/bin(N-/)
  $HOME/.opencode/bin(N-/)
  $path
)

export PNPM_HOME="$HOME/.local/share/pnpm"
export MICRO_TRUECOLOR=1
export BAT_THEME="Catppuccin Mocha"
export EDITOR=fresh
(( $+commands[dircolors] )) && eval "$(dircolors -b)"

HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=50000
setopt EXTENDED_HISTORY HIST_IGNORE_ALL_DUPS HIST_IGNORE_SPACE
setopt HIST_FIND_NO_DUPS HIST_SAVE_NO_DUPS HIST_VERIFY
setopt AUTO_CD AUTO_PUSHD PUSHD_IGNORE_DUPS CORRECT INTERACTIVE_COMMENTS
