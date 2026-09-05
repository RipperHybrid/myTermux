#!/usr/bin/env bash
# Author: AshBorn

function cleanupMusic() {
  stat "RUN" "Warning" "Purging Music Player aliases and configs..."

  sed -i '/#Music/,/^$/d' ~/.aliases 2>/dev/null
  sed -i '/#mpd/,/^$/d' ~/.aliases 2>/dev/null
  sed -i '/#ncmpcpp/,/^$/d' ~/.aliases 2>/dev/null

  sed -i '/function fetchMusic() {/,/^}/d' ~/.scripts/system/fetch.sh 2>/dev/null
  sed -i '/music )/,/;;/d' ~/.scripts/system/fetch.sh 2>/dev/null

  rm -rf ~/.config/mpd ~/.config/ncmpcpp ~/.local/bin/music
}

function cleanupToys() {
  stat "RUN" "Warning" "Purging Terminal Toys..."

  sed -i '/#Color Toys/,/^$/d' ~/.aliases 2>/dev/null

  rm -rf ~/.scripts/toys
}

function cleanupNvChad() {
  stat "RUN" "Warning" "Purging NvChad/Neovim configuration..."

  sed -i '/#neovim/,/^$/d' ~/.aliases 2>/dev/null

  rm -rf ~/NvChad ~/.config/nvim ~/.local/share/nvim ~/.cache/nvim
}

function cleanupExtraTools() {
  stat "RUN" "Warning" "Purging Extra CLI Tools and JS scripts..."

  rm -rf ~/.scripts/js ~/.local/bin/macfinder* ~/.local/bin/ytdl ~/.local/bin/gitssh ~/.local/bin/ipconfig

  sed -i '/alias repocek/d' ~/.aliases 2>/dev/null
  sed -i '/alias convi/d' ~/.aliases 2>/dev/null
}