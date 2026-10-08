# ╔══════════════════════════════════════════════════════════════════════════════╗
# ║                     🚀 KONFIGURASI ZSH PRIBADI - CACHYOS                     ║
# ╚══════════════════════════════════════════════════════════════════════════════╝

# ┌──────────────────────────────────────────────────────────────────────────────┐
# │ 🔌 BASE CONFIG                                                               │
# └──────────────────────────────────────────────────────────────────────────────┘

# Podman socket sebagai backend Docker ($UID = builtin, tanpa fork ke id(1))
export DOCKER_HOST="unix:///run/user/${UID}/podman/podman.sock"

# Load konfigurasi bawaan CachyOS
# CATATAN: file ini TIDAK memuat oh-my-zsh (semua source-nya dikomentari),
# jadi array `plugins=(...)` gaya omz tidak berefek apa pun di sini.
source /usr/share/cachyos-zsh-config/cachyos-config.zsh

# PROMPT_COMMAND milik bash, bukan zsh
unset PROMPT_COMMAND

# ┌──────────────────────────────────────────────────────────────────────────────┐
# │ 🌍 ENVIRONMENT & PATH                                                        │
# └──────────────────────────────────────────────────────────────────────────────┘

typeset -U path fpath  # Cegah duplikasi

# Hanya direktori yang benar-benar ada yang dimasukkan.
# Glob qualifier (N-/) = nullglob + harus direktori. Ini mencegah entry kosong
# seperti "$JAVA_HOME/bin" berubah jadi "/bin" saat JAVA_HOME belum di-set.
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

# LS_COLORS dibutuhkan oleh zstyle list-colors di bawah. Tanpa ini variabelnya
# kosong dan pewarnaan menu completion mati diam-diam.
(( $+commands[dircolors] )) && eval "$(dircolors -b)"

# ┌──────────────────────────────────────────────────────────────────────────────┐
# │ 📜 HISTORY                                                                   │
# └──────────────────────────────────────────────────────────────────────────────┘

HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=50000

setopt EXTENDED_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_FIND_NO_DUPS
setopt HIST_SAVE_NO_DUPS
setopt HIST_VERIFY

# Sync history realtime antar terminal (atuin sudah menangani pencarian lintas
# sesi, jadi ini opsional)
# setopt SHARE_HISTORY

# ┌──────────────────────────────────────────────────────────────────────────────┐
# │ ⌨️  COMPLETION                                                                │
# └──────────────────────────────────────────────────────────────────────────────┘

# Completion milik tool yang dipasang manual (mis. lerd) hidup di sini.
fpath=($HOME/.local/share/zsh/site-functions(N-/) $fpath)

# zsh/complist WAJIB di-load agar `zstyle menu select` punya widget menu-select
# (highlight + navigasi panah di dalam menu completion).
zmodload zsh/complist

