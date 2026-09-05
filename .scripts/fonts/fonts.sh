#!/usr/bin/env bash

LIBRARYS=(
  animation signal cursor colors stat
)

LIBRARY_PATH="${HOME}/.scripts/library"

for LIBRARY in ${LIBRARYS[@]}; do
  source ${LIBRARY_PATH}/${LIBRARY}.sh
done

FONTS_DIR="${HOME}/.fonts"
FONT_USED_PATH="${HOME}/.config/mytermux/fonts"
FONT_USED_FILE_NAME="used.log"
FONT_USED="$(cat ${FONT_USED_PATH}/${FONT_USED_FILE_NAME} 2>/dev/null)"

TERMUX_CONF_PATH="${HOME}/.termux"
TERMUX_FONT_FILE="font.ttf"
TERMUX_CACHE_PATH="/data/data/com.termux/cache"
FONT_BACKUP_FILE="${TERMUX_CACHE_PATH}/font_backup.ttf"
PREVIEW_MARKER="${TERMUX_CACHE_PATH}/.font_preview_active"

mkdir -p "${FONTS_DIR}" "${FONT_USED_PATH}" "${TERMUX_CONF_PATH}" "${TERMUX_CACHE_PATH}"

PREVIEW_ACTIVE=false

function banner() {
  echo -e "${COLOR_SKY} _______
(_______)          _
 _____ ___  ____ _| |_  ___
|  ___) _ \\|  _ (_   _)/___)
| |  | |_| | | | || |_|___ |
|_|   \\___/|_| |_| \\__|___/ 
${COLOR_BASED}"
}

function apply_font() {
  local font_file="$1"
  local font_name="$2"

  cp -f "${font_file}" "${TERMUX_CONF_PATH}/${TERMUX_FONT_FILE}"
  termux-reload-settings
  echo "${font_name}" > "${FONT_USED_PATH}/${FONT_USED_FILE_NAME}"
}

function is_valid_font() {
  local sig_file="${TERMUX_CACHE_PATH}/.font_sig_check"

  printf '\x00\x01\x00\x00' > "${sig_file}"
  cmp -s -n 4 "${sig_file}" "$1" && return 0

  printf 'OTTO' > "${sig_file}"
  cmp -s -n 4 "${sig_file}" "$1"
}

function restore_font_from_backup() {
  if [[ -f "${FONT_BACKUP_FILE}" ]]; then
    mv -f "${FONT_BACKUP_FILE}" "${TERMUX_CONF_PATH}/${TERMUX_FONT_FILE}"
  else
    rm -f "${TERMUX_CONF_PATH}/${TERMUX_FONT_FILE}"
  fi
  termux-reload-settings
}

function preview_font_live() {
  local target_ttf="$1"

  if [[ ! -f "${target_ttf}" ]] || ! is_valid_font "${target_ttf}"; then
    stat "ERROR" "Danger" "$(basename "${target_ttf}") is not a valid font file."
    return 2
  fi

  clear
  echo -e "\n${COLOR_WARNING}Live Preview Notice${COLOR_BASED}"
  echo -e "The terminal font will temporarily switch for the whole Termux app,"
  echo -e "including other open sessions like ${COLOR_SUCCESS}nvim${COLOR_BASED}."
  echo -e "Answering ${COLOR_SUCCESS}n${COLOR_BASED} or pressing ${COLOR_WARNING}Ctrl-C${COLOR_BASED}"
  echo -e "restores your previous font automatically."
  echo -e "If the preview font looks unreadable, type ${COLOR_SUCCESS}n${COLOR_BASED} and press Enter.\n"

  if [[ -f "${TERMUX_CONF_PATH}/${TERMUX_FONT_FILE}" ]]; then
    if ! cp -f "${TERMUX_CONF_PATH}/${TERMUX_FONT_FILE}" "${FONT_BACKUP_FILE}" 2>/dev/null; then
      stat "ERROR" "Danger" "Could not back up the current font to ${TERMUX_CACHE_PATH}. Aborting preview."
      return 2
    fi
  fi

  if ! : > "${PREVIEW_MARKER}" 2>/dev/null; then
    stat "ERROR" "Danger" "Cannot write preview marker to ${TERMUX_CACHE_PATH}. Aborting preview."
    rm -f "${FONT_BACKUP_FILE}"
    return 2
  fi

  PREVIEW_ACTIVE=true

  cp -f "${target_ttf}" "${TERMUX_CONF_PATH}/${TERMUX_FONT_FILE}"
  termux-reload-settings

  clear
  echo -e "\n${COLOR_WARNING}--- LIVE FONT PREVIEW : $(basename "${target_ttf}") ---${COLOR_BASED}\n"
  echo -e "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
  echo -e "abcdefghijklmnopqrstuvwxyz"
  echo -e "0123456789 () [] {} <>"
  echo -e "The quick brown fox jumps over the lazy dog."
  echo -e "echo 'Hello World' && ls -lgha | grep -E '^d'"
  echo -e "\n${COLOR_WARNING}----------------------------------------${COLOR_BASED}\n"

  if ! read -p "Apply this font permanently? [Y/n] " CONFIRM; then
    PREVIEW_ACTIVE=false
    rm -f "${PREVIEW_MARKER}"
    restore_font_from_backup
    return 1
  fi

  case "${CONFIRM}" in
    "" | y | Y )
      PREVIEW_ACTIVE=false
      rm -f "${FONT_BACKUP_FILE}" "${PREVIEW_MARKER}"
      return 0
    ;;
    * )
      PREVIEW_ACTIVE=false
      rm -f "${PREVIEW_MARKER}"
      restore_font_from_backup
      return 1
    ;;
  esac
}

