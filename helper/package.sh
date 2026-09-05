#!/usr/bin/env bash

PACKAGES=(
  bat curl clang eza fzf git
  neovim openssh
  neofetch termux-api tmux zsh
)

function packages() {

  setCursor off

  KB_DOWNLOAD_SIZE=0
  MB_DOWNLOAD_SIZE=0

  KB_INSTALLED_SIZE=0
  MB_INSTALLED_SIZE=0

  INSTALLED_COUNT=0
  UPGRADE_COUNT=0
  MISSING_COUNT=0

  echo -e "‏‏‎‏‏‎ ‎ ‎‏‏‎  ‎📦 Getting Information Packages"

  echo -e "
    ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
    ┃                                 Information Packages                                ┃
    ┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┫
    ┃      Package Name              Version             Download           Installed     ┃
    ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛"

  for PACKAGE in "${PACKAGES[@]}"; do

    PACKAGE_INFO=$(apt show "$PACKAGE" 2> /dev/null)

    PACKAGE_NAME=$(echo "${PACKAGE_INFO}" | grep Package: | awk '{print $2}')
    VERSION=$(echo "${PACKAGE_INFO}" | grep Version: | awk '{print $2}')

    DOWNLOAD_SIZE=$(echo "${PACKAGE_INFO}" | grep Download-Size: | awk '{print $2}')
    INSTALLED_SIZE=$(echo "${PACKAGE_INFO}" | grep Installed-Size: | awk '{print $2}')

    UNIT_DOWNLOAD_SIZE=$(echo "${PACKAGE_INFO}" | grep Download-Size: | awk '{print $3}')
    UNIT_INSTALLED_SIZE=$(echo "${PACKAGE_INFO}" | grep Installed-Size: | awk '{print $3}')

    INSTALLED_VERSION=$(dpkg-query -W -f='${Version}' "$PACKAGE" 2> /dev/null)

    if [[ -n "${PACKAGE_INFO}" ]]; then
      if [[ -z "${INSTALLED_VERSION}" ]]; then
        MISSING_COUNT=$(( MISSING_COUNT + 1 ))
      elif [[ -n "${VERSION}" ]] && dpkg --compare-versions "${INSTALLED_VERSION}" lt "${VERSION}" 2> /dev/null; then
        UPGRADE_COUNT=$(( UPGRADE_COUNT + 1 ))
      else
        INSTALLED_COUNT=$(( INSTALLED_COUNT + 1 ))
      fi
    fi

    printf  "    ┃      ${COLOR_SUCCESS}%-13s${COLOR_BASED}          ${COLOR_WARNING}%10s${COLOR_BASED}              ${COLOR_WARNING}%-4s${COLOR_BASED} %-2s             ${COLOR_WARNING}%-4s${COLOR_BASED} %-2s     ┃\n" $PACKAGE_NAME $VERSION ${DOWNLOAD_SIZE} "${UNIT_DOWNLOAD_SIZE}" ${INSTALLED_SIZE} "${UNIT_INSTALLED_SIZE}"
    echo -e "    ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛"

    if [[ "${UNIT_DOWNLOAD_SIZE}" == "kB" && "${UNIT_INSTALLED_SIZE}" == "MB" ]]; then

      KB_DOWNLOAD_SIZE=$(echo "${KB_DOWNLOAD_SIZE} + ${DOWNLOAD_SIZE} / 1024" | bc -l | xargs -i printf "%'.1f" {})
      MB_INSTALLED_SIZE=$(echo "${MB_INSTALLED_SIZE} + ${INSTALLED_SIZE}" | bc -l | xargs -i printf "%'.1f" {})

    elif [[ "${UNIT_DOWNLOAD_SIZE}" == "MB" && "${UNIT_INSTALLED_SIZE}" == "kB" ]]; then

      MB_DOWNLOAD_SIZE=$(echo "${MB_DOWNLOAD_SIZE} + ${DOWNLOAD_SIZE}" | bc -l | xargs -i printf "%'.1f" {})
      KB_INSTALLED_SIZE=$(echo "${KB_INSTALLED_SIZE} + ${INSTALLED_SIZE} / 1024" | bc -l | xargs -i printf "%'.1f" {})

    elif [[ "${UNIT_DOWNLOAD_SIZE}" == "kB" && "${UNIT_INSTALLED_SIZE}" == "kB" ]]; then

      KB_DOWNLOAD_SIZE=$(echo "${KB_DOWNLOAD_SIZE} + ${DOWNLOAD_SIZE} / 1024" | bc -l | xargs -i printf "%'.1f" {})
      KB_INSTALLED_SIZE=$(echo "${KB_INSTALLED_SIZE} + ${INSTALLED_SIZE} / 1024" | bc -l | xargs -i printf "%'.1f" {})

    elif [[ "${UNIT_DOWNLOAD_SIZE}" == "MB" && "${UNIT_INSTALLED_SIZE}" == "MB" ]]; then

      MB_DOWNLOAD_SIZE=$(echo "${MB_DOWNLOAD_SIZE} + ${DOWNLOAD_SIZE}" | bc -l | xargs -i printf "%'.1f" {})
      MB_INSTALLED_SIZE=$(echo "${MB_INSTALLED_SIZE} + ${INSTALLED_SIZE}" | bc -l | xargs -i printf "%'.1f" {})

    fi

  done

  TOTAL_DOWNLOAD_SIZE=$(echo "${KB_DOWNLOAD_SIZE} + ${MB_DOWNLOAD_SIZE}" | bc -l | xargs -i printf "%'.1f" {})
  TOTAL_INSTALLED_SIZE=$(echo "${KB_INSTALLED_SIZE} + ${MB_INSTALLED_SIZE}" | bc -l | xargs -i printf "%'.1f" {})

  printf    "    ┃     [ ${COLOR_WARNING}%5s${COLOR_BASED} ]  ─────────────────────────────────> ${COLOR_WARNING}%6s${COLOR_BASED} %-2s           ${COLOR_WARNING}%6s${COLOR_BASED} %-2s     ┃" "TOTAL" ${TOTAL_DOWNLOAD_SIZE} "MB" ${TOTAL_INSTALLED_SIZE} "MB"
  echo -e "\n    ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛"

  echo ""

  INSTALLED_SUMMARY=()
  [[ ${INSTALLED_COUNT} -gt 0 ]] && INSTALLED_SUMMARY+=("${INSTALLED_COUNT} up-to-date")
  [[ ${UPGRADE_COUNT} -gt 0 ]] && INSTALLED_SUMMARY+=("${UPGRADE_COUNT} have updates available")
  [[ ${MISSING_COUNT} -gt 0 ]] && INSTALLED_SUMMARY+=("${MISSING_COUNT} not installed")

  if [[ ${#INSTALLED_SUMMARY[@]} -gt 0 ]]; then
    SUMMARY_TEXT=$(IFS=', '; echo "${INSTALLED_SUMMARY[*]}")
    stat "INFO" "Info" "Core package status: ${SUMMARY_TEXT}."
  fi

}

function installOrUpgradePackage() {

  local PACKAGE="$1"
  local INSTALLED_VERSION=""
  local CANDIDATE_VERSION=""
  local MESSAGE=""

  if ! apt-cache show "$PACKAGE" > /dev/null 2>&1; then
    stat "INFO" "Warning" "Package '${COLOR_WARNING}${PACKAGE}${COLOR_BASED}' is unavailable in the repo. Skipping."
    return 2
  fi

  INSTALLED_VERSION=$(dpkg-query -W -f='${Version}' "$PACKAGE" 2> /dev/null)
  CANDIDATE_VERSION=$(apt-cache policy "$PACKAGE" 2> /dev/null | awk -F': ' '/^  Candidate:/ { print $2; exit }')

  [[ -z "${CANDIDATE_VERSION}" ]] && CANDIDATE_VERSION="${INSTALLED_VERSION}"

  if [[ -n "${INSTALLED_VERSION}" ]] && dpkg --compare-versions "${INSTALLED_VERSION}" ge "${CANDIDATE_VERSION}" 2> /dev/null; then
    echo -e "    Skipping ${COLOR_WARNING}'${COLOR_SUCCESS}${PACKAGE}${COLOR_WARNING}'${COLOR_BASED} ...  --> [ ${COLOR_WARNING}UP-TO-DATE${COLOR_DEFAULT} ]"
    return 0
  fi

  if [[ -n "${INSTALLED_VERSION}" ]]; then
    MESSAGE="    Updating ${COLOR_WARNING}'${COLOR_SUCCESS}${PACKAGE}${COLOR_WARNING}'${COLOR_BASED} ${COLOR_WARNING}${INSTALLED_VERSION}${COLOR_BASED} -> ${COLOR_WARNING}${CANDIDATE_VERSION}${COLOR_BASED} ..."
  else
    MESSAGE="    Installing ${COLOR_WARNING}'${COLOR_SUCCESS}${PACKAGE}${COLOR_WARNING}'${COLOR_BASED} ..."
  fi

  start_animation "${MESSAGE}"

  if pkg i -y "${PACKAGE}" &> /dev/null; then
    stop_animation 0
    return 0
  fi

  stop_animation 1
  return 1

}

function installPackages() {
  setCursor off

  echo -e "\n‏‏‎‏‏‎ ‎ ‎‏‏‎  ‎📦 Downloading Packages\n"

  for PACKAGE in "${PACKAGES[@]}"; do
    installOrUpgradePackage "${PACKAGE}"
  done

  setCursor on
}

function installMusic() {
  setCursor off

  echo ""

  for PACKAGE in mpd mpc; do
    installOrUpgradePackage "${PACKAGE}"
  done

  setCursor on
}
