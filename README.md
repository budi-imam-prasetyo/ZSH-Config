# ⚡ ZSH Configuration for CachyOS

> ✨ *Transform your CachyOS terminal into a productivity powerhouse.*

Custom **`.zshrc`** configuration for developers who want a terminal that's:

* ⚡ **Blazing fast** with optimized loading
* 🎯 **Minimal yet powerful** — essential tools only
* 🔒 **Secure** with proper validation and error handling
* 🧠 **Smart** with auto-detection and intelligent defaults
* 🎨 **Beautiful** leveraging CachyOS's native theming

Built on top of **CachyOS's system-wide config**, enhanced with **FNM**, **Bun**, **Zoxide**, **Eza**, and powerful custom functions.

---

## 🎯 Philosophy

This configuration **extends** CachyOS's excellent base setup (`cachyos-config.zsh`) rather than replacing it. You get:

- ✅ CachyOS's optimized ZSH configuration
- ✅ Beautiful theme and prompt via Starship
- ✅ Essential plugins (git, fzf, extract)
- ✅ Custom aliases and functions for development
- ✅ Smart history with deduplication and cross-session sync
- ✅ Modern CLI tool integrations

---

## 📦 What's Included

### 🔌 Plugins
- **git** — Git shortcuts and intelligent status
- **fzf** — Fuzzy finder (`Ctrl+R` history, `Ctrl+T` files)
- **extract** — Universal archive extraction with `x`

### 🛠️ Modern CLI Tools
- **eza** — Modern `ls` replacement with icons and git integration
- **zoxide** — Smart directory jumper (`z` command, replaces `cd`)
- **fnm** — Fast Node.js version manager
- **bun** — Fast JavaScript runtime (optional)

### ⚡ Custom Features
- **C programming** helpers with Clang integration
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
sudo pacman -S eza zoxide fzf clang fd micro
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

# Yazi terminal file manager
sudo pacman -S yazi
```

---

## 📥 Installation

### Method 1: Quick Install (Recommended)
```bash
# Backup existing .zshrc
[ -f ~/.zshrc ] && cp ~/.zshrc ~/.zshrc.backup

# Download the configuration
curl -fsSL https://raw.githubusercontent.com/YOUR_USERNAME/ZSH-Config/main/.zshrc -o ~/.zshrc

# Reload your shell
exec zsh
```

### Method 2: Manual Install
```bash
# Clone the repository
git clone https://github.com/YOUR_USERNAME/ZSH-Config.git ~/ZSH-Config

# Backup existing config
[ -f ~/.zshrc ] && mv ~/.zshrc ~/.zshrc.backup

# Create symlink (easier to update)
ln -sf ~/ZSH-Config/.zshrc ~/.zshrc

# Reload shell
exec zsh
```

### Post-Installation
```bash
# Test that everything works
zhelp
# If you see the help menu, you're all set! 🎉
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

#### Yazi File Manager
```bash
y       # Open Yazi; cd into the directory you quit from
```

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
- ✅ C99 standard with debug symbols (`-g`)
- ✅ Output placed in `./bin/`

#### Git Shortcuts
```bash
ga      # git add .
gs      # git status (short format with branch)
gl      # git log (last 15 commits, one line each)
gd      # git diff
```

#### Git Workflow Functions

**Quick commit & push:**
```bash
gacp "feat: add user authentication"
# 1. git add .
# 2. git commit -m "..."
# 3. git push (only if online, checked via curl)
```

**AI-generated commit message:**
```bash
gaacp
# 1. git add .
# 2. aicommits  (generates commit message)
# 3. git push (only if online)
# Requires: npm install -g aicommits
```

**Backup your .zshrc:**
```bash
zpush "update: added new aliases"    # Manual message
zpush                                # AI-generated message (requires aicommits)
# Copies ~/.zshrc → ~/ZSH-Config/ and pushes to remote
```

Both `gacp` and `gaacp` will warn you if the remote is using HTTPS instead of SSH.

### 🛠️ Utilities

#### Remove Files Without Extension
```bash
rmnoext
# Scans current directory for files without extension
# Shows the list, asks for confirmation before deleting
# Excludes: .git, node_modules, vendor
```

#### GitHub URL Converter
```bash
githack https://github.com/user/repo/blob/main/script.js
# 🌐 https://raw.githack.com/user/repo/main/script.js
# 📋 Copied to clipboard! (if xclip is installed)

# Also works with raw.githubusercontent.com URLs
```

#### Benchmarking
```bash
bench npm run build        # Measure execution time in milliseconds
bench ./my-script.sh
```

### ⚙️ Configuration

```bash
zconfig     # Open ~/config/ in VS Code
zreload     # Reload ZSH configuration (exec zsh)
zhelp       # Show command reference
q           # Exit terminal
```

---

## 🎯 Custom Functions Reference

