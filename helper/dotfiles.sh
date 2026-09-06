#!/usr/bin/env bash

BACKUP_DOTFILES=(
  .autostart .aliases
  .config .colorscheme
  .fonts .local .scripts
  .termux .tmux.conf
  .zshrc .oh-my-zsh
)

DOTFILES=(
  .autostart .aliases
  .config .colorscheme
  .fonts .local .scripts
  .termux .tmux.conf
  .zshrc
)


function dotFiles() {

  setCursor off

  echo -e "\n‏‏‎‏‏‎ ‎ ‎‏‏‎  ‎📦 Getting Information Dotfiles"
  sleep 1s

  echo -e "
    ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
    ┃             Information Dotfiles              ┃
    ┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┫
    ┃        Folder Name            Folder Size     ┃
    ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛"

  for DOTFILE in "${DOTFILES[@]}"; do

    FOLDER_SIZE=$(du -s -h $DOTFILE 2>/dev/null | awk '{print $1}')
    printf  "    ┃        ${COLOR_SUCCESS}%-12s${COLOR_BASED}              ${COLOR_WARNING}%5s${COLOR_BASED}        ┃\n" $DOTFILE $FOLDER_SIZE
    echo -e "    ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛"

  done

  setCursor on

}

function cleanOldBackups() {
  local is_silent="$1"
  [[ "$is_silent" != "silent" ]] && start_animation "    Cleaning previous dotfiles backups ..."

  for BACKUP_DOTFILE in "${BACKUP_DOTFILES[@]}"; do
    rm -rf "${HOME}/${BACKUP_DOTFILE}".*.backup 2>/dev/null
  done
  rm -rf "${HOME}/motd" 2>/dev/null

  [[ "$is_silent" != "silent" ]] && stop_animation 0
}

function backupDotFiles() {

  echo -e ""
  echo -e "‏‏‎‏‏‎ ‎ ‎‏‏‎  ‎📦 Backup Dotfiles\n"

  # Clean old backups first so they do not multiply indefinitely
  cleanOldBackups "silent"

  local TIMESTAMP="$(date +%Y.%m.%d-%H.%M.%S)"

  for BACKUP_DOTFILE in "${BACKUP_DOTFILES[@]}"; do

    if [[ -d "$HOME/$BACKUP_DOTFILE" || -f "$HOME/$BACKUP_DOTFILE" ]]; then

      start_animation "    Backup ${COLOR_WARNING}'${COLOR_SUCCESS}${BACKUP_DOTFILE}${COLOR_WARNING}'${COLOR_BASED} ..."

      local BACKUP_FILE="${HOME}/${BACKUP_DOTFILE}.${TIMESTAMP}.backup"
      cp -R "${HOME}/${BACKUP_DOTFILE}" "${BACKUP_FILE}" 2>/dev/null

      if [[ -d "${BACKUP_FILE}" || -f "${BACKUP_FILE}" ]]; then
        stop_animation 0
      else
        stop_animation 1
      fi

    else

      stop_animation 0

    fi

  done

}

function installDotFiles() {

  setCursor off

  echo -e "\n‏‏‎‏‏‎ ‎ ‎‏‏‎  ‎📦 Installing Dotfiles\n"

  for DOTFILE in "${DOTFILES[@]}"; do

    start_animation "    Installing ${COLOR_WARNING}'${COLOR_SUCCESS}${DOTFILE}${COLOR_WARNING}'${COLOR_BASED} ..."

    if [[ -d "$DOTFILE" ]]; then

      mkdir -p "${HOME}/${DOTFILE}"
      cp -R "$DOTFILE"/* "${HOME}/${DOTFILE}/" 2>/dev/null

      if [[ "${DOTFILE}" == ".termux" ]]; then
        local LATEST_TERMUX_BACKUP
        LATEST_TERMUX_BACKUP=$(ls -d -t "${HOME}"/.termux.*.backup 2>/dev/null | head -1)
        if [[ -n "${LATEST_TERMUX_BACKUP}" && -f "${LATEST_TERMUX_BACKUP}/termux.properties" && ! -f "${HOME}/.termux/termux.properties" ]]; then
          cp -p "${LATEST_TERMUX_BACKUP}/termux.properties" "${HOME}/.termux/termux.properties" 2>/dev/null
        fi
        termux-reload-settings 2>/dev/null
      fi

      stop_animation $?

    else

      cp -f "$DOTFILE" "${HOME}/" 2>/dev/null
      stop_animation $?

    fi

  done

  chmod +x "${HOME}/.local/bin/"* 2> /dev/null

  setCursor on

}

function installDotFilesWithBackup() {

  setCursor on
  echo ""

  while :; do
    read -p "    Backup existing dotfiles before applying? [y/N] " ANSWER

    case "$ANSWER" in
      y | Y | yes | YES )
        backupDotFiles
        break
        ;;
      n | N | no | NO | "" )
        stat "INFO" "Info" "Skipping backup — applying and merging dotfiles safely."
        break
        ;;
      * )
        stat "ERROR" "Warning" "Unknown '${ANSWER}' — type 'y' to backup or 'n' to skip."
        ;;
    esac
  done

  installDotFiles

}