function list_local_fonts() {
  FONT_USED="$(cat ${FONT_USED_PATH}/${FONT_USED_FILE_NAME} 2>/dev/null)"

  clear
  setCursor off
  banner
  printf " %3s  %9s                                   %4s\n\n" "No." "List Font" "Status"

  local index=0
  local font_files=()
  local font_names=()
  local font_display=()

  for FONT in "${FONTS_DIR}"/{*.ttf,*.otf}; do
    [[ -f "${FONT}" ]] || continue

    local fname
    fname=$(basename "${FONT}")
    font_files+=("${FONT}")
    font_names+=("${fname}")
    font_display+=("${fname%.*}")

    if [[ "${FONT_USED}" == "${fname}" ]]; then
      printf "[${COLOR_SUCCESS}%2s${COLOR_BASED}]  ${COLOR_SUCCESS}%-35s --> USED${COLOR_BASED}\n" "${index}" "${fname%.*}"
    else
      printf "[${COLOR_WARNING}%2s${COLOR_BASED}]  %-35s\n" "${index}" "${fname%.*}"
    fi

    index=$((index + 1))
  done

  echo ""
  printf "[${COLOR_DANGER}x${COLOR_BASED}]  %-35s\n" "Exit"
  echo ""
  setCursor on

  if [[ ${#font_files[@]} -eq 0 ]]; then
    stat "INFO" "Warning" "No local fonts found in ${FONTS_DIR}"
    return 1
  fi

  while :; do
    read -p "Select font number (or press Enter to exit): " CHOICE
    if [[ -z "${CHOICE}" || "${CHOICE}" =~ ^[xX]$ ]]; then
      exit 0
    elif [[ "${CHOICE}" =~ ^[0-9]+$ ]] && (( CHOICE >= 0 && CHOICE < ${#font_files[@]} )); then
      preview_font_live "${font_files[CHOICE]}"
      local preview_status=$?
      if [[ "${preview_status}" -eq 0 ]]; then
        apply_font "${font_files[CHOICE]}" "${font_names[CHOICE]}"
        stat "SUCCESS" "Success" "Applied ${font_display[CHOICE]}"
      elif [[ "${preview_status}" -ne 2 ]]; then
        stat "INFO" "Warning" "Font unchanged."
      fi
      exit 0
    else
      stat "ERROR" "Danger" "Invalid selection, please enter a number between 0 and $(( ${#font_files[@]} - 1 ))"
    fi
  done
}

function abort_font_manager() {
  if [[ "${PREVIEW_ACTIVE}" == true ]]; then
    restore_font_from_backup
    rm -f "${PREVIEW_MARKER}"
    PREVIEW_ACTIVE=false
    echo -e "\n${COLOR_WARNING}INFO${COLOR_BASED} : Preview aborted, your previous font was restored."
  else
    echo -e "\n${COLOR_WARNING}INFO${COLOR_BASED} : Aborted."
  fi

  setCursor on
  exit 1
}

function recover_interrupted_preview() {
  [[ -f "${PREVIEW_MARKER}" ]] || return 0

  clear
  banner
  stat "INFO" "Warning" "An interrupted font preview was detected."

  if [[ -f "${FONT_BACKUP_FILE}" ]]; then
    read -p "Restore the font that was active before the preview? [Y/n] " RECOVER
    case "${RECOVER}" in
      "" | y | Y )
        mv -f "${FONT_BACKUP_FILE}" "${TERMUX_CONF_PATH}/${TERMUX_FONT_FILE}"
        termux-reload-settings
        stat "SUCCESS" "Success" "Previous font restored."
      ;;
      * )
        rm -f "${FONT_BACKUP_FILE}"
        stat "INFO" "Warning" "Keeping the preview font, backup discarded."
      ;;
    esac
  else
    read -p "Remove the preview font and return to the Termux default? [Y/n] " RECOVER
    case "${RECOVER}" in
      "" | y | Y )
        rm -f "${TERMUX_CONF_PATH}/${TERMUX_FONT_FILE}"
        termux-reload-settings
        stat "SUCCESS" "Success" "Default Termux font restored."
      ;;
      * )
        stat "INFO" "Warning" "Keeping the preview font."
      ;;
    esac
  fi

  rm -f "${PREVIEW_MARKER}"
}

function main() {
  trap 'abort_font_manager' 2

  recover_interrupted_preview
  list_local_fonts
}

main
