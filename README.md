# ⚡ ZSH Configuration — *Optimized & Secure Edition*

> ✨ *Transform your terminal from boring to blazing.*

Custom **`.zshrc`** setup untuk developer yang menginginkan terminal yang:

* ⚡ **Super cepat** dengan instant prompt
* 🎯 **Minimal namun powerful**
* 🔒 **Aman** dengan validasi dan error handling
* 🧠 **Smart** dengan auto-detection dan idempotent configuration

Menggabungkan **Oh My Zsh**, **Powerlevel10k**, **FNM**, **Bun**, **Zoxide**, dan **FZF** dalam satu konfigurasi yang efisien dan elegan.

---

## 🧩 Fitur Unggulan

| 🔥 Fitur | ⚙️ Deskripsi |
|---------|-------------|
| ⚡ **Instant Prompt** | Powerlevel10k membuat shell start < **1 detik** |
| 🔮 **Oh My Zsh Plugins** | Autosuggestion, syntax highlighting, fzf integration |
| 🧱 **Idempotent PATH** | Tidak ada duplikasi PATH meski source berkali-kali |
| 🪄 **Smart Functions** | Workflow Git, compile C, dengan validasi lengkap |
| 📦 **Modern Tools** | Integrasi FNM, Bun, Zoxide, Eza |
| 💾 **Auto Backup** | Push `.zshrc` ke repo `dotfiles` dengan 1 command |

---

## ⚙️ Dependencies

Pastikan semua tools berikut sudah terinstal:

### Core Tools
```bash
# ZSH & Oh My Zsh
sudo apt install zsh -y
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

### Theme & Plugins
```bash
# Powerlevel10k Theme
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

# ZSH Autosuggestions
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# ZSH Syntax Highlighting
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
```

### Additional Tools
```bash
# Modern CLI replacements
sudo apt install eza zoxide fzf -y

# FNM (Fast Node Manager)
curl -fsSL https://fnm.vercel.app/install | bash

# Bun (Optional)
curl -fsSL https://bun.sh/install | bash

# Development tools (for compile function)
sudo apt install clang bear -y
```

---

## 🚀 Instalasi

### Quick Install
```bash
# Clone repository
git clone https://github.com/<username>/dotfiles.git ~/dotfiles

# Backup .zshrc lama (jika ada)
[ -f ~/.zshrc ] && mv ~/.zshrc ~/.zshrc.backup

# Copy konfigurasi baru
cp ~/dotfiles/.zshrc ~/.zshrc

# Reload shell
exec zsh

# Konfigurasi Powerlevel10k (akan muncul wizard)
p10k configure
```

---

## 🧠 Struktur Konfigurasi

### 💡 Powerlevel10k Instant Prompt
Percepat startup shell dengan cache prompt:
```zsh
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
```

### 🔮 Oh My Zsh Configuration
```zsh
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(
  git                      # Git aliases dan completion
  zsh-autosuggestions      # Saran command otomatis
  fzf                      # Fuzzy finder integration
  zsh-syntax-highlighting  # Syntax highlighting real-time
)
```

### 🌍 Environment Setup (Idempotent)
PATH configuration yang aman dan tidak duplikat:
```zsh
paths=(
  "$HOME/bin"
  "$HOME/.local/bin"
  "$HOME/.fnm"
  "$HOME/.local/share/fnm"
  "$HOME/.cargo/bin"
  "$HOME/.bun/bin"
)
for p in "${paths[@]}"; do
  [[ ":$PATH:" != *":$p:"* ]] && PATH="$p:$PATH"
done
```

### 🔧 Tool Initialization
Auto-detection dengan conditional loading:
```zsh
# FNM - Fast Node Manager
command -v fnm >/dev/null 2>&1 && eval "$(fnm env --use-on-cd --shell zsh)"

# Zoxide - Smart directory jumper
command -v zoxide >/dev/null 2>&1 && eval "$(zoxide init zsh)"

