# Directory and long-command hooks.
autoload -Uz add-zsh-hook
zmodload zsh/datetime

do-ls() {
  emulate -L zsh
  command eza --icons --group-directories-first --color=auto -I "$EZA_IGNORE"
}
add-zsh-hook chpwd do-ls

_notify_send() {
  emulate -L zsh
  local urgency=$1 icon=$2 title=$3 body=$4
  if [[ -n $KITTY_WINDOW_ID ]] && (( $+commands[kitten] )); then
    kitten notify -u "$urgency" -n "$icon" -a "TAB $KITTY_WINDOW_ID" -- "$title" "$body"
  elif (( $+commands[notify-send] )); then
    notify-send -u "$urgency" -i "$icon" -a zsh -- "$title" "$body"
  fi
}

_notify_preexec() {
  _CMD_START_TIME=$EPOCHSECONDS
  _LAST_CMD="$1"
  _CMD_DIR="${PWD/#$HOME/~}"
}

_notify_precmd() {
  local exit_code=$?
  if (( exit_code == 130 )); then
    unset _CMD_START_TIME _LAST_CMD _CMD_DIR
    return
  fi
  [[ -n "$_CMD_START_TIME" ]] || return
  local elapsed=$(( EPOCHSECONDS - _CMD_START_TIME ))
  if (( elapsed >= 3 )); then
    local time_str
    if (( elapsed >= 60 )); then
      time_str="$(( elapsed / 60 ))m $(( elapsed % 60 ))s"
    else
      time_str="${elapsed}s"
    fi
    local display_cmd="$_LAST_CMD"
    (( ${#display_cmd} > 50 )) && display_cmd="${display_cmd:0:47}..."
    if (( exit_code == 0 )); then
      _notify_send normal info "✅ $display_cmd ($time_str)" "📁 $_CMD_DIR"
    else
      _notify_send critical error "❌ $display_cmd ($time_str) [Code: $exit_code]" "📁 $_CMD_DIR"
    fi
  fi
  unset _CMD_START_TIME _LAST_CMD _CMD_DIR
}

add-zsh-hook preexec _notify_preexec
add-zsh-hook precmd _notify_precmd
