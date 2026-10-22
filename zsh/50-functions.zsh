# Custom functions.
t() {
  /usr/bin/zsh -lic '
    cd "$1" || exit 1
    exec /usr/bin/kitty --directory "$1" /usr/bin/terax .
  ' _ "$PWD"
}

_clean_orphan() {
  emulate -L zsh
  local -a orphans=(${(f)"$(paru -Qdtq 2>/dev/null)"})
  orphans=(${orphans:#})
  (( $#orphans )) || { print "✅ Tidak ada paket orphan."; return 0 }
  print "🗑  ${#orphans} paket orphan:"
  print -l -- "  ${^orphans}"
  paru -Rns -- "${orphans[@]}"
}

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

mkcd() {
  emulate -L zsh
  [[ -z "$1" ]] && { print -u2 "⚠️  Penggunaan: mkcd <directory>"; return 1 }
  mkdir -p -- "$1" || return 1
  cd -- "$1" || return 1
}

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

zpush() {
  emulate -L zsh
  local repo="$HOME/ZSH-Config"
  [[ -d "$repo/.git" ]] || { print -u2 "❌ Repository tidak ditemukan: $repo"; return 1 }
  [[ -n "$(git -C "$repo" status --porcelain)" ]] || { print "⚠️  Tidak ada perubahan untuk di-commit."; return 0 }
  local branch
  branch=$(git -C "$repo" rev-parse --abbrev-ref HEAD 2>/dev/null)
  [[ -n "$branch" && "$branch" != "HEAD" ]] || { print -u2 "❌ HEAD detached. Checkout branch dulu."; return 1 }
  git -C "$repo" add -A || return 1
  if [[ -n "$1" ]]; then
    git -C "$repo" commit -m "$1" || return 1
  else
    (( $+commands[aicommits] )) || { print -u2 "❌ 'aicommits' belum terinstall (atau beri pesan commit manual)."; return 1 }
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
  git -C "$repo" push -u origin "$branch" || { print -u2 "❌ Push gagal."; return 1 }
  print "✅ ZSH-Config berhasil dipush!"
}

githack() {
  emulate -L zsh
  [[ -z "$1" ]] && { print -u2 "⚠️  Penggunaan: githack <github-url>"; return 1 }
  local url="$1" out=""
  case "$url" in
    *raw.githack.com*) out="$url" ;;
    *raw.githubusercontent.com*)
      [[ "$url" =~ 'raw\.githubusercontent\.com/([^/]+)/([^/]+)/([^/]+)/(.*)' ]] && out="https://raw.githack.com/${match[1]}/${match[2]}/${match[3]}/${match[4]}" ;;
    *github.com*/blob/*)
      [[ "$url" =~ 'github\.com/([^/]+)/([^/]+)/blob/([^/]+)/(.*)' ]] && out="https://raw.githack.com/${match[1]}/${match[2]}/${match[3]}/${match[4]}" ;;
    *) print -u2 "❌ URL GitHub tidak valid"; return 1 ;;
  esac
  [[ -z "$out" ]] && { print -u2 "❌ URL tidak valid atau format tidak dikenal"; return 1 }
  print "🌐 $out"
  if (( $+commands[wl-copy] )); then
    if print -rn -- "$out" | wl-copy >/dev/null 2>&1; then
      print "📋 Disalin ke clipboard!"
    else
      print -u2 "⚠️  Gagal menyalin ke clipboard."
    fi
  fi
}

bench() {
  emulate -L zsh
  (( $# )) || { print -u2 "bench: usage: bench <command> [args...]"; return 2 }
  local timer=${commands[gtime]:-${commands[time]}}
  [[ -n $timer ]] || { print -u2 "bench: GNU time (gtime/time) tidak ditemukan"; return 127 }
  local tmp="${TMPDIR:-/tmp}/bench.$$.$RANDOM"
  "$timer" --quiet -o "$tmp" -f '%e %U %S' "$@"
  local rc=$?
  if [[ -s $tmp ]]; then
    awk '{ real=$1*1000; user=$2*1000; sys=$3*1000; cpu=user+sys; pct=(real>0) ? cpu/real*100 : 0; printf "\n⏱  Real : %9.3f ms\n",real; printf "🧠 User : %9.3f ms\n",user; printf "⚙  Sys  : %9.3f ms\n",sys; printf "🔥 CPU  : %9.3f ms (%5.1f%%)\n",cpu,pct }' "$tmp"
  fi
  rm -f -- "$tmp"
  return $rc
}
