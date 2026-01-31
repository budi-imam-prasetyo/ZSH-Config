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
- **zoxide** - Smart directory jumper (`z` command)
- **fnm** - Fast Node.js version manager
- **bun** - Fast JavaScript runtime (optional)

### ⚡ Custom Features
- **C/C++ development** helpers with Clang integration
- **Multi-account Git** workflow (personal + kampus/work)
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
# Install with pacman
sudo pacman -S eza zoxide fzf clang
```

### Optional (Development Tools)
```bash
# Fast Node Manager (highly recommended for Node.js devs)
curl -fsSL https://fnm.vercel.app/install | bash

# Bun runtime (optional, for JavaScript/TypeScript)
curl -fsSL https://bun.sh/install | bash

# Additional development tools
sudo pacman -S git base-devel gdb
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
ls          # Beautiful listing with icons
ll          # Detailed view with file sizes and git status
la          # Show hidden files
lt          # Tree view (2 levels deep)
lta         # Tree view including hidden files
```

#### Quick Navigation
```bash
..          # Go up one directory
...         # Go up two directories
....        # Go up three directories
-           # Jump to previous directory

dl          # Jump to Downloads folder
desk        # Jump to Desktop
proj        # Jump to Projects (or Kuliah if not found)

mkcd myapp  # Create directory and cd into it
```

### 💻 Development Workflow

#### C Programming
```bash
# Compile and run in one command
compile program.c
compile calculator.c 5 10    # With arguments

# Compile with debug symbols for GDB
debug-compile program.c
gdb ./program                # Debug with GDB
```

**Features:**
- ✅ Automatic Clang installation check
- ✅ Full compiler warnings (`-Wall -Wextra`)
- ✅ C99 standard
- ✅ Debug symbols included
- ✅ AddressSanitizer in debug builds

#### Git Multi-Account Workflow

**Setup your accounts** (edit in `.zshrc`):
```bash
# Configuration is already included:
# - personal: Budi Imam Prasetyo <budiimamprsty@gmail.com>
# - kampus: Budi Prasetyo <budi.prasetyo@satu.ac.id>
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
```

**Quick commit & push:**
```bash
gacp "feat: add user authentication"

# Does three things:
# 1. git add .
# 2. git commit -m "message"
# 3. git push (only if online)
```

**Backup your .zshrc:**
```bash
zpush "update: added new aliases"

# Syncs ~/.zshrc to ~/ZSH-Config repository
```

#### Standard Git Shortcuts
```bash
ga          # git add .
gs          # git status (short format with branch)
gl          # git log (last 15 commits, one line each)
gd          # git diff
```

#### Framework Development
```bash
serve       # php artisan serve (Laravel)
dev         # npm run dev (Vite/Webpack)
build       # npm run build (production)
```

### 🛠️ Utilities

#### GitHub URL Converter
```bash
# Convert GitHub blob URLs to raw.githack CDN
githack https://github.com/user/repo/blob/main/script.js

# Output:
# 🌐 https://raw.githack.com/user/repo/main/script.js
# 📋 Copied to clipboard! (if xclip is installed)
```

#### Quick Notes System
```bash
note "Remember to update documentation"    # Add timestamped note
note -l                                    # List all notes
note                                       # Open notes in editor
note -c                                    # Clear all notes
```

#### Process Management
```bash
fkill       # Fuzzy search and kill process interactively
```

#### Benchmarking
```bash
bench npm run build              # Measure execution time
bench ./my-script.sh            # Works with any command
```

### ℹ️ System Information

```bash
myip        # Show your public IP
weather     # Current weather for your location
ports       # List all open ports
diskspace   # Disk usage summary
meminfo     # Memory usage
```

### ⚙️ Configuration

```bash
zconfig     # Edit .zshrc in your editor (VS Code by default)
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
| `init-repo` | `init-repo personal` | Initialize repo with account |
| `use-git` | `use-git kampus` | Switch Git account |
| `zpush` | `zpush "message"` | Backup .zshrc to repo |
| `githack` | `githack <url>` | Convert GitHub URL to CDN |
| `note` | `note "text"` | Quick note-taking |
| `bench` | `bench command` | Benchmark execution time |
| `fkill` | `fkill` | Fuzzy process killer |

---

## 🗂️ File Structure

```
~/
├── .zshrc                           # Your configuration (this file)
├── .notes.md                        # Quick notes storage
└── ZSH-Config/                      # Backup repository (optional)
    └── .zshrc

# CachyOS System Files (don't modify):
/usr/share/cachyos-zsh-config/
└── cachyos-config.zsh              # Base configuration
```

---

## 🔧 Customization

### Adding Custom Aliases

Edit `.zshrc` in the aliases section:
```bash
# Open config
zconfig

# Add your alias in the ALIASES section:
alias myalias='command here'

# Reload
zreload
```

### Adding Custom Functions

```bash
# Add in the FUNCTIONS section:
myfunction() {
  # Your code here
  echo "Hello from my function!"
}
```

### Modifying Git Accounts

Edit the `GIT_ACCOUNTS` associative array:
```bash
typeset -A GIT_ACCOUNTS
GIT_ACCOUNTS=(
  [personal]="Your Name|your.email@gmail.com|github.com-personal"
  [work]="Work Name|work@company.com|github.com-work"
)
```

