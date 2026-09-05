#!/usr/bin/env bash

function getScreenDimensions() {
  local sz
  sz=$(stty size < /dev/tty 2>/dev/null)
  [[ -z "$sz" ]] && sz=$(stty size 2>/dev/null)

  if [[ -n "$sz" ]]; then
    SCREEN_ROWS=$(echo "$sz" | awk '{print $1}')
    SCREEN_COLS=$(echo "$sz" | awk '{print $2}')
  else
    SCREEN_COLS=$(tput cols 2>/dev/null || echo "${COLUMNS:-0}")
    SCREEN_ROWS=$(tput lines 2>/dev/null || echo "${LINES:-0}")
  fi

  [[ -z "$SCREEN_COLS" || "$SCREEN_COLS" -le 0 ]] && SCREEN_COLS=${COLUMNS:-0}
  [[ -z "$SCREEN_ROWS" || "$SCREEN_ROWS" -le 0 ]] && SCREEN_ROWS=${LINES:-0}
}

function screenSize() {

  local REQUIRE_COLS=101
  local REQUIRE_ROWS=39

  getScreenDimensions
  local CURRENT_COLS=$SCREEN_COLS
  local CURRENT_ROWS=$SCREEN_ROWS

  if (( CURRENT_COLS >= REQUIRE_COLS && CURRENT_ROWS >= REQUIRE_ROWS )); then
    export COLUMNS="$CURRENT_COLS"
    export LINES="$CURRENT_ROWS"
    ${1}
    return $?
  fi

  setCursor off
  trap 'setCursor on; echo ""; echo -e "[ ${COLOR_DANGER}ERROR${COLOR_BASED} ] > Aborted by user."; exit 1' INT TERM

  local LAST_COLS=-1
  local LAST_ROWS=-1

  while :; do
    getScreenDimensions
    CURRENT_COLS=$SCREEN_COLS
    CURRENT_ROWS=$SCREEN_ROWS

    if (( CURRENT_COLS >= REQUIRE_COLS && CURRENT_ROWS >= REQUIRE_ROWS )); then
      export COLUMNS="$CURRENT_COLS"
      export LINES="$CURRENT_ROWS"
      clear
      setCursor on
      ${1}
      return $?
    fi

    if [[ "$CURRENT_COLS" != "$LAST_COLS" || "$CURRENT_ROWS" != "$LAST_ROWS" ]]; then
      clear
      echo ""
      echo -e "[ ${COLOR_WARNING}WARNING${COLOR_BASED} ] > Screen size is too small: ${COLOR_WARNING}${CURRENT_COLS}x${CURRENT_ROWS}${COLOR_BASED} (Required: ${COLOR_SUCCESS}${REQUIRE_COLS}x${REQUIRE_ROWS}${COLOR_BASED})"
      echo -e "[ ${COLOR_SKY}INFO${COLOR_BASED} ]    > Please ${COLOR_WARNING}pinch / zoom out${COLOR_BASED} your screen. Press '${COLOR_WARNING}q${COLOR_BASED}' to abort."
      echo ""

      LAST_COLS=$CURRENT_COLS
      LAST_ROWS=$CURRENT_ROWS
    fi

    read -t 0.3 -n 1 key < /dev/tty 2>/dev/null
    case "$key" in
      q | Q )
        setCursor on
        echo ""
        echo -e "[ ${COLOR_DANGER}ERROR${COLOR_BASED} ] > Aborted by user."
        exit 1
      ;;
    esac
  done

  setCursor on

}