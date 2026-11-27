# ⚡ ZSH Configuration for CachyOS

A modular Zsh configuration that sources CachyOS's system configuration and adds custom aliases, completion, FZF settings, Git helpers, and optional tool integrations.

The entry point is [`.zshrc`](.zshrc). It loads the files in [`zsh/`](zsh/) in this order:

| File | Purpose |
|------|---------|
| `00-base.zsh` | CachyOS base, environment, PATH, history, shell options |
| `10-completion.zsh` | Completion cache, menu, matching, autosuggestion settings |
| `20-keybindings.zsh` | Cursor movement, command editing, suggestion acceptance |
| `30-fzf.zsh` | FZF appearance, preview, clipboard bindings |
| `40-aliases.zsh` | Eza helper and command aliases |
| `50-functions.zsh` | Git, compilation, file, and utility functions |
| `60-hooks.zsh` | Directory listings and long-command notifications |
| `70-integrations.zsh` | Optional tools and completion adapters |
| `80-plugins.zsh` | Plugins, Starship, Atuin, optional Patina |

## Requirements

The configuration expects the following files and command to be available; these startup dependencies are loaded without availability checks:

- `/usr/share/cachyos-zsh-config/cachyos-config.zsh`
- `/usr/share/doc/pkgfile/command-not-found.zsh`
- `/usr/share/fzf/key-bindings.zsh`
- `/usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh`
- `starship`

Other tools are needed only for the features that use them:

| Tool | Used by |
|------|---------|
| `eza` | Listing aliases and automatic listings after directory changes |
| `paru` | Package aliases and orphan cleanup |
| `git` | Git helpers and configuration backup |
| `fd` | `rmnoext` |
| `clang` with C23 support | `compile` |
| GNU `time` or `gtime`, plus `awk` | `bench` |
| `fresh` | Default editor, `f`, and `zfast` |
| `zeditor` (Zed) | `zconfig` and `esco` |
| `zellij` | Terminal session aliases |
| `wl-copy` | `wl`, clipboard support in `githack`, and FZF |
| `xclip` or `xsel` | FZF clipboard fallback when `wl-copy` is absent |
| `aicommits` | `gaacp` and `zpush` without a manual message |
| `ncdu` | `ncdu` alias, run through `sudo` |
| `kitty` and `terax` at `/usr/bin/` | `t` |
| `kitten` or `notify-send` | Notifications for commands lasting at least three seconds |

FZF's default preview calls **`~/.local/bin/fzf-preview.sh`**, which is not included in this repository. Supply that script or change the preview setting in `zsh/30-fzf.zsh`. FZF also invokes `file` for its header and needs a version that supports the configured options.

Optional integrations are activated when their commands or files are found: FNM, Zoxide, Bun completion, Broot, OpenClaw completion, OpenCode completion, Atuin, and `zsh-patina`. Their installation and account/provider setup are separate from this repository.

## Loading and customization

Keep `.zshrc` and the `zsh/` directory together. `.zshrc` resolves its module directory from its own file path, so copying only `.zshrc` is insufficient.

If this repository is at `~/ZSH-Config`, your existing `~/.zshrc` can source it with:

```zsh
source "$HOME/ZSH-Config/.zshrc"
```

Back up your existing configuration before replacing it. Edit aliases in `zsh/40-aliases.zsh`, functions in `zsh/50-functions.zsh`, and integrations in `zsh/70-integrations.zsh`.

```zsh
zconfig     # Open ~/ZSH-Config in Zed
zfast       # Open ~/ZSH-Config in Fresh
zreload     # Replace the current shell with a new Zsh session
```

These aliases and `zpush` use the fixed path `~/ZSH-Config`; adjust them if you keep the repository elsewhere.

## Listing and navigation

| Command | Behavior |
|---------|----------|
| `ls` | `ez`: Eza with icons, directories first, automatic color |
| `ll` | `ez -lh --git` |
| `la` | `ez -la --git` |
| `lt` | `ez -T --level=2` |
| `lta` | `ez -Ta --level=2` |
| `..`, `...`, `....` | Go up one, two, or three directories |
| `-` | Return to the previous directory |
| `d` | Change to `/data` |
| `mkcd project` | Create a directory and enter it |

`ez` applies `EZA_IGNORE` when an argument is exactly `-T` or `--tree`. With the current aliases, this applies to `lt`; the combined `-Ta` in `lta` does not trigger that check. The ignore list is `node_modules`, `vendor`, `dist`, `build`, `coverage`, `.git`, `.next`, `.nuxt`, and `target`.

