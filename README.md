# ⚡ ZSH Configuration for CachyOS

> ✨ *Transform your CachyOS terminal into a productivity powerhouse.*

Custom **`.zshrc`** configuration for developers who want a terminal that's:

* ⚡ **Blazing fast** with optimized loading
* 🎯 **Minimal yet powerful** - essential tools only
* 🔒 **Secure** with proper validation and error handling
* 🧠 **Smart** with auto-detection and intelligent defaults
* 🎨 **Beautiful** leveraging CachyOS's native theming

Built on top of **CachyOS's system-wide config**, enhanced with **FNM**, **Bun**, **Zoxide**, **Eza**, and powerful custom functions.

---

## 🎯 Philosophy

This configuration **extends** CachyOS's excellent base setup (`cachyos-config.zsh`) rather than replacing it. You get:

- ✅ CachyOS's optimized ZSH configuration
- ✅ Beautiful theme and prompt (already configured)
- ✅ Essential plugins (git, fzf, extract)
- ✅ Custom aliases and functions for development
- ✅ Multi-account Git workflow helpers
- ✅ Modern CLI tool integrations

---

## 📦 What's Included

### 🔌 Plugins
- **git** - Git shortcuts and intelligent status
- **fzf** - Fuzzy finder (`Ctrl+R` history, `Ctrl+T` files)
- **extract** - Universal archive extraction

### 🛠️ Modern CLI Tools
- **eza** - Modern `ls` replacement with icons and git integration
- **zoxide** - Smart directory jumper (`z` command, replaces `cd`)
- **fnm** - Fast Node.js version manager
- **bun** - Fast JavaScript runtime (optional)

### ⚡ Custom Features
- **C programming** helpers with Clang integration
- **Multi-account Git** workflow (personal + kampus/work)
- **AI commit messages** via `aicommits` integration
- **Smart functions** with validation and error handling
- **Quick navigation** aliases and shortcuts
- **Utility functions** for common tasks

---

## 🚀 Prerequisites

### Required (Core System)
```bash
# CachyOS already provides these:
# - ZSH
# - cachyos-zsh-config
# - Basic completions
```

### Required (Modern CLI Tools)
```bash
sudo pacman -S eza zoxide fzf clang
```

### Optional (Development Tools)
```bash
# Fast Node Manager
curl -fsSL https://fnm.vercel.app/install | bash

# Bun runtime
curl -fsSL https://bun.sh/install | bash

# AI commit messages (used by gaacp and zpush)
npm install -g aicommits

# Additional tools
sudo pacman -S git base-devel gdb xclip
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
...     # Go up two directories
....    # Go up three directories
-       # Jump to previous directory

mkcd myapp    # Create directory and cd into it
```

> **Note:** `cd` is aliased to `zoxide` (`z`). Zoxide learns your habits and lets you jump to frequent directories by partial name.

### 💻 Development Workflow

#### C Programming
```bash
# Compile and run in one command
compile program.c
compile calculator.c 5 10    # With arguments

# Compile with debug symbols for GDB
debug-compile program.c
gdb ./program
```

**Features:**
- ✅ Automatic Clang installation check
- ✅ Full compiler warnings (`-Wall -Wextra`)
- ✅ C99 standard
- ✅ AddressSanitizer in debug builds

#### Git Multi-Account Workflow

**Setup your accounts** (edit `GIT_ACCOUNTS` in `.zshrc`):
```bash
typeset -A GIT_ACCOUNTS
GIT_ACCOUNTS=(
  [personal]="Your Name|personal@email.com|github.com-personal"
  [kampus]="Your Name|campus@email.com|github.com-kampus"
)
```

**Initialize new repository:**
```bash
init-repo personal     # For personal projects
init-repo kampus       # For campus/work projects
```

**Switch account in existing repo:**
```bash
use-git personal       # Switch to personal account
use-git kampus         # Switch to campus account
# Automatically updates remote URL if needed
```

**Quick commit & push:**
```bash
# Manual commit message
gacp "feat: add user authentication"
# 1. git add .  2. git commit -m  3. git push (only if online)

# AI-generated commit message (requires aicommits)
gaacp
# 1. git add .  2. aicommits  3. git push (only if online)
```

**Backup your .zshrc:**
```bash
zpush "update: added new aliases"    # Manual message
zpush                                # AI-generated message
# Syncs ~/.zshrc to ~/ZSH-Config repository
```

#### Standard Git Shortcuts
```bash
ga      # git add .
gs      # git status (short format with branch)
gl      # git log (last 15 commits, one line each)
gd      # git diff
```

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

#### Quick Notes System
```bash
note "Remember to update docs"    # Add timestamped note
note -l                           # List all notes
note                              # Open notes in editor
note -c                           # Clear all notes
```

Notes are stored in `~/.notes.md`.

#### Process Management
```bash
fkill     # Fuzzy search and kill process interactively
```

#### Benchmarking
```bash
bench npm run build        # Measure execution time
bench ./my-script.sh
```

### ℹ️ System Information

```bash
myip        # Show your public IP
weather     # Current weather (wttr.in)
ports       # List all open ports
diskspace   # Disk usage summary
meminfo     # Memory usage
```

### ⚙️ Configuration

```bash
zconfig     # Edit .zshrc in VS Code
zreload     # Reload ZSH configuration
zhelp       # Show comprehensive help menu
x / q       # Exit terminal
```

---

## 🎯 Custom Functions Reference

