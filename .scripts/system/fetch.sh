#!/usr/bin/env bash

LIBRARYS=(
  colors signal stat
)

LIBRARY_PATH="${HOME}/.scripts/library"

for LIBRARY in ${LIBRARYS[@]}; do
  source ${LIBRARY_PATH}/${LIBRARY}.sh
done

function fetchMusic() {

  if ! command -v mpc >/dev/null 2>&1; then
    stat "ERROR" "Danger" "Can't fetch music, command '${COLOR_DANGER}mpc${COLOR_BASED}' not found.
            Make sure you installed '${COLOR_SUCCESS}mpd${COLOR_BASED}' and '${COLOR_SUCCESS}mpc${COLOR_BASED}' with '${COLOR_WARNING}pkg install mpd mpc${COLOR_BASED}'"
    return 1
  fi

  MPD_HOST=127.0.0.1 # or localhost
  MPD_PORT=8000 # Depend your MPD configuration
  #MPC_CONNECT_MPD=$(mpc --host=${MPD_HOST} --port=${MPD_PORT} &> /dev/null)

  if mpc --host=${MPD_HOST} --port=${MPD_PORT} &> /dev/null; then

    GET_MUSIC_ARTIST=$(mpc --host=${MPD_HOST} --port=${MPD_PORT} --format '[%artist%]' current 2> /dev/null)
    GET_MUSIC_TITLE=$(mpc --host=${MPD_HOST} --port=${MPD_PORT} --format '[%title%]' current 2> /dev/null)

    echo -e "${GET_MUSIC_ARTIST} - ${GET_MUSIC_TITLE}"

  else

    echo -e "Unknown Artist - Unknown Song"

  fi

}

function fetchStorage() {

  GREP_ONE_ROW=""
  if df -h /storage/emulated/0 >/dev/null 2>&1; then
    GREP_ONE_ROW=$(df -h /storage/emulated/0 | tail -n 1)
  elif df -h /data >/dev/null 2>&1; then
    GREP_ONE_ROW=$(df -h /data | tail -n 1)
  fi
  if [[ -z "${GREP_ONE_ROW}" ]]; then
    GREP_ONE_ROW=$(df -h | grep -m1 -vE '^(Filesystem|tmpfs|devtmpfs|udev)')
  fi
  SIZE=$(echo ${GREP_ONE_ROW} | awk '{print $2}')
  USED=$(echo ${GREP_ONE_ROW} | awk '{print $3}')
  AVAIL=$(echo ${GREP_ONE_ROW} | awk '{print $4}')
  USE=$(echo ${GREP_ONE_ROW} | awk '{print $5}' | sed "s/%//g")
  MOUNTED=$(echo ${GREP_ONE_ROW} | awk '{print $6}')
  ICON=""

  function execute() {

    if [ ${USE} -ge 0 ] && [ ${USE} -le 50 ]; then

      echo -e "${COLOR_SUCCESS}${ICON}${COLOR_BASED} : ${USED}B / ${SIZE}B = ${AVAIL}B (${USE}%)"

    elif [ ${USE} -ge 51 ] && [ ${USE} -le 80 ]; then

      echo -e "${COLOR_WARNING}${ICON}${COLOR_BASED} : ${USED}B / ${SIZE}B = ${AVAIL}B (${USE}%)"

    elif [ ${USE} -ge 81 ]; then

      echo -e "${COLOR_DANGER}${ICON}${COLOR_BASED} : ${USED}B / ${SIZE}B = ${AVAIL}B (${USE}%)"

    fi

  }

  function help() {

    echo -e "Usage:
    ./fetch storage [options]
    "

    echo -e "Options:
    -a        Show fetch storage with all output
    -f        Show fetch storage with free space available
    -m        Show fetch storage mounted path
    -s        Show fetch storage total size
    -u        Show fetch storage total used
    -n        Show fetch storage for neofetch output
    -p        Show fetch storage percentage
    -h        Print help message
    "
  }

  case $1 in

    "" )
      # echo -e "[ ${COLOR_WARNING}${ICON} ${MOUNTED}${COLOR_BASED} ] > ${USED}B / ${SIZE}B = ${AVAIL}B (${USE}%)"
      stat "${ICON} ${MOUNTED}" "Warning" "${USED}B / ${SIZE}B = ${AVAIL}B (${USE}%)"
    ;;

    -a )
      echo -e "${USED}B / ${SIZE}B = ${AVAIL}B (${USE}) > ${MOUNTED}"
    ;;

    -f )
      echo -e "${AVAIL}B"
    ;;

    -m )
      echo -e "${MOUNTED}"
    ;;

    -n )
      execute
    ;;

    -s )
      echo -e "${SIZE}B"
    ;;

    -u )
      echo -e "${USED}"
    ;;

    -p )
      echo -e "${USE}"
    ;;

    -h )
      help
    ;;

    * )
      help
    ;;

  esac

}

