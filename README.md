# 🧠 ZSH Configuration — Clean & Optimized

Custom `.zshrc` setup yang dirancang buat performa cepat, tampilan clean, dan pengalaman terminal yang modern.  
Menggunakan **Oh My Zsh**, **Powerlevel10k**, dan **Zinit Plugin Manager**, serta integrasi lengkap dengan **FNM**, **Bun**, **Zoxide**, dan **FZF**.

---

## ⚙️ Fitur Utama

✅ **Powerlevel10k Instant Prompt** — Startup shell super cepat.  
✅ **Oh My Zsh Plugins** — Autosuggestions, syntax highlighting, dan fzf.  
✅ **Environment Ready** — Auto setup untuk Node, Bun, Zoxide, dan FZF.  
✅ **Custom Aliases & Functions** — Git, PHP, npm, compile C, dan auto push `.zshrc`.  
✅ **Zinit Integration** — Plugin manager ringan dan powerful.  

---

## 📦 Dependencies

Pastikan kamu udah install beberapa tools berikut sebelum pakai config ini:

| Tool | Fungsi | Instalasi (Ubuntu) |
|------|---------|--------------------|
| **Zsh** | Shell utama | `sudo apt install zsh` |
| **Oh My Zsh** | Framework Zsh | [ohmyz.sh](https://ohmyz.sh) |
| **Powerlevel10k** | Tema Zsh | `git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.oh-my-zsh/custom/themes/powerlevel10k` |
| **Zinit** | Plugin manager | `git clone https://github.com/zdharma-continuum/zinit ~/.local/share/zinit/zinit.git` |
| **Zoxide** | Navigasi direktori cerdas | `sudo apt install zoxide` |
| **FZF** | Fuzzy finder | `sudo apt install fzf` |
| **FNM** | Node manager cepat | `curl -fsSL https://fnm.vercel.app/install | bash` |
| **Bun** | JS runtime modern | [bun.sh](https://bun.sh) |
| **eza** | Pengganti `ls` modern | `sudo apt install eza` |

---

## 🧩 Struktur Konfigurasi

### 🔹 Powerlevel10k Instant Prompt
Mempercepat startup Zsh dengan caching prompt sebelumnya.

```zsh
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
````

### 🔹 Oh My Zsh + Plugins

Mengaktifkan plugin untuk produktivitas tinggi.

```zsh
plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
  fzf
)
```

### 🔹 Environment Configuration

Setup PATH, Node, Bun, dan Zoxide secara otomatis.

```zsh
export PATH="$HOME/bin:$HOME/.local/bin:$HOME/.fnm:$PATH"
eval "$(fnm env)"
eval "$(zoxide init zsh)"
```

### 🔹 Custom Aliases

Shortcut command buat kerja cepat.

| Alias                 | Deskripsi                     |
| --------------------- | ----------------------------- |
| `ls`, `ll`, `la`      | List file pakai `eza`         |
| `zconfig`             | Buka file `.zshrc` di VS Code |
| `ga`, `gacp`, `zpush` | Workflow Git otomatis         |
| `serve`, `dev`        | Shortcut Laravel & npm        |
| `..`, `...`           | Navigasi cepat direktori      |

---

## 🧠 Custom Functions

### 🧩 `compile()`

Compile dan jalankan file C dalam satu langkah.

```zsh
compile main.c
```

### 🚀 `gacp()`

Git Add, Commit, Push otomatis.

```zsh
gacp "update zsh aliases"
```

### 💾 `zpush()`

Push konfigurasi `.zshrc` ke repo dotfiles secara otomatis.

```zsh
zpush "update theme and aliases"
```

---

## 🔌 Zinit Plugin Manager

Bagian ini otomatis install Zinit jika belum ada, lalu load plugin annex untuk dukungan tambahan.

```zsh
zinit light-mode for \
  zdharma-continuum/zinit-annex-as-monitor \
  zdharma-continuum/zinit-annex-bin-gem-node \
  zdharma-continuum/zinit-annex-patch-dl \
  zdharma-continuum/zinit-annex-rust \
  MichaelAquilina/zsh-you-should-use
```

---

## 🧭 Bonus: Bun & FNM Integration

Menjamin environment JS kamu selalu up to date.

```zsh
eval "$(fnm env --use-on-cd --shell zsh)"
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
```

---

## 📂 Lokasi File

| File                    | Fungsi                                |
| ----------------------- | ------------------------------------- |
| `~/.zshrc`              | File utama konfigurasi                |
| `~/.p10k.zsh`           | Konfigurasi Powerlevel10k             |
| `~/.local/share/zinit/` | Folder plugin manager Zinit           |
| `~/dotfiles/`           | Repo tempat menyimpan backup `.zshrc` |

---

## 🚀 Cara Install

```bash
git clone https://github.com/<username>/ZSH-Config.git ~/dotfiles
cp ~/dotfiles/.zshrc ~/.zshrc
exec zsh
```

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

> “Optimize your terminal, optimize your brain.”