A `chpwd` hook also lists directories with Eza and that ignore list after directory changes.

When Zoxide is installed, it is initialized with `--cmd cd`, providing the `cd` integration. The alias **`z` launches Zellij** in this configuration.

## Package and system aliases

| Alias | Expansion |
|-------|-----------|
| `yay` | `paru` |
| `s` | `paru -S` |
| `Rns` | `paru -Rns` |
| `Syu` | `paru -Syu` |
| `Syyu` | `paru -Syyu` |
| `Ss` | `paru -Ss` |
| `Qs` | `paru -Qs` |
| `Si` | `paru -Si` |
| `Qi` | `paru -Qi` |
| `orphan` | `paru -Qdt` |
| `clean-cache` | `paru -Sc` |
| `clean-cache-all` | `paru -Scc` |
| `clean-orphan` | `_clean_orphan`: list orphan packages, then run `paru -Rns` on them |
| `jctl` | `journalctl -p 3 -xb` |
| `ncdu` | `sudo ncdu` |
| `wl` | `wl-copy <` — use `wl file.txt` to copy a file's contents |
| `f` | `fresh` |
| `esco` | `zeditor ~/.config/espanso/match/base.yml` |
| `c` | `printf "\033c"` — reset the terminal |
| `q` | `exit` |

`reboot` first runs a systemctl dry run, asks for confirmation, then invokes `sudo systemctl reboot`.

The repository does not define `update`, `cleanup`, or `zhelp`; any such commands must come from your system or other configuration.

## Zellij aliases

| Alias | Expansion |
|-------|-----------|
| `z` | `zellij` |
| `za` | `zellij attach --create` |
| `zls` | `zellij list-sessions` |
| `zk` | `zellij kill-all-sessions` |
| `zr` | `zellij run --` |
| `ze` | `zellij edit` |

## Custom functions

### Git workflow

```zsh
gac "feat: add authentication"   # Stage all changes and commit
gacp "feat: add authentication"  # Stage, commit, then attempt push
gaacp                           # Run aicommits, then attempt push
zpush "update aliases"          # Stage, commit, and push ~/ZSH-Config
zpush                           # Same repository, using aicommits
```

- `gac` and `gacp` require a nonempty message, a Git repository, and local changes. Both stage with `git add -A`.
- `gacp`, `gaacp`, and `zpush` reject detached HEAD. Only `gacp` prints a warning for an HTTPS `origin` URL; it does not validate SSH keys.
- `gaacp` delegates commit creation to `aicommits`; `zpush` stages all changes before creating a manual or AI commit.
- Push helpers check `origin` with `git ls-remote`, then push the current branch with upstream tracking. A failed check can indicate connectivity, authentication, or remote configuration problems.
- If the remote check fails after committing, the local commit remains. `gacp` and `gaacp` print an offline notice; `zpush` returns an error with connection troubleshooting hints.
- All three push helpers return early when there are no local changes, so they do not push existing unpushed commits in that case.

Git aliases such as `ga`, `gs`, `gl`, and `gd` are not defined by this repository. Their availability depends on your system configuration.

### Compile and run C

```zsh
compile program.c
compile calculator.c 5 10
```

`compile` checks for Clang and the input file, builds with `-O2 -Wall -Wextra -std=c23`, and runs `bin/<source-basename>` with any remaining arguments. Output is relative to the current directory. The function returns the program's exit status after a successful build; it does not implement cleanup on interrupt.

### File and URL utilities

| Function | Usage | Behavior |
|----------|-------|----------|
| `rmnoext` | `rmnoext` | Recursively find files with extensionless names via `fd`, display the list, and ask before deletion |
| `githack` | `githack <url>` | Convert GitHub blob or raw URLs to `raw.githack.com`, or pass through an existing CDN URL |
| `bench` | `bench command [args...]` | Report elapsed, user, system, and combined CPU time using GNU time; preserve the command's exit status |
| `t` | `t` | Start a login Zsh that opens Kitty running Terax in the current directory |

`rmnoext` excludes `.git`, `node_modules`, and `vendor`, and uses `--no-ignore-vcs`. Files such as `Makefile`, `LICENSE`, `README`, and `Dockerfile` can be included; review its printed list before confirming.

`githack` copies the result only when `wl-copy` is available. Its clipboard implementation does not fall back to X11 tools.

## Completion, keybindings, and FZF

Completion uses a `.zcompdump` in `${ZDOTDIR:-$HOME}`. A dump modified within the last 24 hours is reused with `compinit -C`; otherwise normal `compinit` runs. Completion settings include menu selection, case-insensitive matching, grouped results, colors, and a cache under `${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompcache`.