function fetchBattery() {

  local pct=""
  local state=""

  # 1. Instant sysfs read (<1ms)
  for bpath in /sys/class/power_supply/battery /sys/class/power_supply/bms /sys/class/power_supply/BAT* /sys/class/power_supply/android_battery; do
    if [[ -f "${bpath}/capacity" ]]; then
      pct=$(cat "${bpath}/capacity" 2>/dev/null)
      state=$(cat "${bpath}/status" 2>/dev/null)
      break
    fi
  done

  # 2. Fast single-shot fallback via termux-battery-status (capped at 0.5s timeout)
  if [[ -z "$pct" ]] && command -v termux-battery-status >/dev/null 2>&1; then
    local raw
    raw=$(timeout 0.5 termux-battery-status 2>/dev/null)
    if [[ -n "$raw" ]]; then
      pct=$(echo "$raw" | grep '"percentage"' | awk -F': ' '{print $2}' | tr -d '", ')
      state=$(echo "$raw" | grep '"status"' | awk -F': ' '{print $2}' | tr -d '", ')
    fi
  fi

  # Default fallback if unavailable
  pct="${pct:-100}"
  state="${state:-Discharging}"
  local state_upper=$(echo "$state" | tr '[:lower:]' '[:upper:]')

  local icon="󰁹"
  local color="${COLOR_SUCCESS}"

  if [[ "$state_upper" =~ CHARG ]]; then
    if [[ $pct -ge 90 ]]; then icon="󰂅"
    elif [[ $pct -ge 70 ]]; then icon="󰂋"
    elif [[ $pct -ge 50 ]]; then icon="󰂉"
    elif [[ $pct -ge 30 ]]; then icon="󰂈"
    elif [[ $pct -ge 15 ]]; then icon="󰂇"
    else icon="󰢜"; color="${COLOR_WARNING}"; fi
  elif [[ "$state_upper" =~ FULL ]]; then
    icon="󰂄"
    color="${COLOR_SUCCESS}"
  else
    if [[ $pct -ge 90 ]]; then icon="󰁹"; color="${COLOR_SUCCESS}"
    elif [[ $pct -ge 70 ]]; then icon="󰂁"; color="${COLOR_SUCCESS}"
    elif [[ $pct -ge 50 ]]; then icon="󰁿"; color="${COLOR_SUCCESS}"
    elif [[ $pct -ge 30 ]]; then icon="󰁽"; color="${COLOR_WARNING}"
    elif [[ $pct -ge 15 ]]; then icon="󰁻"; color="${COLOR_DANGER}"
    else icon="󰁺"; color="${COLOR_DANGER}"; fi
  fi

  case ${1} in

    "" )
      echo -e "${color}${icon}${COLOR_BASED} : ${state}, (${pct}%)"
    ;;

    percentage )
      echo -e "${pct}"
    ;;

    state )
      echo -e "${state}"
    ;;

    help )
      echo -e "Usage:\n    ./fetch battery [percentage|state|help]\n"
    ;;

    * )
      echo -e "${color}${icon}${COLOR_BASED} : ${state}, (${pct}%)"
    ;;

  esac

}

}

function fetchHelp() {

  echo -e "\nUsage:
  ./fetch [option1] [option2]
  "

  echo -e "Options:
  music     Fetch script music
  battery   Fetch script battery (${COLOR_WARNING}require option2${COLOR_BASED})
  storage   Fetch script storage (${COLOR_WARNING}require option2${COLOR_BASED})
  help      Print help message
  "

}

case ${1} in

  battery )
    fetchBattery ${2}
  ;;

  music )
    fetchMusic
  ;;

  storage )
    fetchStorage ${2}
  ;;

  help )
    fetchHelp
  ;;

  * )
    fetchHelp
  ;;

esac