| Function | Usage | Description |
|----------|-------|-------------|
| `mkcd` | `mkcd project` | Create directory and cd into it |
| `extract` | `extract archive.zip` | Extract any archive format |
| `compile` | `compile file.c [args]` | Compile and run C program |
| `debug-compile` | `debug-compile file.c` | Compile with debug symbols |
| `gacp` | `gacp "message"` | Git add, commit, and push |
| `gaacp` | `gaacp` | Same as gacp with AI commit message |
| `init-repo` | `init-repo personal` | Initialize repo with account |
| `use-git` | `use-git kampus` | Switch Git account |
| `zpush` | `zpush ["message"]` | Backup .zshrc to repo |
| `githack` | `githack <url>` | Convert GitHub URL to CDN |
| `rmnoext` | `rmnoext` | Delete files without extension |
| `note` | `note "text"` | Quick note-taking |
| `bench` | `bench command` | Benchmark execution time |
| `fkill` | `fkill` | Fuzzy process killer |

---

## 🗂️ File Structure

```
~/
├── .zshrc                    # Your configuration (this file)
├── .notes.md                 # Quick notes storage
└── ZSH-Config/               # Backup repository (optional)
    └── .zshrc

# CachyOS System Files (don't modify):
/usr/share/cachyos-zsh-config/
└── cachyos-config.zsh        # Base configuration
```

---

## 🔧 Customization

### Adding Custom Aliases
```bash
zconfig     # Open .zshrc in VS Code

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
| `fnm: command not found` | `curl -fsSL https://fnm.vercel.app/install \| bash` |
| `clang: command not found` | `sudo pacman -S clang` |
| `aicommits: command not found` | `npm install -g aicommits` |
| `xclip: command not found` | `sudo pacman -S xclip` (optional, for clipboard) |

### Git Functions Not Working

```bash
# View current config
git config --list | grep user

# Ensure SSH keys are set up
ls -la ~/.ssh
```

**Set up SSH keys for multiple accounts:**
```bash
ssh-keygen -t ed25519 -C "personal@email.com" -f ~/.ssh/id_ed25519_personal
ssh-keygen -t ed25519 -C "campus@email.com" -f ~/.ssh/id_ed25519_kampus

cat >> ~/.ssh/config << 'EOF'
Host github.com-personal
  HostName github.com
  User git
  IdentityFile ~/.ssh/id_ed25519_personal

Host github.com-kampus
  HostName github.com
  User git
  IdentityFile ~/.ssh/id_ed25519_kampus
EOF
```

### Slow Shell Startup

1. Check which tools are installed:
```bash
command -v fnm zoxide eza bun
```

2. Comment out unused initializations in `.zshrc`:
```bash
# Example: if you don't use Bun
# [ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"
```

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
z proj      # Jump to ~/Projects

# Note: cd is aliased to z, so just use cd normally!
```

### FZF Power Features
```bash
Ctrl+R      # Fuzzy search command history
Ctrl+T      # Fuzzy file finder
Alt+C       # Fuzzy directory finder
```

### Git Workflow Example
```bash
mkcd my-app
init-repo personal
echo "# My App" > README.md
gacp "initial commit"

# Later, on a campus project:
cd ~/campus-project
use-git kampus
gaacp     # Let AI write the commit message
```

### Multi-Account SSH Cloning
```bash
git clone git@github.com-personal:username/repo.git
git clone git@github.com-kampus:username/repo.git
# use-git handles remote URL switching automatically
```

---

## 🎓 Learning Resources

- [ZSH Documentation](http://zsh.sourceforge.net/Doc/)
- [CachyOS Wiki](https://wiki.cachyos.org/)
- [Eza GitHub](https://github.com/eza-community/eza)
- [Zoxide GitHub](https://github.com/ajeetdsouza/zoxide)
- [FZF Documentation](https://github.com/junegunn/fzf)
- [FNM Documentation](https://github.com/Schniz/fnm)
- [aicommits GitHub](https://github.com/Nutlope/aicommits)
- [GitHub Multiple SSH Keys](https://docs.github.com/en/authentication/connecting-to-github-with-ssh)

---

## 🤝 Contributing

1. Fork this repository
2. Create a feature branch: `git checkout -b feature/amazing-feature`
3. Commit your changes: `gacp "feat: add amazing feature"`
4. Open a Pull Request

---

## 📋 Changelog

### Version 1.1.0
- ✅ Added `gaacp` — AI-powered commit + push
- ✅ Added `rmnoext` — delete files without extension
- ✅ Indonesian comments throughout `.zshrc`
- ✅ Removed unused aliases (`dl`, `desk`, `proj`, `serve`, `dev`, `build`)
- ✅ Compacted guard clauses in functions

### Version 1.0.0
- ✨ Initial release
- ✅ Multi-account Git workflow
- ✅ C programming helpers
- ✅ Modern CLI integrations
- ✅ Smart error handling

---

## 🙏 Acknowledgments

- **CachyOS Team** — For the excellent base ZSH configuration
- **Oh-My-Zsh Community** — For the plugin ecosystem
- **Eza / Zoxide / FNM Authors** — For modern CLI tools
- **Nutlope** — For [aicommits](https://github.com/Nutlope/aicommits)

---

## 📄 License

MIT License - Feel free to use, modify, and distribute!

---

## 🧑‍💻 Author

**Budi Imam Prasetyo (Ryoukaii)**  
🐧 CachyOS Enthusiast • ⚡ Performance Optimizer • 🔒 Security Aware

> *"A well-configured terminal is a developer's best friend. Keep it fast, clean, and powerful."*

---

<div align="center">

### ⭐ If this helped you, consider starring the repo!

**Made with ❤️ for the CachyOS community**

[Report Bug](https://github.com/YOUR_USERNAME/ZSH-Config/issues) • [Request Feature](https://github.com/YOUR_USERNAME/ZSH-Config/issues)

</div>

---

🔥 **Happy coding with CachyOS!** 🚀