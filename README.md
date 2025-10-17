# ⚡️ ZSH Configuration — *Clean, Fast, and Modern*

> ✨ *Transform your terminal from boring to blazing.*

![ZSH Showcase](https://raw.githubusercontent.com/ryoukaii/dotfiles/main/.github/assets/zsh-preview.gif)

Custom **`.zshrc`** setup buat developer yang pengen terminal:

* ⚡ **Super cepat**
* 🎯 **Minimal tapi fungsional**
* 🧠 **Smart, otomatis, dan gampang di-extend**

Menggabungkan **Oh My Zsh**, **Powerlevel10k**, **Zinit**, **FNM**, **Bun**, **Zoxide**, dan **FZF** dalam satu konfigurasi yang efisien dan indah.

---

## 🧩 Fitur Unggulan

| 🔥 Fitur                          | ⚙️ Deskripsi                                               |
| --------------------------------- | ---------------------------------------------------------- |
| ⚡ **Instant Prompt**              | Powerlevel10k bikin shell start < **1 detik**              |
| 🔮 **Oh My Zsh Plugins**          | Autosuggestion, syntax highlighting, fzf integration       |
| 🧱 **Smart Environment Setup**    | Auto-setup Node (FNM), Bun, Rust, Zoxide, dll              |
| 🪄 **Custom Aliases & Functions** | Workflow Git, PHP, npm, dan C compiler super cepat         |
| 🚀 **Zinit Plugin Manager**       | Plugin system ringan & lazy-loaded                         |
| 💾 **Auto Backup**                | Push `.zshrc` langsung ke repo `dotfiles` dengan 1 command |

---

## ⚙️ Dependencies

Pastikan semua tools berikut udah terinstal sebelum pakai setup ini 👇

| Tool                 | Fungsi                    | Instalasi (Ubuntu)                                                                                          |       |
| -------------------- | ------------------------- | ----------------------------------------------------------------------------------------------------------- | ----- |
| 🐚 **Zsh**           | Shell utama               | `sudo apt install zsh`                                                                                      |       |
| ⚙️ **Oh My Zsh**     | Framework utama           | [ohmyz.sh](https://ohmyz.sh)                                                                                |       |
| 🎨 **Powerlevel10k** | Tema modern               | `git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.oh-my-zsh/custom/themes/powerlevel10k` |       |
| 🔌 **Zinit**         | Plugin manager cepat      | `git clone https://github.com/zdharma-continuum/zinit ~/.local/share/zinit/zinit.git`                       |       |
| 📁 **Zoxide**        | Navigasi direktori cerdas | `sudo apt install zoxide`                                                                                   |       |
| 🔍 **FZF**           | Fuzzy finder interaktif   | `sudo apt install fzf`                                                                                      |       |
| 🟢 **FNM**           | Node version manager      | `curl -fsSL [https://fnm.vercel.app/install](https://fnm.vercel.app/install)                                | bash` |
| ⚡ **Bun**            | JS runtime ultra cepat    | [bun.sh](https://bun.sh)                                                                                    |       |
| 📜 **Eza**           | Modern replacement `ls`   | `sudo apt install eza`                                                                                      |       |

---

## 🧠 Struktur Konfigurasi

### 💡 Powerlevel10k Instant Prompt

Percepat startup shell dengan cache prompt:

```zsh
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
```

---

### 🔮 Oh My Zsh + Plugins

```zsh
plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
  fzf
)
```

> ⚙️ Minimalis, tapi powerful — cocok buat workflow harian yang cepat dan fokus.

---

### 🌍 Smart Environment Setup

Setup otomatis buat Node.js, Bun, Zoxide, dan Rust.

```zsh
eval "$(fnm env --use-on-cd --shell zsh)"
eval "$(zoxide init zsh)"
```

> 💡 Tambahkan `$HOME/.cargo/bin` atau `$HOME/.bun/bin` di PATH kalau pakai Rust atau Bun.

---

### ⚡ Custom Aliases

| Alias                 | Fungsi                                |
| --------------------- | ------------------------------------- |
| `ls`, `ll`, `la`      | Modern directory listing dengan `eza` |
| `zconfig`             | Buka `.zshrc` di VS Code              |
| `ga`, `gacp`, `zpush` | Workflow Git otomatis                 |
| `serve`, `dev`        | Laravel & npm dev shortcut            |
| `..`, `...`           | Navigasi cepat antar direktori        |

---

## 🧠 Custom Functions

### 🧩 `compile()`

Compile & jalankan program C dalam satu langkah.

```bash
compile main.c
```

### 🚀 `gacp()`

Commit + push otomatis.

```bash
gacp "update aliases"
```

### 💾 `zpush()`

Backup `.zshrc` langsung ke repo `dotfiles`.

```bash
zpush "update theme and aliases"
```

---

## 🔌 Zinit Plugin Manager

Zinit akan otomatis terinstall dan meload plugin dengan *lazy mode*:

```zsh
zinit wait lucid light-mode for \
  zdharma-continuum/zinit-annex-as-monitor \
  zdharma-continuum/zinit-annex-bin-gem-node \
  zdharma-continuum/zinit-annex-patch-dl \
  zdharma-continuum/zinit-annex-rust \
  MichaelAquilina/zsh-you-should-use
```

> 🧠 **Zinit** = kombinasi ringan, fleksibel, dan cepat dibanding Antigen / Zplug.

---

## 🪄 Bun & FNM Integration

```zsh
eval "$(fnm env --use-on-cd --shell zsh)"
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
```

> 🧩 Otomatis ganti versi Node pas `cd` ke project dengan `.node-version` atau `.nvmrc`.

---

## 📁 Struktur File

| Path                    | Fungsi                         |
| ----------------------- | ------------------------------ |
| `~/.zshrc`              | File utama konfigurasi         |
| `~/.p10k.zsh`           | File konfigurasi Powerlevel10k |
| `~/.local/share/zinit/` | Folder plugin Zinit            |
| `~/dotfiles/`           | Repo tempat backup `.zshrc`    |

---

## 🚀 Instalasi Cepat

```bash
git clone https://github.com/<username>/dotfiles.git ~/dotfiles
cp ~/dotfiles/.zshrc ~/.zshrc
exec zsh
```

> ⚡ Jalankan `zconfig` buat langsung buka config di VS Code.

---

## 🧰 Troubleshooting

| Masalah                   | Solusi                                                                       |       |
| ------------------------- | ---------------------------------------------------------------------------- | ----- |
| `command not found: eza`  | `sudo apt install eza`                                                       |       |
| `fnm not found`           | `curl -fsSL [https://fnm.vercel.app/install](https://fnm.vercel.app/install) | bash` |
| `powerlevel10k not found` | Clone ulang Powerlevel10k theme                                              |       |
| Startup lambat            | Cek FNM & Bun path duplikasi                                                 |       |

---

## 🧠 Credits

> Tools yang bikin hidup di terminal jadi lebih menyenangkan 💖
> [Oh My Zsh](https://ohmyz.sh) • [Powerlevel10k](https://github.com/romkatv/powerlevel10k) • [Zinit](https://github.com/zdharma-continuum/zinit) • [FNM](https://fnm.vercel.app) • [Bun](https://bun.sh) • [Zoxide](https://github.com/ajeetdsouza/zoxide)

---

## 🧑‍💻 Author

**Ryoukaii**
🧠 Linux • ⚡ Fast Workflow • 🧩 Critical Thinking

> *“Optimize your terminal, optimize your brain.”* 🪶

---

🔥 *Terminal lo bukan cuma alat — itu refleksi mindset lo. Keep it fast, clean, and alive.*