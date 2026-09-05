# Installation

This guide covers installing **myTermux** from scratch and explains every prompt the installer asks.

Every step asks **[Y/n]** — type `y` to install, or `n` to skip an optional step. A bare `Enter` is **not** an answer: the installer re-asks the same question until you type `y` or `n`. Steps are either **optional** or **required**:

- **Optional** — answering `n` prints `Skipping ...`, removes that component's files if the Dotfiles step already placed them, and drops its aliases from `~/.aliases`. Aliases that slip through are filtered out at every shell start, and `txhelp` only lists commands that are actually installed. The installer then continues to the next prompt.
- **Required** — marked `(required)` in the prompt. Core Packages, Dotfiles, Clone Repositories, and Utility Settings **cannot be skipped**: the first `n` warns you that the step is required and asks again; a second `n` aborts the installer with **exit 1**.

## Prerequisites

- **Termux from F-Droid** — the Play Store build is no longer maintained. Install it from [f-droid.org/en/packages/com.termux](https://f-droid.org/en/packages/com.termux/).
- **Termux:API app** — install from [f-droid.org/en/packages/com.termux.api](https://f-droid.org/en/packages/com.termux.api/). myTermux calls Termux:API commands (`termux-battery-status`, `termux-notification`, `termux-toast`).

## 1. Update Termux

```bash
pkg update && pkg upgrade
```

## 2. Install git and bc

`git` clones the repository, `bc` is used to calculate download sizes inside the installer.

```bash
pkg i -y git bc
```

## 3. Clone the repository

```bash
git clone --depth=1 https://github.com/RipperHybrid/myTermux.git
cd myTermux
```

The installer must run **from inside the repository folder** (it loads its helper scripts from `./helper/`).

## 4. Set the terminal size

```bash
export COLUMNS LINES
```

The installer refuses to run on a small screen — it needs at least **101 columns × 39 rows**. If you see `Please Zoom Out`, zoom out of the Termux app (and re-run `export COLUMNS LINES` if needed), then run the installer again.

## 5. Run the installer

```bash
./install.sh
```

The installer walks through the following steps. For every prompt: type `y` to install. `n` skips the **optional** steps (the installer continues). For **required** steps (shown with `(required)` next to `[Y/n]`) the first `n` asks you to confirm, and only a second `n` aborts the installer. A bare `Enter` re-asks the question.

| # | Prompt | Required? | `y` (accept) | `n` (skip) |
|---|--------|-----------|---------------|------------|
| 1 | **Core Packages** | ✅ required | Installs `bat clang curl eza fzf git neofetch neovim openssh termux-api tmux zsh` — packages already installed and up to date are skipped, only missing or outdated ones are installed | ⚠️ warns it's required, second `n` aborts |
| 2 | **Dotfiles** | ✅ required | Backs up your current files, then copies the custom configs (`.aliases`, `.zshrc`, `.autostart`, `.config`, `.colorscheme`, `.fonts`, `.local`, `.scripts`, `.termux`, `.tmux.conf`) into `$HOME` | ⚠️ warns it's required, second `n` aborts |
| 3 | **Music Player** | optional | Installs `mpd` and `mpc` for background terminal audio | Purges the music aliases, mpd/ncmpcpp configs and `~/.local/bin/music` that the Dotfiles step placed |
| 4 | **Terminal Color Toys** | optional | Keeps the toys shipped with the dotfiles (`~/.scripts/toys`: pipes, pacman, rain, ...) | Removes `~/.scripts/toys` and its alias section |
| 5 | **Extra CLI Tools** | optional | Keeps the extra tools shipped with the dotfiles (`ytdl`, `gitssh`, `ipconfig`, `macfinder`, the JS repo checker) | Removes them plus the `repocek` / `convi` aliases |
| 6 | **Clone Repositories** | ✅ required | Clones oh-my-zsh, the ZSH plugins (`zsh-syntax-highlighting`, `zsh-autosuggestions`, `zsh-fzf-history-search`) and `tmux-themepack` into `~/.oh-my-zsh` / `~/.tmux-themepack` | ⚠️ warns it's required, second `n` aborts |
| 7 | **ZSH Themes** | optional | Copies the custom prompt themes into `~/.oh-my-zsh/custom/themes` | Default prompt only |
| 8 | **NvChad** | optional | Removes old Neovim configs, clones the NvChad starter into `~/.config/nvim` and installs its plugins via a silent lazy.nvim sync (progress animation; if the sync fails, the tail of its log is shown) | Purges Neovim/NvChad configs and the `#neovim` aliases |
| 9 | **Utility Settings** | ✅ required | Installs the JetBrains Mono Nerd Font into Termux, switches the default shell to `zsh` (`chsh -s zsh`) and backs up the login `motd` | ⚠️ warns it's required, second `n` aborts |
| 10 | **Set prompt username** | optional | Asks for a name that themes like `ma`, `powerline` and `status` show in place of the auto-detected `user@host` — stored in `~/.config/mytermux/user.log`, changeable anytime with `setuser [name]` | Nothing is shown in the prompt until you set a name |
| 11 | **Remove installer folder** | optional | Asks whether to delete the cloned `myTermux` folder from `$HOME`, then asks for a second `y` confirmation before deleting it | Keeps the folder, e.g. if you want to re-run `./uninstall.sh` without cloning again |

Anything that isn't `y` or `n` — including a bare `Enter` — re-asks the same question. Required steps show `(required)` in the prompt and need a second `n` before the installer aborts. They exist because everything else depends on them — skipping Core Packages leaves no binaries, skipping Dotfiles applies nothing, skipping Clone Repositories breaks the `zsh` setup (`~/.zshrc` sources oh-my-zsh), and skipping Utility Settings never switches you to `zsh`.

### What happens to your existing dotfiles?

Right after you answer `y` to the **Dotfiles** step, the installer automatically moves any existing copy of those files/folders out of the way:

```text
~/.aliases        -> ~/.aliases.2026.09.04-10.30.00.backup
~/.zshrc          -> ~/.zshrc.2026.09.04-10.30.00.backup
~/.config         -> ~/.config.2026.09.04-10.30.00.backup
... (and the rest)
```

The backup only happens when you accept the step, so declining (which aborts, since Dotfiles is required) never touches your existing files. To go back to your old setup after an install, restore the backups (`mv ~/.aliases.2026.*.backup ~/.aliases`, etc.) or run the uninstaller.

## 6. Restart Termux

When the installer finishes it asks whether to remove the cloned `myTermux` folder (step 11), then requires a second `y` confirmation before deleting it. It then fires a notification + toast (`myTermux v0.7.0 has been installed`). Fully restart the Termux app so `zsh` and the new settings take effect, then verify with:

```bash
neo          # neofetch
chcolor      # colorscheme manager
chfont       # font manager (local fonts)
chzsh        # zsh theme manager
refresh      # reload ~/.zshrc
```

## Updating

New releases apply **in place** — no uninstall first. After the first install, run:

```bash
txupdate          # same as: mytermux-update
```

`mytermux-update` is installed to `~/.local/bin` by the Dotfiles step (it's on your `PATH` via `~/.zshrc`), so it survives the installer's folder cleanup and stays available for every later release. It re-clones the latest release into `~/myTermux` and runs the installer exactly as on a fresh install:

- every step is re-prompted (`y`/`n`) — packages that are already installed and up to date are skipped automatically,
- the Dotfiles step first moves your current dotfiles (`~/.aliases`, `~/.zshrc`, `~/.termux`, `~/.local`, ...) into `~.<name>.<timestamp>.backup` copies, then applies the new files — pull anything you hand-edited (like `default-working-directory`) back out of those backups,
- when it finishes it asks to delete the freshly cloned `~/myTermux` again and requires a second `y` confirmation before deletion.

Manual route (same result):

```bash
git clone --depth=1 https://github.com/RipperHybrid/myTermux.git
cd myTermux
export COLUMNS LINES
./install.sh
```

## Uninstall

If the installer's folder cleanup already deleted `~/myTermux` (the default), fetch it once more first:

```bash
git clone --depth=1 https://github.com/RipperHybrid/myTermux.git
cd myTermux
./uninstall.sh
```

(If you kept the folder after installing, `cd myTermux && ./uninstall.sh` or just run `txuninstall`.)

The uninstaller asks (each defaults to **no**):

1. `Continue? [y/N]` — confirm removal of all myTermux files
2. `Remove installed packages ...? [y/N]` — also uninstall the packages (`bat`, `curl`, `eza`, `neovim`, `zsh`, `mpd`, `mpc`, ...). Every package is checked first, so anything that was never installed (e.g. `mpd`/`mpc` if you skipped the Music Player step) is skipped instead of making apt complain. `termux-tools` is left alone — removing it would break `bash`, which depends on it. `curl` is kept too when apt can't remove it without pulling in `termux-tools`: the uninstaller retries without it and reports that curl stayed.
3. `Restore pre-install backups ...? [y/N]` — put back the newest `*.backup` files created during installation

When it finishes, the `myTermux` folder itself is deleted and you are left in `$HOME`. Then restart Termux.