# compinit dijalankan sendiri, bukan menumpang skrip completion pihak ketiga.
# Sebelumnya compinit hanya terpanggil sebagai efek samping dari ~/.bun/_bun —
# begitu bun dihapus, `compdef` langsung hilang dan semua completion mati.
autoload -Uz compinit
() {
  local dump="${ZDOTDIR:-$HOME}/.zcompdump"
  # Rebuild penuh maksimal sekali per 24 jam; sisanya pakai cache (-C).
  # (N.mh-24) = file ada DAN mtime lebih baru dari 24 jam lalu.
  local -a fresh=( $dump(N.mh-24) )
  if (( $#fresh )); then
    compinit -C -d "$dump"
  else
    compinit -d "$dump"
  fi
}

# MENU_COMPLETE langsung menyisipkan kandidat pertama, sehingga AUTO_MENU
# (tampilkan menu di TAB kedua) tidak pernah kepakai. Pilih satu saja.
setopt MENU_COMPLETE

zstyle ':completion:*' menu select
zstyle ':completion:*' group-name ''
zstyle ':completion:*' verbose yes
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompcache"

# Autosuggestion
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_USE_ASYNC=1
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=50

# ┌──────────────────────────────────────────────────────────────────────────────┐
# │ ⌨️  KEYBINDINGS                                                               │
# └──────────────────────────────────────────────────────────────────────────────┘

# Matikan flow control (Ctrl-S/Ctrl-Q) hanya kalau stdin memang terminal,
# supaya tidak memuntahkan error di shell non-interaktif/skrip.
[[ -t 0 ]] && stty -ixon

bindkey '^[[C' forward-char
bindkey '^[[D' backward-char
bindkey '^[[1;5D' backward-word
bindkey '^[[1;5C' forward-word
bindkey -r '^S'

# CATATAN: panah atas/bawah sengaja tidak di-bind di sini — atuin (di bagian
# bawah file) mengambil alih ^[[A/^[[B untuk pencarian history-nya.

autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^x^x' edit-command-line

# Ctrl+Space menerima autosuggestion
bindkey '^ ' autosuggest-accept

# ┌──────────────────────────────────────────────────────────────────────────────┐
# │ ⚙️  OPSI ZSH                                                                 │
# └──────────────────────────────────────────────────────────────────────────────┘

setopt AUTO_CD
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS
setopt CORRECT
setopt INTERACTIVE_COMMENTS

# ┌──────────────────────────────────────────────────────────────────────────────┐
# │ 🔎 FZF                                                                       │
# └──────────────────────────────────────────────────────────────────────────────┘

# Clipboard on accept (dideteksi sekali; no-op kalau tidak ada tool clipboard)
if (( $+commands[wl-copy] )); then
  _FZF_CLIP_BIND="--bind 'enter,double-click:execute-silent(cat {+f} | wl-copy)+accept'"
elif (( $+commands[xclip] )); then
  _FZF_CLIP_BIND="--bind 'enter,double-click:execute-silent(cat {+f} | xclip -selection clipboard)+accept'"
elif (( $+commands[xsel] )); then
  _FZF_CLIP_BIND="--bind 'enter,double-click:execute-silent(cat {+f} | xsel --clipboard --input)+accept'"
else
  _FZF_CLIP_BIND=
fi

# Catppuccin Mocha — selaras dengan BAT_THEME
export FZF_DEFAULT_OPTS="--height 80% \
--min-height 20 \
--layout=reverse \
--border=rounded \
--border-label ' 🔎 FZF ' \
--border-label-pos 3 \
--style=full \
--pointer '▌' \
--marker '▌' \
--prompt '❯ ' \
--input-border rounded \
--input-label ' Search ' \
--input-label-pos 2 \
--header-border line \
--preview-border rounded \
--preview-window='right,55%,wrap-word,~3' \
--preview '$HOME/.local/bin/fzf-preview.sh {}' \
--highlight-line \
--cycle \
--filepath-word \
--track \
--ellipsis '…' \
--scrollbar '▐' \
--separator '─' \
--ghost 'Ketik untuk mencari…' \
--info=inline-right \
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
--color=gutter:#1e1e2e,preview-scrollbar:#45475a,ghost:#6c7086 \
--bind 'ctrl-/:change-preview-window(down,50%|right,55%)' \
--bind 'ctrl-u:half-page-up,ctrl-d:half-page-down' \
${_FZF_CLIP_BIND}"
unset _FZF_CLIP_BIND

export FZF_BASE=/usr/share/fzf

# ┌──────────────────────────────────────────────────────────────────────────────┐
# │ 🎨 ALIAS                                                                     │
# └──────────────────────────────────────────────────────────────────────────────┘

# ── Listing & Navigasi ────────────────────────────────────────────────────────

EZA_IGNORE='node_modules|vendor|dist|build|coverage|.git|.next|.nuxt|target'

# PENTING: fungsi ini TIDAK BOLEH diberi nama `_eza`. Paket eza memasang
# completion function bernama `_eza` di /usr/share/zsh/site-functions/_eza;
# mendefinisikan fungsi dengan nama sama menimpanya dan mematikan `eza <TAB>`.
ez() {
  emulate -L zsh
  local arg has_tree=0
  for arg in "$@"; do
    [[ $arg == (--tree|-T) ]] && has_tree=1
  done

  if (( has_tree )); then
    command eza --icons --group-directories-first --color=auto -I "$EZA_IGNORE" "$@"
  else
    command eza --icons --group-directories-first --color=auto "$@"
  fi
}

alias ls='ez'
alias ll='ez -lh --git'
alias la='ez -la --git'
alias lt='ez -T --level=2'
alias lta='ez -Ta --level=2'

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias -- -='cd -'

alias esco='code ~/.config/espanso/match/base.yml'

# ── Sistem & Produktivitas ────────────────────────────────────────────────────

alias c='printf "\033c"'
alias q='exit'

alias zconfig='code ~/ZSH-Config'
alias zfast='fresh ~/ZSH-Config/.zshrc'
alias zreload='exec zsh'

# Paket (paru)
alias yay="paru"
alias i="paru -S"
alias rmpkg="paru -Rns"
alias up="paru -Syu"
alias s="paru -Ss"
alias pinfo="paru -Si"        # `info` bentrok dgn /usr/bin/info (texinfo)
alias orphan="paru -Qdt"
alias clean-cache="paru -Sc"
alias clean-cache-all="paru -Scc"
alias clean-orphan="_clean_orphan"

# ── Arch Helper ───────────────────────────────────────────────────────────────

alias wl="wl-copy <"

# ── Logs ──────────────────────────────────────────────────────────────────────

alias jctl="journalctl -p 3 -xb"

# ── Misc ──────────────────────────────────────────────────────────────────────

alias f="fresh"

# Konfirmasi dulu — `reboot` menimpa /usr/bin/reboot dan sangat mudah kepencet
alias reboot="systemctl reboot --dry-run >/dev/null && read -q '?Reboot sekarang? [y/N] ' && sudo systemctl reboot"

# Zellij (butuh paket `zellij`; aliasnya aman walau belum terpasang)
alias z='zellij'                    # start fresh session
alias za='zellij attach --create'   # attach atau create
alias zls='zellij list-sessions'    # list active sessions
alias zk='zellij kill-all-sessions' # nuke semua session
alias zr='zellij run --'            # run command di pane baru
alias ze='zellij edit'              # edit file di pane baru

# ┌──────────────────────────────────────────────────────────────────────────────┐
# │ 🛠️  FUNCTIONS                                                                │
# └──────────────────────────────────────────────────────────────────────────────┘

# _clean_orphan — Hapus paket orphan, tapi jangan panggil paru tanpa argumen
_clean_orphan() {
  emulate -L zsh
  local -a orphans=(${(f)"$(paru -Qdtq 2>/dev/null)"})
  orphans=(${orphans:#})
  (( $#orphans )) || { print "✅ Tidak ada paket orphan."; return 0 }
  print "🗑  ${#orphans} paket orphan:"
  print -l -- "  ${^orphans}"
  paru -Rns -- "${orphans[@]}"
}

# rmnoext — Hapus file tanpa ekstensi (interaktif, konfirmasi sekali)
#
# Sebelumnya fungsi ini tidak pernah berhasil menghapus apa pun: hasil `fd`
# ditampung sebagai satu string lalu `printf '%s\0'` mengirimnya sebagai SATU
# argumen NUL, dan `xargs -p` membaca konfirmasi dari pipe (bukan terminal)
# sehingga selalu gagal dengan "Failed to read from standard input".
rmnoext() {
  emulate -L zsh
  local -a files
  local f

  while IFS= read -r -d '' f; do
    files+=("$f")
  done < <(fd --type f --no-ignore-vcs \
    --exclude .git --exclude node_modules --exclude vendor \
    --print0 "^[^.]+$" 2>/dev/null)

  if (( ! $#files )); then
    print "✅ Tidak ada file tanpa ekstensi"
    return 0
  fi

  print "⚠️  ${#files} file tanpa ekstensi akan DIHAPUS:"
  print -l -- "  ${^files}"
  print ""
  print "   Catatan: Makefile / LICENSE / README / Dockerfile juga tidak"
  print "   berekstensi — periksa daftar di atas sebelum lanjut."

  local reply
  if read -q "reply?Hapus ${#files} file ini? [y/N] "; then
    print ""
    rm -v -- "${files[@]}"
  else
    print "\n❌ Dibatalkan."
    return 1
  fi
}

# mkcd — Buat folder dan langsung masuk
mkcd() {
  emulate -L zsh
  [[ -z "$1" ]] && { print -u2 "⚠️  Penggunaan: mkcd <directory>"; return 1 }
  mkdir -p -- "$1" || return 1
  cd -- "$1" || return 1
}

# compile — Compile & run C (binary ditaruh di ./bin)
compile() {
  emulate -L zsh
  [[ -z "$1" ]] && { print -u2 "Usage: compile <file.c> [args...]"; return 1 }
  (( $+commands[clang] )) || { print -u2 "clang not installed"; return 1 }

  local src="$1"
  shift

  [[ -f "$src" ]] || { print -u2 "File not found: $src"; return 1 }

  mkdir -p bin || return 1
  local out="bin/${src:t:r}"

  print "⚙️  compiling..."

  if clang -O2 -Wall -Wextra -std=c23 "$src" -o "$out"; then
    [[ -x "$out" ]] || { print -u2 "❌ Binary tidak executable"; return 1 }
    print "▶  running..."
    "$out" "$@"
    return $?
  else
    print -u2 "❌ compile failed"
    return 1
  fi
}

# ── Git helper ────────────────────────────────────────────────────────────────

# gac — Add + Commit
gac() {
  emulate -L zsh
  [[ -z "$1" ]] && { print -u2 '⚠️  Penggunaan: gac "pesan commit"'; return 1 }

  local branch
  branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
  [[ -z "$branch" ]] && { print -u2 "❌ Bukan repositori Git!"; return 1 }

  [[ -z "$(git status --porcelain)" ]] && { print "⚠️  Tidak ada perubahan."; return 0 }

  print "📦 Commit ke branch: $branch"
  git add -A && git commit -m "$1" || return 1
}

# gacp — Add + Commit + Push
gacp() {
  emulate -L zsh
  [[ -z "$1" ]] && { print -u2 '⚠️  Penggunaan: gacp "pesan commit"'; return 1 }

  local branch
  branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
  [[ -z "$branch" ]] && { print -u2 "❌ Bukan repositori Git!"; return 1 }
  [[ "$branch" == "HEAD" ]] && { print -u2 "❌ HEAD detached. Checkout branch dulu."; return 1 }

  local remote_url
  remote_url=$(git remote get-url origin 2>/dev/null)
  if [[ "$remote_url" == https://* ]]; then
    print "⚠️  Repo masih menggunakan HTTPS:"
    print "   $remote_url"
    print "👉 Disarankan menggunakan SSH."
    print ""
  fi

  [[ -z "$(git status --porcelain)" ]] && { print "⚠️  Tidak ada perubahan."; return 0 }

  print "📦 Commit ke branch: $branch"
  git add -A && git commit -m "$1" || return 1

  if git ls-remote origin &>/dev/null; then
    git push -u origin "$branch" && print "🚀 Berhasil push ke $branch!" || { print -u2 "❌ Push gagal."; return 1 }
  else
    print "⚠️  Offline. Jalankan 'git push' saat online."
  fi
}

# gaacp — AI commit (butuh `aicommits`)
gaacp() {
  emulate -L zsh
  local branch
  branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
  [[ -z "$branch" ]] && { print -u2 "❌ Bukan repositori Git!"; return 1 }
  [[ "$branch" == "HEAD" ]] && { print -u2 "❌ HEAD detached. Checkout branch dulu."; return 1 }

  [[ -z "$(git status --porcelain)" ]] && { print "⚠️  Tidak ada perubahan."; return 1 }

  (( $+commands[aicommits] )) || {
    print -u2 "❌ 'aicommits' belum terinstall."
    print -u2 "👉 https://github.com/Nutlope/aicommits"
    return 1
  }

  print "📦 Membuat pesan commit dengan AI..."
  aicommits || return 1

  if git ls-remote origin &>/dev/null; then
    git push -u origin "$branch" && print "🚀 Berhasil push ke $branch!" || { print -u2 "❌ Push gagal."; return 1 }
  else
    print "⚠️  Offline. Jalankan 'git push' saat online."
  fi
}

# zpush — Commit & push ZSH-Config
zpush() {
  emulate -L zsh
  local repo="$HOME/ZSH-Config"

  [[ -d "$repo/.git" ]] || {
    print -u2 "❌ Repository tidak ditemukan: $repo"
    return 1
  }

  [[ -n "$(git -C "$repo" status --porcelain)" ]] || {
    print "⚠️  Tidak ada perubahan untuk di-commit."
    return 0
  }

  local branch
  branch=$(git -C "$repo" rev-parse --abbrev-ref HEAD 2>/dev/null)

  if [[ -z "$branch" || "$branch" == "HEAD" ]]; then
    print -u2 "❌ HEAD detached. Checkout branch dulu."
    return 1
  fi

  git -C "$repo" add -A || return 1

  if [[ -n "$1" ]]; then
    git -C "$repo" commit -m "$1" || return 1
  else
    (( $+commands[aicommits] )) || {
      print -u2 "❌ 'aicommits' belum terinstall (atau beri pesan commit manual)."
      return 1
    }
    print "🤖 Membuat commit dengan AI..."
    (cd "$repo" && aicommits) || return 1
  fi

  print "🌐 Mengecek koneksi ke remote..."
  git -C "$repo" ls-remote origin &>/dev/null || {
    print -u2 "⚠️  Tidak dapat menghubungi remote."
    print -u2 "   Periksa koneksi internet, SSH key, atau URL remote."
    return 1
  }

  print "🚀 Push ke branch '$branch'..."
  git -C "$repo" push -u origin "$branch" || {
    print -u2 "❌ Push gagal."
    return 1
  }

  print "✅ ZSH-Config berhasil dipush!"
}

# githack — Convert GitHub URL -> raw.githack.com
githack() {
  emulate -L zsh
  [[ -z "$1" ]] && { print -u2 "⚠️  Penggunaan: githack <github-url>"; return 1 }

  local url="$1" out=""

  case "$url" in
    *raw.githack.com*)
      out="$url"
      ;;
    *raw.githubusercontent.com*)
      if [[ "$url" =~ 'raw\.githubusercontent\.com/([^/]+)/([^/]+)/([^/]+)/(.*)' ]]; then
        out="https://raw.githack.com/${match[1]}/${match[2]}/${match[3]}/${match[4]}"
      fi
      ;;
    *github.com*/blob/*)
      if [[ "$url" =~ 'github\.com/([^/]+)/([^/]+)/blob/([^/]+)/(.*)' ]]; then
        out="https://raw.githack.com/${match[1]}/${match[2]}/${match[3]}/${match[4]}"
      fi
      ;;
    *)
      print -u2 "❌ URL GitHub tidak valid"
      return 1
      ;;
  esac

  [[ -z "$out" ]] && { print -u2 "❌ URL tidak valid atau format tidak dikenal"; return 1 }

  print "🌐 $out"

  # `wl-copy -selection clipboard` SALAH: wl-copy tidak punya --selection,
  # `-s` artinya --seat, jadi perintahnya gagal ("No such seat: election")
  # sementara pesan sukses tetap tercetak. wl-copy default = clipboard.
  #
  # Redirect stdout/stderr wajib: wl-copy fork ke background untuk melayani
  # permintaan paste dan mewarisi stdout, sehingga `$(githack ...)` menggantung
  # menunggu pipe ditutup.
  if (( $+commands[wl-copy] )); then
    if print -rn -- "$out" | wl-copy >/dev/null 2>&1; then
      print "📋 Disalin ke clipboard!"
    else
      print -u2 "⚠️  Gagal menyalin ke clipboard."
    fi
  fi
}

# bench — Benchmark command
#
# Versi lama memakai `2> >(awk ...)`: stderr milik command yang diukur ikut
# tertelan awk, dan saat command gagal GNU time menambah baris "Command exited
# with non-zero status N" sehingga laporan tercetak DUA KALI. Sekarang timing
# ditulis ke file terpisah (--quiet -o) agar stderr command lewat apa adanya.
bench() {
  emulate -L zsh
  (( $# )) || { print -u2 "bench: usage: bench <command> [args...]"; return 2 }

  local timer=${commands[gtime]:-${commands[time]}}
  [[ -n $timer ]] || {
    print -u2 "bench: GNU time (gtime/time) tidak ditemukan"
    return 127
  }

  local tmp="${TMPDIR:-/tmp}/bench.$$.$RANDOM"
  "$timer" --quiet -o "$tmp" -f '%e %U %S' "$@"
  local rc=$?

  if [[ -s $tmp ]]; then
    awk '{
      real = $1 * 1000
      user = $2 * 1000
      sys  = $3 * 1000
      cpu  = user + sys
      pct  = (real > 0) ? cpu / real * 100 : 0

      printf "\n"
      printf "⏱  Real : %9.3f ms\n", real
      printf "🧠 User : %9.3f ms\n", user
      printf "⚙  Sys  : %9.3f ms\n", sys
      printf "🔥 CPU  : %9.3f ms (%5.1f%%)\n", cpu, pct
    }' "$tmp"
  fi

  rm -f -- "$tmp"
  return $rc
}

# ┌──────────────────────────────────────────────────────────────────────────────┐
# │ 🪝 HOOKS                                                                     │
# └──────────────────────────────────────────────────────────────────────────────┘

autoload -Uz add-zsh-hook
zmodload zsh/datetime   # EPOCHSECONDS, tanpa fork ke date(1)

# Auto ls saat pindah folder
do-ls() {
  emulate -L zsh
  command eza --icons --group-directories-first --color=auto -I "$EZA_IGNORE"
}
add-zsh-hook chpwd do-ls

# ── Notifikasi command panjang ────────────────────────────────────────────────

# Dispatcher: kitten notify hanya berfungsi di dalam kitty. Di terminal lain
# (Rio, konsole, dsb.) perintahnya gagal tanpa jejak, jadi fallback ke
# notify-send. Semua argumen di-quote — versi lama memakai `-a $window_info`
# tanpa quote sehingga saat variabelnya kosong, `-a` malah menelan judul
# notifikasi dan body bergeser jadi judul.
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

  # Jangan kirim notifikasi "Gagal" untuk Ctrl+C
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

# Catatan: zsh mengembalikan nilai $? sebelum SETIAP precmd hook dipanggil,
# jadi _notify_precmd tetap melihat exit code command user walaupun ia berjalan
# setelah hook starship/atuin (sudah diverifikasi lewat tes pty).
add-zsh-hook preexec _notify_preexec
add-zsh-hook precmd _notify_precmd

# ┌──────────────────────────────────────────────────────────────────────────────┐
# │ 🔧 INISIALISASI TOOL                                                         │
# └──────────────────────────────────────────────────────────────────────────────┘

# fnm
(( $+commands[fnm] )) && eval "$(fnm env --use-on-cd --shell zsh)"

# zoxide (replace cd tanpa merusak completion)
(( $+commands[zoxide] )) && eval "$(zoxide init zsh --cmd cd)"

# Bun completion
[[ -s "$HOME/.bun/_bun" ]] && source "$HOME/.bun/_bun"

# broot (fungsi `br`)
[[ -r "$HOME/.config/broot/launcher/bash/br" ]] && source "$HOME/.config/broot/launcher/bash/br"

# OpenClaw completion
[[ -r "$HOME/.openclaw/completions/openclaw.zsh" ]] && source "$HOME/.openclaw/completions/openclaw.zsh"

# opencode completion (yargs)
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

# ┌──────────────────────────────────────────────────────────────────────────────┐
# │ 🔌 PLUGINS                                                                   │
# └──────────────────────────────────────────────────────────────────────────────┘

# pkgfile "command not found"
source /usr/share/doc/pkgfile/command-not-found.zsh

# fzf: keybindings (Ctrl-T / Ctrl-R / Alt-C) + completion (**<TAB>)
source /usr/share/fzf/key-bindings.zsh
[[ -r /usr/share/fzf/completion.zsh ]] && source /usr/share/fzf/completion.zsh

# Plugin order: autosuggestions → syntax-highlighting → history-substring-search
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
# zsh-patina (di bawah) sudah menangani highlighting, jadi ini dimatikan
# source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
# source /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh

# ┌──────────────────────────────────────────────────────────────────────────────┐
# │ 🚀 PROMPT & HISTORY SEARCH                                                   │
# └──────────────────────────────────────────────────────────────────────────────┘

eval "$(starship init zsh)"

# atuin mengambil alih ^R dan panah atas
[[ -r "$HOME/.atuin/bin/env" ]] && source "$HOME/.atuin/bin/env"
(( $+commands[atuin] )) && eval "$(atuin init zsh)"

# zsh-patina (syntax highlighting)
(( $+commands[zsh-patina] )) && eval "$(zsh-patina activate)"