| Function | Usage | Description |
|----------|-------|-------------|
| `mkcd` | `mkcd project` | Create directory and cd into it |
| `compile` | `compile file.c [args]` | Compile and run C program with Clang |
| `gacp` | `gacp "message"` | Git add, commit, and push |
| `gaacp` | `gaacp` | Same as gacp with AI-generated commit message |
| `zpush` | `zpush ["message"]` | Backup .zshrc to repo |
| `githack` | `githack <url>` | Convert GitHub URL to CDN link |
| `rmnoext` | `rmnoext` | Delete files without extension (with confirmation) |
| `bench` | `bench command` | Benchmark execution time |
| `y` | `y` | Open Yazi, cd on exit |

---

## ⚙️ Shell Options

This config sets the following ZSH options on top of the CachyOS defaults:

| Option | Effect |
|--------|--------|
| `HISTSIZE=10000` | Keep 10,000 commands in memory per session |
| `SAVEHIST=10000` | Persist 10,000 commands to `~/.zsh_history` |
| `SHARE_HISTORY` | Sync history across all open terminals in realtime |
| `HIST_IGNORE_ALL_DUPS` | Remove old duplicate entries when a command is re-run |
| `HIST_FIND_NO_DUPS` | Skip duplicates when searching history with `Ctrl+R` |
| `AUTO_CD` | Type a directory name to cd into it without typing `cd` |
| `AUTO_PUSHD` | `cd` automatically pushes the old directory to the stack |
| `PUSHD_IGNORE_DUPS` | Don't push duplicate directories to the stack |
| `CORRECT` | Suggest typo corrections for mistyped commands |
| `INTERACTIVE_COMMENTS` | Allow `#` comments in interactive shell |

---

## 🗂️ File Structure

```
~/
├── .zshrc                    # Your configuration (this file)
└── ZSH-Config/               # Backup repository
    └── .zshrc

# CachyOS System Files (don't modify):
/usr/share/cachyos-zsh-config/
└── cachyos-config.zsh        # Base configuration
```

---

## 🔧 Customization

### Adding Custom Aliases
```bash
zconfig     # Open ~/config/ in VS Code

# Add in the ALIASES section:
alias myalias='command here'

zreload     # Apply changes
```

### Adding Custom Functions
```bash
# Add in the FUNCTIONS section:
myfunction() {
  echo "Hello from my function!"
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
| `xclip: command not found` | `sudo pacman -S xclip` (optional, for clipboard) |
| `yazi: command not found` | `sudo pacman -S yazi` |

### Git Functions Not Working

```bash
# View current config
git config --list | grep user

# Ensure SSH keys are set up
ls -la ~/.ssh
ssh -T git@github.com
```

### Slow Shell Startup

Check which tools are actually installed:
```bash
command -v fnm zoxide eza bun yazi
```

Comment out unused initializations in `.zshrc`. All tool inits are guarded — they only load if the binary exists.

### PATH Issues

The config uses `typeset -U path` to prevent duplicates automatically. If issues persist:
```bash
echo $PATH | tr ':' '\n'    # Inspect current PATH
exec zsh                    # Reset and reload
```

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

---

## 🎓 Learning Resources

- [ZSH Documentation](http://zsh.sourceforge.net/Doc/)
- [CachyOS Wiki](https://wiki.cachyos.org/)
- [Eza GitHub](https://github.com/eza-community/eza)
- [Zoxide GitHub](https://github.com/ajeetdsouza/zoxide)
- [FZF Documentation](https://github.com/junegunn/fzf)
- [FNM Documentation](https://github.com/Schniz/fnm)
- [Yazi GitHub](https://github.com/sxyazi/yazi)
- [Starship Prompt](https://starship.rs/)

---

## 📋 Changelog

### Version 2.0.0
- ✅ Smart history: `HISTSIZE`/`SAVEHIST` set to 10,000
- ✅ Added `SHARE_HISTORY`, `HIST_IGNORE_ALL_DUPS`, `HIST_FIND_NO_DUPS`
- ✅ Zoxide alias guard — falls back to native `cd` if not installed
- ✅ Unified connectivity check to `curl` (was mixed `ping`/`curl`)
- ✅ Added Yazi integration (`y` function)
- ✅ `zconfig` now opens `~/config/` directory
- ✅ Removed: multi-account Git system (`init-repo`, `use-git`, `GIT_ACCOUNTS`)
- ✅ Removed: `note`, `fkill`, `debug-compile`, `myip`, `weather`, `ports`, `diskspace`, `meminfo`
- ✅ Cleaned up `zhelp` to match actual available commands

### Version 1.1.0
- ✅ Added `gaacp` — AI-powered commit + push
- ✅ Added `rmnoext` — delete files without extension
- ✅ Indonesian comments throughout `.zshrc`

### Version 1.0.0
- ✨ Initial release
- ✅ C programming helpers
- ✅ Modern CLI integrations
- ✅ Smart error handling

---

## 🙏 Acknowledgments

- **CachyOS Team** — For the excellent base ZSH configuration
- **Oh-My-Zsh Community** — For the plugin ecosystem
- **Eza / Zoxide / FNM / Yazi Authors** — For modern CLI tools
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

<div align="center">

### ⭐ If this helped you, consider starring the repo!

**Made with ❤️ for the CachyOS community**

[Report Bug](https://github.com/YOUR_USERNAME/ZSH-Config/issues) • [Request Feature](https://github.com/YOUR_USERNAME/ZSH-Config/issues)

</div>