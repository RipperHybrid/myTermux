<h1 align="center">myTermux</h1>

<p align="center">A personalized, modular, and feature-rich terminal environment for Termux on Android</p>

<p align="center">
  <a href="./LICENSE"><img src="https://img.shields.io/badge/license-GPL-red.svg"></a>
</p>

## 🚀 Quick Installation

> **Important:**
> - Install **Termux from [F-Droid](https://f-droid.org/en/packages/com.termux/)** (the Play Store version is deprecated and unmaintained).
> - Install **[Termux:API](https://f-droid.org/en/packages/com.termux.api/)** for battery stats, hardware info, and notifications.

### 1. Update Packages
Updates repository mirrors and upgrades existing packages to their newest versions:
```bash
pkg update && pkg upgrade -y
```

### 2. Install Required Setup Dependencies
Installs `git` (to download the repository) and `bc` (to calculate download/package sizes):
```bash
pkg i -y git bc
```

### 3. Clone & Run the Installer
Downloads the setup and starts the interactive configuration menu:
```bash
cd
git clone --depth=1 https://github.com/RipperHybrid/myTermux.git
cd myTermux
export COLUMNS LINES
./install.sh
```

> 📖 **Step-by-Step Guide:** See **[installation.md](installation.md)** for a full prompt-by-prompt walkthrough.
>
> 📱 **Screen Size:** The installer needs at least **101 columns × 39 rows**. If your screen is smaller, an interactive screen resizer will show live dimensions and wait for you to pinch/zoom out.
>
> 🔄 **Updating:** Run `txupdate` anytime to fetch the latest release and update in-place.
>
> 🗑️ **Uninstalling:** Run `txuninstall` (or `./uninstall.sh`) to cleanly remove myTermux and restore your previous backups.

---

## ✨ Features

- 🎨 **Colorscheme Manager** — switch between terminal color themes live with `chcolor`
- 🔤 **Font Manager** — `chfont` lists fonts in `~/.fonts` and previews them live before applying; answering `n` or pressing `Ctrl+C` restores your previous font automatically
- 💻 **ZSH Theme Manager** — live switcher (`chzsh`) for 12 custom prompt styles (ma, powerline, pure, status, etc.)
- ✏️ **Custom Prompt Username** — `setuser [name]` sets a custom display name in prompt themes in place of `user@host`
- ⚡ **Dynamic Fetch Display** — automatically starts with your preferred fetch screen (`neo` / `rxfetch`), remembered each time you run either
- 🔎 **Interactive Missing-Command Installer** — typing an unknown command provides an interactive menu of matching packages with instant installation
- 🕐 **History Management** — toggle history recording with `histoff` / `histon`
- 🔮 **Fish-Style Autosuggestions** — fast inline suggestions as you type; accept with `→` or `Ctrl+F`
- 📺 **Universal Media Downloader** — `ytdl` / `dlv` smart wrapper supporting YouTube, Pinterest, Instagram, TikTok, Twitter/X, Reddit, etc. (`ytdl <url>` or `ytdl best|mp4|webm|mp3|audio|format <link>`)
- 📊 **System Diagnostics** — `fetch`, `disk`, and `battery` for storage, power, and hardware info
- 🛠️ **Management Commands** — `txhelp` (command list), `txupdate` (in-place updater), `txclean` (backup cleaner), `txuninstall` (complete remover)

---

## 📸 Screenshots

See full screenshots, animations, font previews, and colorschemes in **[screenshots.md](screenshots.md)**.

---

## ⌨️ Command Reference

### 🎨 Customization & Management
| Command | Description |
| :--- | :--- |
| `chcolor` | Switch terminal colorschemes live with interactive preview |
| `chfont` | Switch terminal fonts with live preview before applying |
| `chzsh` | Change ZSH prompt themes live |
| `setuser [name]` | Set custom prompt username in themes (e.g. `setuser Neo`) |
| `txhelp` | Print the full interactive list of all available commands |
| `txupdate` | Clone latest release and update myTermux in-place |
| `txclean` | Clean all timestamped backups (`~/.<file>.<date>.backup`) |
| `txuninstall` | Run the uninstaller to remove myTermux and restore backups |
| `fontused` | View currently active font name |
| `colorused` | View currently active colorscheme |
| `zshused` | View currently active ZSH theme |
| `fetchused` | View current default fetch tool (`neo` or `rxfetch`) |

### ⚡ System Information & Diagnostics
| Command | Description |
| :--- | :--- |
| `rxfetch` | Run ASCII system fetch (sets default startup to rxfetch) |
| `neo` / `neofetch` | Run Neofetch system info (sets default startup to neofetch) |
| `neodebug [opt]` | Run neofetch logo debugger |
| `disk` | Display disk and storage partition usage |
| `battery` | Display real-time battery status via Termux:API |
| `fetch` | Custom system fetch (music, battery, or storage) |

### 🔒 History Management
| Command | Description |
| :--- | :--- |
| `histoff` | Disable history recording and wipe existing history files |
| `histon` | Re-enable shell history tracking |

### 📦 Package & Everyday Shortcuts
| Command | Description |
| :--- | :--- |
| `pacupg` / `pacupd` | `pkg upgrade` / `pkg update` shortcuts |
| `pacupgupd` | Update and upgrade packages in one command (`pkg update && pkg upgrade`) |
| `refresh` | Reload `~/.zshrc` without restarting the session |
| `unsource` | Restart login shell session |
| `c` / `q` | `clear` / `exit` terminal shortcuts |
| `preview <file>` | Fuzzy find (`fzf`) with live syntax-highlighted preview (`bat`) |
| `ls` / `la` / `lt` / `lta` | Modern directory listings and tree views powered by `eza` |
| `bat` / `cat <file>` | Syntax-highlighted file viewing |
| `sd` / `dl` / `ms` / `ss` / `ds` | Quick jumps to `/sdcard`, `Download`, `Movies`, `Screenshots`, `Documents` |
| `pf` / `archives` | Jump to `$PREFIX` / apt package cache archives |
| `largefile` | Find and list the 20 largest files in current directory |

### 🛠️ CLI Tools, Network & Media
| Command | Description |
| :--- | :--- |
| `ytdl` / `dlv <mode> <url>` | Universal media downloader for YouTube, Pinterest, Instagram, TikTok, etc. (`best`, `mp4`, `mp3`, `audio`, `webm`, `format`, `pin`) |
| `gitssh` | Generate SSH key and configure Git authentication |
| `ipconfig` | Quick network interfaces and IP address info |
| `macfinder [mac]` | Search and identify MAC address vendor details |
| `repocek` | JavaScript repository dependency checker |
| `convi <in> <out>` | Convert and compress videos using ffmpeg (`-crf 25`) |
| `myip` / `myipwifi` / `myipvpn` | Show public and local IP addresses by interface |

### 🎵 Music Player (MPD & NCMPCPP)
| Command | Description |
| :--- | :--- |
| `m` / `music` | Interactive terminal music player wrapper |
| `n` / `ncmpcpp` | Launch NCMPCPP music player client |
| `mkill` | Terminate background MPD music daemon |

### 🎮 Terminal Color Toys
| Command | Description |
| :--- | :--- |
| `pipes` / `pipes1` / `pipes2` / `pipesx` | Animated terminal pipe screensavers |
| `pacman` | ASCII Pacman animation |
| `rains` | Matrix digital rain effect |
| `dna` | Animated rotating DNA strand |
| `spacey` | ASCII flying starfield effect |
| `ghost` / `jfetch` | Fun ASCII visualizers |
| `colortest` / `colorbars` / `bloks` / `colorview` | Terminal 256-color palette testers |

### ⚙️ Quick Configuration Editors (Neovim)
| Command | Description |
| :--- | :--- |
| `aliasconf` | Edit aliases in `~/.aliases` |
| `zshconf` | Edit ZSH configuration in `~/.zshrc` |
| `termconf` | Edit Termux properties in `~/.termux/termux.properties` |
| `neoconf` / `rxconf` | Edit Neofetch / rxfetch configuration files |
| `mpdconf` / `ncmconf` | Edit MPD / NCMPCPP music configurations |
| `nviminit` | Edit Neovim main configuration (`~/.config/nvim/init.lua`) |

## Credits

- [mayTermux](https://github.com/mayTermux) Original myTermux repository this fork is based on
- [siduck](https://github.com/siduck) Neovim Setup (NvChad), Colorscheme (onedark-siduck)
- [owl4ce](https://github.com/owl4ce) First time getting to know dotfiles
- [adi1090x](https://github.com/adi1090x) Termux Setup
- [bandithijo](https://github.com/bandithijo) Awesome screenshot like MacOS using imagemagick script
- [lwotcynna](https://github.com/lwotcynna) Contributor
- [nekonako](https://github.com/nekonako) Colorscheme nekonako-djancoeg, nekonako-hue, nekonako-om-mar
- [Dotfiles Indonesia](https://t.me/dotfiles_id)
- [Vim Indonesia](https://t.me/VimID)
- [Bashid.org](https://t.me/bashidorg)

## Colorscheme

- [catppuccin/termux](https://github.com/catppuccin/termux)
