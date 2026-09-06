#!/usr/bin/env bash
# Author: AshBorn

MYTERMUX_DIR="$(cd "$(dirname "$0")" && pwd)"

HELPERS=(
  colors animation banner package switchcase cleanup
  dotfiles clone themes nvchad utility
  stat signal screen cursor finish
)

for HELPER in ${HELPERS[@]}; do
  source ${MYTERMUX_DIR}/helper/${HELPER}.sh
done

DOTFILE_FILES=(
  .autostart .aliases .tmux.conf .zshrc .p10k.zsh
)

DOTFILE_DIRS=(
  .colorscheme .fonts .scripts .termux
  .oh-my-zsh .tmux-themepack
)

CONFIG_DIRS=(
  mpd ncmpcpp neofetch lf mytermux
)

LOCAL_BIN_FILES=(
  music rxfetch ytdlp ytdl dlv gitssh ipconfig mytermux-update
)

BACKUP_ITEMS=(
  .autostart .aliases .config .colorscheme
  .fonts .local .scripts .termux
  .tmux.conf .zshrc .oh-my-zsh
)

function confirmUninstall() {

  echo -e "\n    This will remove all files installed by myTermux from this device.\n"

  while :; do
    read -p "    Continue? [y/N] " ANSWER

    case "$ANSWER" in
      y | Y ) break ;;
      n | N )
        stat "INFO" "Warning" "Uninstall aborted."
        exit 0
      ;;
      "" )
        echo ""
        stat "INFO" "Warning" "No answer given — type 'y' to continue or 'n' to abort."
        echo ""
      ;;
      * )
        echo ""
        stat "ERROR" "Warning" "Unknown '${ANSWER}' — type 'y' to continue or 'n' to abort."
        echo ""
      ;;
    esac
  done

}

function uninstallDotFiles() {

  stat "RUN" "Warning" "Removing myTermux dotfiles..."

  for FILE in "${DOTFILE_FILES[@]}"; do
    rm -rf "${HOME}/${FILE}"
  done

  for DIR in "${DOTFILE_DIRS[@]}"; do
    rm -rf "${HOME}/${DIR}"
  done

  for DIR in "${CONFIG_DIRS[@]}"; do
    rm -rf "${HOME}/.config/${DIR}"
  done

  for FILE in "${LOCAL_BIN_FILES[@]}"; do
    rm -rf "${HOME}/.local/bin/${FILE}"
  done

  chsh -s bash 2> /dev/null

  stat "RESULT" "Success" "Dotfiles removed and shell restored to bash."

}

function removePackages() {

  stat "RUN" "Warning" "Uninstalling packages..."

  chsh -s bash 2> /dev/null

  local PACKAGE
  local TO_REMOVE=()

  for PACKAGE in "${PACKAGES[@]}" mpd mpc; do
    if dpkg-query -W -f='${Status}' "${PACKAGE}" 2> /dev/null | grep -q 'install ok installed'; then
      TO_REMOVE+=("${PACKAGE}")
    fi
  done

  if [[ ${#TO_REMOVE[@]} -eq 0 ]]; then
    stat "INFO" "Info" "None of the listed packages are installed. Nothing to remove."
    return 0
  fi

  if pkg uninstall -y "${TO_REMOVE[@]}"; then
    stat "RESULT" "Success" "Packages removed."
    return 0
  fi

  local RETRY=()
  for PACKAGE in "${TO_REMOVE[@]}"; do
    [[ "${PACKAGE}" != "curl" ]] && RETRY+=("${PACKAGE}")
  done

  if [[ ${#RETRY[@]} -gt 0 && ${#RETRY[@]} -lt ${#TO_REMOVE[@]} ]] && pkg uninstall -y "${RETRY[@]}"; then
    stat "RESULT" "Success" "Packages removed. Kept curl because termux-tools (needed by bash) depends on it."
    return 0
  fi

  stat "RESULT" "Danger" "Some packages could not be removed. See the errors above."

}

function restoreBackups() {

  stat "RUN" "Warning" "Restoring pre-install backups..."

  for ITEM in "${BACKUP_ITEMS[@]}"; do

    LATEST=$(ls -d "${HOME}/${ITEM}."*.backup 2> /dev/null | sort | tail -n 1)

    if [ -n "${LATEST}" ]; then
      cp -rf "${LATEST}" "${HOME}/${ITEM}"
      stat "RESTORE" "Success" "Restored '${ITEM}' from '$(basename ${LATEST})'."
    fi

  done

  stat "RESULT" "Success" "Backup restore finished."

}

function main() {

  trap 'handleInterruptByUser "Interrupt by User"' 2

  clear
  banner
  confirmUninstall

  echo ""

  cleanupMusic

  echo ""

  cleanupToys

  echo ""

  cleanupExtraTools

  echo ""

  cleanupNvChad

  echo ""

  uninstallDotFiles

  echo ""
  read -p "    Remove installed packages (bat, curl, eza, neovim, zsh, ...)? [y/N] " ANSWER
  case "$ANSWER" in
    y | Y ) removePackages ;;
    * )     stat "INFO" "Warning" "Keeping installed packages." ;;
  esac

  echo ""
  read -p "    Restore pre-install backups if any exist? [y/N] " ANSWER
  case "$ANSWER" in
    y | Y ) restoreBackups ;;
    * )     stat "INFO" "Warning" "Keeping backups in \$HOME." ;;
  esac

  echo ""
  termux-reload-settings 2> /dev/null

  echo ""
  if [[ "${MYTERMUX_DIR}" == "${HOME}" ]]; then
    stat "INFO" "Warning" "Refusing to remove $HOME. Delete the myTermux folder manually."
  elif [[ -d "${MYTERMUX_DIR}/helper" ]]; then
    stat "RUN" "Warning" "Removing the myTermux folder itself..."
    cd "${HOME}" 2> /dev/null
    rm -rf "${MYTERMUX_DIR}"
    stat "RESULT" "Success" "myTermux folder removed."
  fi

  echo -e "\n    ✅ Uninstall finished. Restart Termux to complete.\n"

}

main