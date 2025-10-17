# 🧠 ZSH Configuration — Clean, Fast, and Modern

Custom **`.zshrc`** setup untuk developer yang pengen terminal **super cepat**, **rapi**, dan **fun to use**.
Menggabungkan **Oh My Zsh**, **Powerlevel10k**, **Zinit**, **FNM**, **Bun**, **Zoxide**, dan **FZF** dalam satu konfigurasi yang efisien.

---

## ⚙️ Fitur Utama

✅ **Powerlevel10k Instant Prompt** — Shell startup <1s.
✅ **Oh My Zsh Plugins** — Autosuggestion, syntax highlighting, fzf.
✅ **Smart Environment Setup** — Otomatis setup Node, Bun, Zoxide, dan FZF.
✅ **Custom Aliases & Functions** — Git, PHP, npm, dan C compiler.
✅ **Zinit Integration** — Plugin manager ringan tapi powerful.
✅ **Auto Backup** — Push `.zshrc` ke repo `dotfiles` otomatis.

---

## 📦 Dependencies

Pastikan semua dependency ini udah terpasang sebelum lo pakai config ini:

| Tool                 | Fungsi                        | Instalasi (Ubuntu)                                                                                          |       |
| -------------------- | ----------------------------- | ----------------------------------------------------------------------------------------------------------- | ----- |
| 🐚 **Zsh**           | Shell utama                   | `sudo apt install zsh`                                                                                      |       |
| ⚙️ **Oh My Zsh**     | Framework Zsh                 | [ohmyz.sh](https://ohmyz.sh)                                                                                |       |
| 🎨 **Powerlevel10k** | Tema Zsh modern               | `git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.oh-my-zsh/custom/themes/powerlevel10k` |       |
| 🔌 **Zinit**         | Plugin manager cepat          | `git clone https://github.com/zdharma-continuum/zinit ~/.local/share/zinit/zinit.git`                       |       |
| 📁 **Zoxide**        | Navigasi direktori cerdas     | `sudo apt install zoxide`                                                                                   |       |
| 🔍 **FZF**           | Fuzzy finder interaktif       | `sudo apt install fzf`                                                                                      |       |
| 🟢 **FNM**           | Node version manager          | `curl -fsSL [https://fnm.vercel.app/install](https://fnm.vercel.app/install)                                | bash` |
| ⚡ **Bun**            | Runtime JS modern             | [bun.sh](https://bun.sh)                                                                                    |       |
| 📜 **Eza**           | Modern replacement untuk `ls` | `sudo apt install eza`                                                                                      |       |

---

## 🧩 Struktur Konfigurasi

### 🔹 Powerlevel10k Instant Prompt

Meningkatkan kecepatan startup Zsh dengan caching prompt.

```zsh
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
```

### 🔹 Oh My Zsh + Plugins

Plugins yang diaktifkan buat workflow cepat dan efisien:

```zsh
plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
  fzf
)
```

---

### 🔹 Environment Configuration

Setup otomatis environment untuk Node.js, Bun, Zoxide, dan tools CLI lainnya.

```zsh
export PATH="$HOME/bin:$HOME/.local/bin:$HOME/.fnm:$PATH"
eval "$(fnm env)"
eval "$(zoxide init zsh)"
```

> 💡 **Tips:** Lo bisa tambahin `$HOME/.cargo/bin` di PATH kalau pakai Rust, atau `$HOME/.bun/bin` buat Bun runtime.

---

### 🔹 Custom Aliases

Alias dibuat buat *speedrun* command sehari-hari.

| Alias                 | Fungsi                            |
| --------------------- | --------------------------------- |
| `ls`, `ll`, `la`      | `eza` modern listing dengan icons |
| `zconfig`             | Buka file `.zshrc` di VS Code     |
| `ga`, `gacp`, `zpush` | Workflow Git otomatis             |
| `serve`, `dev`        | Shortcut Laravel & npm            |
| `..`, `...`           | Navigasi direktori cepat          |

---

## 🧠 Custom Functions

### ⚙️ `compile()`

Compile & jalankan file `.c` dalam satu langkah.

```zsh
compile main.c
```

---

### 🚀 `gacp()`

Automasi `git add`, `commit`, dan `push` dengan satu perintah.

```zsh
gacp "update zsh aliases"
```

---

### 💾 `zpush()`

Backup dan push file `.zshrc` ke repo `~/dotfiles` secara otomatis.

```zsh
zpush "update theme and aliases"
```

---

## 🔌 Zinit Plugin Manager

Zinit akan otomatis di-install jika belum ada, lalu load *annexes* buat memperkaya fitur.

```zsh
zinit light-mode for \
  zdharma-continuum/zinit-annex-as-monitor \
  zdharma-continuum/zinit-annex-bin-gem-node \
  zdharma-continuum/zinit-annex-patch-dl \
  zdharma-continuum/zinit-annex-rust \
  MichaelAquilina/zsh-you-should-use
```

> 🧠 Zinit lebih ringan dari plugin manager seperti Antigen atau Zplug, tapi punya fleksibilitas tinggi dan load time rendah.

---

## 🧭 Bun & FNM Integration

Dua runtime manager modern untuk JavaScript & Node environment.

```zsh
eval "$(fnm env --use-on-cd --shell zsh)"
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
```

> 🔥 Dengan ini, setiap kali lo `cd` ke project yang punya `.nvmrc` atau `.node-version`, Node version-nya otomatis diatur.

---

## 📂 Struktur File

| Path                    | Fungsi                         |
| ----------------------- | ------------------------------ |
| `~/.zshrc`              | File utama konfigurasi         |
| `~/.p10k.zsh`           | File konfigurasi Powerlevel10k |
| `~/.local/share/zinit/` | Folder plugin manager Zinit    |
| `~/dotfiles/`           | Repo tempat backup `.zshrc`    |

---

## 🚀 Cara Install

Clone repo, copy file `.zshrc`, dan jalankan shell baru.

```bash
git clone https://github.com/<username>/zsh-config.git ~/dotfiles
cp ~/dotfiles/.zshrc ~/.zshrc
exec zsh
```

> 💡 **Pro tip:** Tambahkan alias `zconfig='code ~/.zshrc'` biar cepat edit konfigurasi lo.

---

## 🧰 Troubleshooting

| Masalah                   | Solusi                                                                                      |       |
| ------------------------- | ------------------------------------------------------------------------------------------- | ----- |
| `command not found: eza`  | Install eza → `sudo apt install eza`                                                        |       |
| `fnm not found`           | Jalankan ulang `curl -fsSL [https://fnm.vercel.app/install](https://fnm.vercel.app/install) | bash` |
| `powerlevel10k not found` | Clone ulang repo Powerlevel10k                                                              |       |
| Startup lama              | Pastikan FNM & Bun tidak memanggil versi lama Node                                          |       |

---

## 🧠 Credits

* [Oh My Zsh](https://ohmyz.sh)
* [Powerlevel10k](https://github.com/romkatv/powerlevel10k)
* [Zinit](https://github.com/zdharma-continuum/zinit)
* [FNM](https://fnm.vercel.app)
* [Bun](https://bun.sh)
* [Zoxide](https://github.com/ajeetdsouza/zoxide)

---

## 🐧 Author

**Ryoukaii**
💻 Linux • 🧠 Critical Thinking • ⚡ Fast Workflow

> *“Optimize your terminal, optimize your brain.”*
