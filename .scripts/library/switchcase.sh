#!/usr/bin/env bash

function switchCase() {

  setCursor on

  local ACTION="${1}"
  local NAME="${2}"
  local DESCRIPTION="${3}"
  local YES_CMD="${4:-${3}}"
  local NO_CMD="${5:-}"
  local REQUIRED="${6:-}"
  local CONFIRMED_SKIP=0

  echo ""
  if [[ -n "${DESCRIPTION}" ]]; then
    stat "INFO" "Info" "${DESCRIPTION}"
  fi
  echo ""

  while :; do

    echo -ne "    ${ACTION} ${NAME}? [${COLOR_SUCCESS}Y${COLOR_BASED}/${COLOR_WARNING}n${COLOR_BASED}]${REQUIRED:+ (${COLOR_DANGER}Required${COLOR_BASED})} "
    if ! read -r SWITCH_CASE; then
      echo ""
      stat "ERROR" "Danger" "No answer received. Aborting."
      setCursor on
      exit 1
    fi

    case "$SWITCH_CASE" in

      y | Y )
        ${YES_CMD}
        break
      ;;

      n | N )
        if [[ -n "${REQUIRED}" ]]; then
          if [[ "${CONFIRMED_SKIP}" -eq 1 ]]; then
            echo ""
            stat "ERROR" "Danger" "${NAME} is required."
            setCursor on
            exit 1
          fi
          CONFIRMED_SKIP=1
          echo ""
          stat "INFO" "Warning" "${NAME} is required. Press '${COLOR_SUCCESS}y${COLOR_BASED}' to continue, or '${COLOR_DANGER}n${COLOR_BASED}' again to abort."
          echo ""
          continue
        fi
        stat "INFO" "Warning" "${COLOR_WARNING}Skipping ${NAME}...${COLOR_BASED}"
        if [[ -n "${NO_CMD}" ]]; then
          ${NO_CMD}
        fi
        break
      ;;

      "" )
        echo ""
        stat "INFO" "Warning" "No answer given — type '${COLOR_WARNING}y${COLOR_BASED}' to accept or '${COLOR_WARNING}n${COLOR_BASED}' to skip."
        echo ""
      ;;

      * )
        echo ""
        stat "ERROR" "Warning" "Unknown '${COLOR_DANGER}${SWITCH_CASE}${COLOR_BASED}' — type 'y' or 'n'."
        echo ""
      ;;

    esac

  done

  setCursor on

}

}