#!/usr/bin/env bash

function utility() {

  cp ~/.fonts/JetBrains\ Mono\ Medium\ Nerd\ Font\ Complete.ttf $PREFIX/share/fonts/TTF/ 2> /dev/null
  
  chsh -s zsh

  if [[ -f $PREFIX/etc/motd ]]; then
    mkdir -p "$HOME/.config/mytermux"
    mv "$PREFIX/etc/motd" "$HOME/.config/mytermux/motd.backup" 2>/dev/null
    rm -rf "$HOME/motd" 2>/dev/null
  fi

}
