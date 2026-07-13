# ⚡ ZSH Configuration for CachyOS

> ✨ *Transform your CachyOS terminal into a productivity powerhouse.*

Custom **`.zshrc`** configuration for developers who want a terminal that's:

* ⚡ **Blazing fast** with optimized loading
* 🎯 **Minimal yet powerful** — essential tools only
* 🔒 **Secure** with proper validation and error handling
* 🧠 **Smart** with auto-detection and intelligent defaults
* 🎨 **Beautiful** leveraging CachyOS's native theming

Built on top of **CachyOS's system-wide config**, enhanced with **FNM**, **Bun**, **Zoxide**, **Eza**, **Atuin**, and powerful custom functions.

---

## 🎯 Philosophy

This configuration **extends** CachyOS's excellent base setup (`cachyos-config.zsh`) rather than replacing it. You get:

- ✅ CachyOS's optimized ZSH configuration
- ✅ Beautiful theme and prompt via Starship
- ✅ Essential plugins (git, fzf, extract, autosuggestions, syntax-highlighting, history-substring-search)
- ✅ Custom aliases and functions for development
- ✅ Smart history with deduplication and cross-session sync
- ✅ Modern CLI tool integrations

---

## 📦 What's Included

### 🔌 Plugins
- **git** — Git shortcuts and intelligent status
- **fzf** — Fuzzy finder (`Ctrl+R` history, `Ctrl+T` files)
- **extract** — Universal archive extraction with `x`
- **zsh-autosuggestions** — Fish-like autosuggestions from history
- **zsh-syntax-highlighting** — Command syntax coloring
- **zsh-history-substring-search** — History search with arrow keys
- **pkgfile** — "Command not found" handler for Arch

### 🛠️ Modern CLI Tools
- **eza** — Modern `ls` replacement with icons and git integration
- **zoxide** — Smart directory jumper (`z` command, replaces `cd`)
- **fnm** — Fast Node.js version manager
- **bun** — Fast JavaScript runtime (optional)
- **atuin** — Magical shell history with sync and search
- **starship** — Cross-shell prompt

### ⚡ Custom Features
- **C programming** helpers with Clang C23 integration
- **Git workflow** shortcuts with SSH validation and offline detection
- **AI commit messages** via `aicommits` integration (optional)
- **Smart history** — 10,000 entries, synced across terminals, deduplicated
- **Utility functions** with validation and error handling

---

## 🚀 Prerequisites

### Required (Core System)
```bash
# CachyOS already provides these:
# - ZSH
# - cachyos-zsh-config
# - Starship prompt
```

### Required (Modern CLI Tools)
```bash
sudo pacman -S eza zoxide fzf clang fd micro atuin
```

### Optional (Development Tools)
```bash
# Fast Node Manager
curl -fsSL https://fnm.vercel.app/install | bash

# Bun runtime
curl -fsSL https://bun.sh/install | bash

# AI commit messages (used by gaacp and zpush)
npm install -g aicommits

# Clipboard support for githack
sudo pacman -S xclip

```

---

## 🎨 Features & Usage

### 📁 File Navigation & Management

#### Enhanced Directory Listing (Eza)
```bash
ls      # Listing with icons, directories first
ll      # Detailed view with file sizes and git status
la      # Show hidden files
lt      # Tree view (2 levels deep)
lta     # Tree view including hidden files
```

#### Quick Navigation
```bash
..      # Go up one directory
-       # Jump to previous directory

mkcd myapp    # Create directory and cd into it
```

> **Note:** `cd` is aliased to `z` (zoxide) when zoxide is installed. Zoxide learns your habits and lets you jump to frequent directories by partial name. Falls back to standard `cd` if zoxide is not available.


### 💻 Development Workflow

#### C Programming
```bash
# Compile and run in one command
compile program.c
compile calculator.c 5 10    # With arguments
```

**Features:**
- ✅ Clang availability check with install hint
- ✅ Full compiler warnings (`-Wall -Wextra`)
- ✅ C23 standard with optimization (`-O2`)
- ✅ Output placed in `./bin/`
- ✅ Cleanup on interrupt (Ctrl+C)

#### Git Shortcuts
```bash
ga      # git add .
gs      # git status (short format with branch)
gl      # git log (last 15 commits, one line each)
gd      # git diff
```

#### Git Workflow Functions

**Quick commit only:**
```bash
gac "feat: add user authentication"
# 1. git add .
# 2. git commit -m "..."
```

**Quick commit & push:**
```bash
gacp "feat: add user authentication"
# 1. Validates: not empty, is git repo, has changes
# 2. Warns if using HTTPS instead of SSH
# 3. git add .
# 4. git commit -m "..."
# 5. git push (only if online)
```

**AI-generated commit message:**
```bash
gaacp
# 1. Validates: is git repo, has changes, aicommits installed
# 2. aicommits (generates commit message + add + commit)
# 3. git push (only if online)
# Requires: npm install -g aicommits
```