# FZF - Fuzzy finder
command -v fzf >/dev/null 2>&1 && [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
```

---

## ⚡ Custom Aliases

### 📁 Directory & File Management
```bash
ls          # Modern ls dengan eza (icons + group directories)
ll          # Detailed list dengan git status
la          # List all termasuk hidden files
..          # cd ..
...         # cd ../..
```

### 🛠️ Development Shortcuts
```bash
zconfig     # Buka .zshrc di VS Code
c           # clear
x           # exit
ga          # git add .
serve       # php artisan serve
dev         # npm run dev
download    # cd ke folder Downloads
```

---

## 🧠 Custom Functions

### 📦 `mkcd()` - Make Directory & CD
Buat folder dan langsung masuk ke dalamnya:
```bash
mkcd new-project
```

### 🔨 `compile()` - Smart C Compiler
Compile dan jalankan program C dengan Clang + Bear (generate `compile_commands.json`):
```bash
compile main.c
```

**Fitur:**
- ✅ Auto-check Clang dan Bear
- ✅ Generate `compile_commands.json` untuk LSP
- ✅ Compile dengan flags `-Wall -Wextra -std=c99`
- ✅ Auto-run setelah compile sukses
- ✅ Error handling lengkap

### 🚀 `gacp()` - Git Add, Commit, Push
Workflow Git otomatis dengan validasi:
```bash
gacp "fix: update login validation"
```

**Fitur:**
- ✅ Auto-detect current branch
- ✅ Cek koneksi internet sebelum push
- ✅ Full error handling
- ✅ Informative feedback

### 💾 `zpush()` - Backup ZSH Config
Backup `.zshrc` ke repository dotfiles:
```bash
zpush "update: add new aliases"
```

**Fitur:**
- ✅ Auto-copy `.zshrc` ke `~/dotfiles`
- ✅ Auto-detect main branch (master/main)
- ✅ Git commit dan push otomatis
- ✅ Return ke direktori sebelumnya

### 🌐 `githack()` - Convert GitHub URL to raw.githack
Convert GitHub blob URL menjadi raw.githack URL untuk preview langsung:
```bash
githack https://github.com/user/repo/blob/main/index.html
```

**Fitur:**
- ✅ Support GitHub blob URL
- ✅ Support raw.githubusercontent.com URL
- ✅ Auto-trim whitespace
- ✅ User-friendly error messages

---

## 📁 Struktur File

```
~/
├── .zshrc                    # File konfigurasi utama
├── .p10k.zsh                 # Konfigurasi Powerlevel10k
├── .oh-my-zsh/               # Oh My Zsh installation
│   └── custom/
│       ├── themes/
│       │   └── powerlevel10k/
│       └── plugins/
│           ├── zsh-autosuggestions/
│           └── zsh-syntax-highlighting/
└── dotfiles/                 # Repository backup
    └── .zshrc
```

---

## 🧰 Troubleshooting

### Plugin tidak muncul
```bash
# Reinstall plugins
rm -rf ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/*
# Ikuti instruksi instalasi di atas
```

### Command not found
| Error | Solusi |
|-------|--------|
| `eza: command not found` | `sudo apt install eza -y` |
| `fnm: command not found` | `curl -fsSL https://fnm.vercel.app/install \| bash` |
| `zoxide: command not found` | `sudo apt install zoxide -y` |
| `clang: command not found` | `sudo apt install clang bear -y` |

### Startup lambat
1. Cek plugin yang tidak perlu
2. Hapus PATH duplikat manual (sudah handled otomatis)
3. Jalankan `p10k configure` untuk optimasi instant prompt

### Git push gagal di `gacp()` atau `zpush()`
- Pastikan SSH key sudah di-setup
- Cek remote repository dengan `git remote -v`
- Cek internet connection

---

## 🎨 Customization

### Tambah Alias Baru
Edit `.zshrc` dan tambahkan di section `CUSTOM ALIASES`:
```bash
alias myalias='command here'
```

### Tambah Function Baru
Tambahkan di section `CUSTOM FUNCTIONS`:
```bash
myfunction() {
  # Your code here
}
```

### Update Theme
Jalankan konfigurasi ulang Powerlevel10k:
```bash
p10k configure
```

---

## 🧠 Best Practices

1. **Backup Regular**: Gunakan `zpush "update message"` untuk backup otomatis
2. **Update Tools**: Update Oh My Zsh dan plugins secara berkala
   ```bash
   omz update
   ```
3. **Clean History**: Set `HIST_STAMPS="yyyy-mm-dd"` untuk history yang rapi
4. **Safe Editing**: Edit `.zshrc` dengan `zconfig`, test dengan `source ~/.zshrc`

---

## 🔥 Pro Tips

- **Quick Navigation**: Gunakan `z` (dari zoxide) untuk jump ke direktori favorit
- **FZF Search**: `Ctrl+R` untuk search command history dengan fuzzy finder
- **Git Shortcuts**: Combine `ga` + `gacp` untuk workflow super cepat
- **Node Version**: FNM auto-switch Node version berdasarkan `.node-version` atau `.nvmrc`

---

## 📚 Resources

- [Oh My Zsh Documentation](https://github.com/ohmyzsh/ohmyzsh/wiki)
- [Powerlevel10k](https://github.com/romkatv/powerlevel10k)
- [ZSH Plugin Standard](https://zdharma-continuum.github.io/Zsh-100-Commits-Club/Zsh-Plugin-Standard.html)
- [FNM Documentation](https://github.com/Schniz/fnm)
- [Zoxide Documentation](https://github.com/ajeetdsouza/zoxide)

---

## 🧑‍💻 Author

**Ryoukaii**  
🧠 Linux Enthusiast • ⚡ Performance Optimizer • 🔒 Security Aware

> *"Your terminal is a reflection of your workflow. Keep it fast, secure, and elegant."* 🪶

---

## 📄 License

MIT License - Feel free to use and modify!

---

🔥 *Optimize your terminal, optimize your productivity.*