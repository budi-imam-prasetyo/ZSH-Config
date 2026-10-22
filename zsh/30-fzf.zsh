# FZF defaults and per-widget options.
if (( $+commands[wl-copy] )); then
  _FZF_CLIP_BIND="--bind 'enter,double-click:execute-silent(cat {+f} | wl-copy)+accept'"
elif (( $+commands[xclip] )); then
  _FZF_CLIP_BIND="--bind 'enter,double-click:execute-silent(cat {+f} | xclip -selection clipboard)+accept'"
elif (( $+commands[xsel] )); then
  _FZF_CLIP_BIND="--bind 'enter,double-click:execute-silent(cat {+f} | xsel --clipboard --input)+accept'"
else
  _FZF_CLIP_BIND=
fi

export FZF_DEFAULT_OPTS="--height 80% \
--min-height 20 --layout=reverse --border=rounded \
--border-label ' 🔎 FZF ' --border-label-pos 3 --style=full \
--pointer '▌' --marker '▌' --prompt '❯ ' --input-border rounded \
--input-label ' Search ' --input-label-pos 2 --header-border line \
--preview-border rounded --preview-window='right,55%,wrap-word,~3' \
--preview '$HOME/.local/bin/fzf-preview.sh {}' --highlight-line --cycle \
--filepath-word --track --ellipsis '…' --scrollbar '▐' --tabstop 2 \
--separator '─' --ghost 'Ketik untuk mencari…' --info=inline-right \
--wrap=word \
--bind 'focus:transform-preview-label:[[ -n {} ]] && printf \" Previewing [%s] \" {}' \
--bind 'focus:transform-header:file --brief {} 2>/dev/null || echo {}' \
--bind 'result:transform-list-label:if [[ -z \$FZF_QUERY ]]; then echo \"  \$FZF_MATCH_COUNT items \"; else echo \"  \$FZF_MATCH_COUNT matches untuk [\$FZF_QUERY] \"; fi' \
--color=bg:#1e1e2e,bg+:#313244,fg:#cdd6f4,fg+:#cdd6f4 \
--color=hl:#f38ba8,hl+:#f38ba8,info:#cba6f7,marker:#f5e0dc \
--color=prompt:#cba6f7,spinner:#f5e0dc,pointer:#f5e0dc,header:#a6adc8 \
--color=border:#89b4fa,label:#b4befe,separator:#45475a,preview-border:#89b4fa \
--color=preview-label:#b4befe,input-border:#89b4fa,input-label:#b4befe \
--color=header-border:#45475a,list-border:#89b4fa,list-label:#b4befe \
--color=gutter:#1e1e2e,scrollbar:#45475a,preview-scrollbar:#45475a,ghost:#6c7086 \
--bind 'ctrl-/:change-preview-window(down,50%|hidden|right,55%)' \
--bind 'ctrl-u:half-page-up,ctrl-d:half-page-down' \
${_FZF_CLIP_BIND}"
unset _FZF_CLIP_BIND

export FZF_CTRL_T_OPTS="--border-label ' 📁 Files '"
export FZF_ALT_C_OPTS="--border-label ' 📂 Dirs '"
export FZF_CTRL_R_OPTS="--no-preview --border-label ' 🕘 History '"
export FZF_BASE=/usr/share/fzf