Autosuggestions use history and completion, run asynchronously, and have a buffer size limit of 50 characters.

| Binding | Configuration |
|---------|---------------|
| Left / Right | Move backward / forward by character |
| Ctrl+Left / Ctrl+Right | Move backward / forward by word |
| Ctrl+X, Ctrl+X | Edit the command line using `$EDITOR` |
| Ctrl+Space | Accept an autosuggestion |
| Ctrl+S | Unbound; terminal flow control is disabled when stdin is a terminal |
| Ctrl+T | FZF file selection |
| Alt+C | FZF directory selection |
| Ctrl+R | FZF history binding, which later integrations such as Atuin may override |

FZF uses a Catppuccin-style palette, a preview pane, and per-widget labels. Inside FZF, `Ctrl+/` cycles preview placement/visibility and `Ctrl+U` / `Ctrl+D` move by half a page. When a clipboard tool is found, Enter and double-click also copy the selected entries using FZF's selection file before accepting. Clipboard preference is `wl-copy`, then `xclip`, then `xsel`.

## History and shell options

| Setting | Value / effect |
|---------|----------------|
| `HISTFILE` | `~/.zsh_history` |
| `HISTSIZE`, `SAVEHIST` | 50,000 entries each |
| `EXTENDED_HISTORY` | Record timestamps and elapsed time |
| `HIST_IGNORE_ALL_DUPS` | Remove older duplicate entries |
| `HIST_IGNORE_SPACE` | Ignore commands starting with a space |
| `HIST_FIND_NO_DUPS`, `HIST_SAVE_NO_DUPS` | Skip duplicates in history searches and when saving |
| `HIST_VERIFY` | Allow review of history expansion before execution |
| `AUTO_CD`, `AUTO_PUSHD`, `PUSHD_IGNORE_DUPS` | Directory navigation and stack behavior |
| `MENU_COMPLETE` | Insert the first completion match |
| `CORRECT`, `INTERACTIVE_COMMENTS` | Command correction and interactive comments |

The modules do not explicitly enable `SHARE_HISTORY`, `HIST_EXPIRE_DUPS_FIRST`, or `AUTO_MENU`; their effective state can depend on inherited configuration. Cross-terminal history sync is not guaranteed by these modules. Atuin is initialized when installed; its bindings and sync behavior also depend on its own configuration and account setup.

## Plugin and integration loading

After the CachyOS base and the custom modules, `80-plugins.zsh` loads:

1. Pkgfile's command-not-found handler.
2. FZF keybindings and, if readable, its completion script.
3. `zsh-autosuggestions`.
4. Starship.
5. Atuin's environment file, if readable, then Atuin initialization when available.
6. `zsh-patina` activation when available.
7. Bun completion, if present; it is also sourced in `70-integrations.zsh`.

The repository does not explicitly load Oh My Zsh's `git` or `extract` plugins, `zsh-syntax-highlighting`, or `zsh-history-substring-search`. Anything provided by the system-wide CachyOS file depends on that installed file. Later integrations can override earlier keybindings.

## Environment and PATH

Existing directories from this list are prepended to PATH in order, with duplicates removed:

```text
$JAVA_HOME/bin (when JAVA_HOME is set)
$HOME/bin
$HOME/.local/bin
$HOME/.local/share/fnm
$HOME/.cargo/bin
$HOME/.bun/bin
$HOME/go/bin
$HOME/.config/herd-lite/bin
$HOME/.local/share/pnpm/bin
$HOME/.opencode/bin
```

Integrations initialized later may also modify PATH. The local completion directory `~/.local/share/zsh/site-functions` is added to `fpath` when present.

| Variable | Value |
|----------|-------|
| `DOCKER_HOST` | `unix:///run/user/${UID}/podman/podman.sock` |
| `PNPM_HOME` | `$HOME/.local/share/pnpm` |
| `EDITOR` | `fresh` |
| `MICRO_TRUECOLOR` | `1` |
| `BAT_THEME` | `Catppuccin Mocha` |

The configuration unsets `PROMPT_COMMAND` and initializes `dircolors` when available. It does not set `PHP_INI_SCAN_DIR` or start a Podman socket.

## Command notifications

Commands lasting at least three seconds trigger a success or failure notification, including duration and working directory. Exit status 130 suppresses the notification. In Kitty, the hook prefers `kitten notify` when available; otherwise it uses `notify-send`. If neither backend is available, no notification is sent.