**Backup your .zshrc:**
```bash
zpush "update: added new aliases"    # Manual message
zpush                                # AI-generated message (requires aicommits)
# 1. Validates: repo exists, has changes, not detached HEAD
# 2. git add .
# 3. git commit (manual or AI)
# 4. Checks remote connectivity
# 5. git push to origin
```

**Safety features in git functions:**
- ✅ HTTPS vs SSH detection
- ✅ Offline detection before push
- ✅ Empty changes detection
- ✅ Detached HEAD detection (zpush)
- ✅ Explicit error messages

### 🛠️ Utilities

#### Remove Files Without Extension
```bash
rmnoext
# Scans current directory for files without extension
# Shows the list, asks for confirmation before deleting
# Excludes: .git, node_modules, vendor
# Shows "✅ Tidak ada file tanpa ekstensi" if none found
```

#### GitHub URL Converter
```zsh
githack https://github.com/user/repo/blob/main/index.html
# 🌐 https://raw.githack.com/user/repo/main/index.html
# 📋 Copied to clipboard! (if xclip is installed)

# Also works with raw.githubusercontent.com URLs
```

#### Benchmarking
```bash
bench npm run build        # Measure execution time
bench ./my-script.sh
```

### ⚙️ System & Pacman

```bash
update      # sudo pacman -Syu (full system update)
cleanup     # Remove orphaned packages
f           # Open Fresh editor
wl          # Paste from clipboard (wl-copy <)
```

### ⚙️ Configuration

```bash
zconfig     # Open ~/ZSH-Config/ in VS Code
zreload     # Reload ZSH configuration (exec zsh)
zhelp       # Show command reference
q           # Exit terminal
```

---

## 🎯 Custom Functions Reference

| Function | Usage | Description |
|----------|-------|-------------|
| `mkcd` | `mkcd project` | Create directory and cd into it |
| `compile` | `compile file.c [args]` | Compile and run C program with Clang C23 |
| `gac` | `gac "message"` | Git add and commit only |
| `gacp` | `gacp "message"` | Git add, commit, and push with validation |
| `gaacp` | `gaacp` | AI-generated commit message + push |
| `zpush` | `zpush ["message"]` | Backup .zshrc to repo with detached HEAD check |
| `githack` | `githack <url>` | Convert GitHub URL to CDN link |
| `rmnoext` | `rmnoext` | Delete files without extension (with confirmation) |
| `bench` | `bench command` | Benchmark execution time |
| `zhelp` | `zhelp` | Show all custom commands |

---

## 🔌 Complete Alias Reference

### Listing & Navigation
| Alias | Command | Description |
|-------|---------|-------------|
| `ls` | `_eza` | Icons, directories first |
| `ll` | `_eza -lh --git` | Detailed with git status |
| `la` | `_eza -la --git` | Show hidden files |
| `lt` | `_eza -T --level=2` | Tree view (2 levels) |
| `lta` | `_eza -Ta --level=2` | Tree view with hidden |
| `..` | `cd ..` | Go up one directory |
| `-` | `cd -` | Previous directory |


### System
| Alias | Command | Description |
|-------|---------|-------------|
| `c` | `clear` | Clear terminal |
| `q` | `exit` | Exit shell |
| `update` | `sudo pacman -Syu` | System update |
| `cleanup` | `sudo pacman -Rsn $(pacman -Qtdq)` | Remove orphans |
| `wl` | `wl-copy <` | Wayland clipboard |
| `f` | `fresh` | Fresh editor |

---

## ⚙️ Shell Options

This config sets the following ZSH options on top of the CachyOS defaults:

### History
| Option | Effect |
|--------|--------|
| `HISTSIZE=10000` | Keep 10,000 commands in memory per session |
| `SAVEHIST=10000` | Persist 10,000 commands to `~/.zsh_history` |
| `EXTENDED_HISTORY` | Write history in `:start:elapsed;command` format |
| `SHARE_HISTORY` | Sync history across all open terminals in realtime |
| `HIST_IGNORE_ALL_DUPS` | Remove old duplicate entries when a command is re-run |
| `HIST_IGNORE_SPACE` | Don't record commands starting with space |
| `HIST_FIND_NO_DUPS` | Skip duplicates when searching history with `Ctrl+R` |
| `HIST_SAVE_NO_DUPS` | Don't write duplicate commands to history file |
| `HIST_EXPIRE_DUPS_FIRST` | Expire duplicates first when trimming history |
| `HIST_VERIFY` | Show history expansion before executing |

### Navigation
| Option | Effect |
|--------|--------|
| `AUTO_CD` | Type a directory name to cd into it without typing `cd` |
| `AUTO_PUSHD` | `cd` automatically pushes the old directory to the stack |
| `PUSHD_IGNORE_DUPS` | Don't push duplicate directories to the stack |

### Completion
| Option | Effect |
|--------|--------|
| `AUTO_MENU` | Show completion menu on first Tab press |
| `MENU_COMPLETE` | Auto-insert first match on Tab |