**Format:** `"Name|email|ssh-host-alias"`

---

## 🐛 Troubleshooting

### Commands Not Found

| Issue | Solution |
|-------|----------|
| `eza: command not found` | `sudo pacman -S eza` |
| `zoxide: command not found` | `sudo pacman -S zoxide` |
| `fnm: command not found` | `curl -fsSL https://fnm.vercel.app/install \| bash` |
| `clang: command not found` | `sudo pacman -S clang` |

### Git Functions Not Working

**Check your Git configuration:**
```bash
# View current config
git config --list | grep user

# Ensure SSH keys are set up
ls -la ~/.ssh
```

**Set up SSH keys for multiple accounts:**
```bash
# Generate keys for each account
ssh-keygen -t ed25519 -C "personal@email.com" -f ~/.ssh/id_ed25519_personal
ssh-keygen -t ed25519 -C "work@email.com" -f ~/.ssh/id_ed25519_work

# Configure ~/.ssh/config
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

1. Check which tools are actually installed:
```bash
command -v fnm zoxide eza
```

2. Comment out initializations you don't use:
```bash
# Example: If you don't use Bun
# [ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"
```

### PATH Issues

The configuration uses `typeset -U path` to prevent duplicates automatically. If you still see issues:

```bash
# Check current PATH
echo $PATH | tr ':' '\n'

# Reset and reload
unset PATH
exec zsh
```

---

## 💡 Tips & Tricks

### Using Zoxide Efficiently
```bash
# After visiting directories a few times
z docs          # Jump to ~/Documents
z proj          # Jump to ~/Projects
z down          # Jump to ~/Downloads

# Zoxide learns your habits!
```

### FZF Power Features
```bash
Ctrl+R          # Fuzzy search command history
Ctrl+T          # Fuzzy file finder
Alt+C           # Fuzzy directory finder

# In any command, type part of the name and hit Ctrl+T:
vim **<Ctrl+T>  # Opens fuzzy finder for files
```

### Git Workflow Example
```bash
# Start new project
mkcd my-awesome-app
init-repo personal
echo "# My Awesome App" > README.md
gacp "initial commit"

# Later, switch to work project
cd ~/work-project
use-git kampus
gacp "fix: resolve authentication bug"
```

### Multi-Account SSH Setup
```bash
# Clone with specific account
git clone git@github.com-personal:username/repo.git
git clone git@github.com-kampus:username/repo.git

# The use-git function handles remote URL switching automatically!
```

---

## 🎓 Learning Resources

### ZSH
- [ZSH Documentation](http://zsh.sourceforge.net/Doc/)
- [CachyOS ZSH Guide](https://wiki.cachyos.org/)

### Modern CLI Tools
- [Eza GitHub](https://github.com/eza-community/eza)
- [Zoxide GitHub](https://github.com/ajeetdsouza/zoxide)
- [FZF Documentation](https://github.com/junegunn/fzf)
- [FNM Documentation](https://github.com/Schniz/fnm)

### Git Multi-Account Setup
- [GitHub Multiple SSH Keys](https://docs.github.com/en/authentication/connecting-to-github-with-ssh)
- [Git Configuration Guide](https://git-scm.com/book/en/v2/Customizing-Git-Git-Configuration)

---

## 🤝 Contributing

Found a bug or have a suggestion?

1. **Fork this repository**
2. **Create a feature branch**: `git checkout -b feature/amazing-feature`
3. **Commit your changes**: `git commit -m 'feat: add amazing feature'`
4. **Push to branch**: `git push origin feature/amazing-feature`
5. **Open a Pull Request**

---

## 📋 Changelog

### Version 1.0.0 (2025-01-31)
- ✨ Initial release
- ✅ Multi-account Git workflow
- ✅ C programming helpers
- ✅ Modern CLI integrations
- ✅ Comprehensive documentation
- ✅ Smart error handling

---

## 🙏 Acknowledgments

- **CachyOS Team** - For the excellent base ZSH configuration
- **Oh-My-Zsh Community** - For the plugin ecosystem
- **Eza/Zoxide/FNM Authors** - For modern CLI tools
- All open-source contributors who make our terminals better

---

## 📄 License

MIT License - Feel free to use, modify, and distribute!

```
Copyright (c) 2025 Budi Imam Prasetyo

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.
```

---

## 🧑‍💻 Author

**Budi Imam Prasetyo (Ryoukaii)**  
🐧 CachyOS Enthusiast • ⚡ Performance Optimizer • 🔒 Security Aware

> *"A well-configured terminal is a developer's best friend. Keep it fast, clean, and powerful."*

---

<div align="center">

### ⭐ If this helped you, consider starring the repo!

**Made with ❤️ for the CachyOS community**

[Report Bug](https://github.com/YOUR_USERNAME/ZSH-Config/issues) • [Request Feature](https://github.com/YOUR_USERNAME/ZSH-Config/issues) • [Documentation](https://github.com/YOUR_USERNAME/ZSH-Config/wiki)

</div>

---

🔥 **Happy coding with CachyOS!** 🚀