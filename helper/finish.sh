#!/usr/bin/env bash

MYTERMUX_VERSION="0.7.0"

function alertFinish() {

  echo -e "‏‏‎‏‏‎\n    ‎‏‏‎⚠️ Installation Finish, but you need restart Termux to clear setup\n"

}

function alertNotification() {

  if command -v termux-notification >/dev/null 2>&1; then
    termux-notification -t "myTermux v${MYTERMUX_VERSION} has been installed"
  fi

}

function alertTorch() {

  if command -v termux-toast >/dev/null 2>&1; then
    termux-toast -b "#A8D7FE" -c "#373E4D" -g middle "myTermux v${MYTERMUX_VERSION} has been installed"
  fi

}


function mainAlert() {

  alertFinish
  alertNotification
  alertTorch

}