### General
| Option | Effect |
|--------|--------|
| `CORRECT` | Suggest typo corrections for mistyped commands |
| `INTERACTIVE_COMMENTS` | Allow `#` comments in interactive shell |

---

## 🔌 Plugin Loading Order

```
1. cachyos-config.zsh          # CachyOS base config
2. pkgfile (command-not-found) # "Command not found" handler
3. fzf keybindings             # Ctrl+R, Ctrl+T, Alt+C
4. zsh-autosuggestions         # Fish-like suggestions
5. zsh-syntax-highlighting     # Command coloring (MUST be after autosuggestions)
6. zsh-history-substring-search # History search (MUST be last)
```

> ⚠️ Plugin order matters! Syntax highlighting must load after autosuggestions, and history-substring-search must be last.

---

## 🌍 Environment & PATH

### PATH Entries
```
$JAVA_HOME/bin
$HOME/bin
$HOME/.local/bin
$HOME/.local/share/fnm
$HOME/.cargo/bin
$HOME/.bun/bin
$HOME/go/bin
$HOME/.config/herd-lite/bin
```

### Environment Variables
| Variable | Value | Purpose |
|----------|-------|---------|
| `MICRO_TRUECOLOR` | `1` | Enable true color in Micro editor |
| `BAT_THEME` | `Catppuccin Mocha` | Theme for bat |
| `PHP_INI_SCAN_DIR` | herd-lite path | PHP configuration |
| `DOCKER_HOST` | podman socket | Podman compatibility |

> Uses `typeset -U path` to prevent duplicate PATH entries automatically.

---

---

## 🔧 Customization

### Adding Custom Aliases
```bash
zconfig     # Open ~/ZSH-Config/ in VS Code

# Add in the ALIASES section:
alias myalias='command here'

zreload     # Apply changes
```

### Adding Custom Functions
```bash
# Add in the FUNCTIONS section:
myfunction() {
  emulate -L zsh
  # Your code here
}
```

---

## 🐛 Troubleshooting

### Commands Not Found

| Issue | Solution |
|-------|----------|
| `eza: command not found` | `sudo pacman -S eza` |
| `zoxide: command not found` | `sudo pacman -S zoxide` |
| `fd: command not found` | `sudo pacman -S fd` |
| `fnm: command not found` | `curl -fsSL https://fnm.vercel.app/install \| bash` |
| `clang: command not found` | `sudo pacman -S clang` |
| `aicommits: command not found` | `npm install -g aicommits` |
| `xclip: command not found` | `sudo pacman -S xclip` |
| `atuin: command not found` | `sudo pacman -S atuin` |

---

## 💡 Tips & Tricks

### Using Zoxide
```bash
# After visiting directories a few times:
z docs      # Jump to ~/Documents
z proj      # Jump to ~/Projects/my-project

# cd is aliased to z when available, so just use cd normally
```

### FZF Power Features
```bash
Ctrl+R      # Fuzzy search command history
Ctrl+T      # Fuzzy file finder
Alt+C       # Fuzzy directory finder
```

### History Search
With `SHARE_HISTORY` and `HIST_IGNORE_ALL_DUPS` active, `Ctrl+R` across multiple terminals shares a single clean history — no duplicates, no stale entries.

### Offline Git Workflow
`gacp` and `gaacp` check connectivity before pushing:
```bash
gacp "wip: working on feature"
# If offline: commits locally, reminds you to push later
# If online: commits and pushes in one shot
```

### Atuin History
Atuin replaces your shell history with a SQLite database:
```bash
# Search history with Up arrow (configured by atuin init)
# Sync across machines with atuin account
```

---

## 🎓 Learning Resources

- [ZSH Documentation](http://zsh.sourceforge.net/Doc/)
- [CachyOS Wiki](https://wiki.cachyos.org/)
- [Eza GitHub](https://github.com/eza-community/eza)
- [Zoxide GitHub](https://github.com/ajeetdsouza/zoxide)
- [FZF Documentation](https://github.com/junegunn/fzf)
- [FNM Documentation](https://github.com/Schniz/fnm)
- [Starship Prompt](https://starship.rs/)
- [Atuin GitHub](https://github.com/atuinsh/atuin)
- [Aicommits GitHub](https://github.com/Nutlope/aicommits)

---

---

## 🙏 Acknowledgments

- **CachyOS Team** — For the excellent base ZSH configuration
- **Oh-My-Zsh Community** — For the plugin ecosystem
- **Eza / Zoxide / FNM / Atuin Authors** — For modern CLI tools
- **Starship** — For the beautiful cross-shell prompt

---

## 📄 License

MIT License — Feel free to use, modify, and distribute.

---

## 🧑‍💻 Author

**Ryoukaii**
🐧 CachyOS Enthusiast • ⚡ Performance Optimizer • 🛠️ Fullstack Developer

> *"A well-configured terminal is a developer's best friend. Keep it fast, clean, and powerful."*

---
