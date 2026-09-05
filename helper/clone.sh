#!/usr/bin/env bash

REPOSITORY_LINKS=(
  https://github.com/robbyrussell/oh-my-zsh
  https://github.com/zsh-users/zsh-syntax-highlighting
  https://github.com/zsh-users/zsh-autosuggestions
  https://github.com/joshskidmore/zsh-fzf-history-search
  https://github.com/jimeh/tmux-themepack
)

REPOSITORY_TAGS=(
  ""
  ""
  ""
  ""
  ""
)

REPOSITORY_FULL_NAME=(
  robbyrussell/oh-my-zsh
  zsh-users/zsh-syntax-highlighting
  zsh-users/zsh-autosuggestions
  joshskidmore/zsh-fzf-history-search
  jimeh/tmux-themepack
)

REPOSITORY_PATH=(
  $HOME/.oh-my-zsh/
  $HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
  $HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions
  $HOME/.oh-my-zsh/custom/plugins/zsh-fzf-history-search
  $HOME/.tmux-themepack
)

function repositories() {
  setCursor off

  echo -e ""
  echo -e "‏‏‎‏‏‎ ‎ ‎‏‏‎  ‎📦 Getting Information Repository"
  sleep 2s

  echo -e "
    ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
    ┃                       Information Repository                       ┃
    ┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┫
    ┃      Repository Name                                               ┃
    ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛"

  for REPOSITORY_NAME in "${REPOSITORY_FULL_NAME[@]}"; do
    printf  "    ┃      ${COLOR_SUCCESS}%-36s${COLOR_BASED}                          ┃\\n" ${REPOSITORY_NAME}
    echo -e "    ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛"
  done
}

function cloneRepository() {
  setCursor off
  echo -e "\\n‏‏‎‏‏‎ ‎ ‎‏‏‎  ‎📦 Clone or Downloading Repository\\n"
  sleep 2s

  for ((i=0; i<${#REPOSITORY_LINKS[@]}; i++)); do
    start_animation "    Cloning ${COLOR_WARNING}'${COLOR_SUCCESS}${REPOSITORY_FULL_NAME[i]}${COLOR_WARNING}'${COLOR_BASED} ..."

    if git ls-remote "${REPOSITORY_LINKS[i]}" &> /dev/null; then

      if [[ -n "${REPOSITORY_TAGS[i]}" && -d "${REPOSITORY_PATH[i]}" ]]; then
        rm -rf "${REPOSITORY_PATH[i]}"
      elif [[ -d "${REPOSITORY_PATH[i]}" && -n "$(ls -A "${REPOSITORY_PATH[i]}" 2> /dev/null)" ]]; then
        stop_animation 0
        continue
      fi

      if [[ -n "${REPOSITORY_TAGS[i]}" ]]; then
        git clone --depth 1 -b "${REPOSITORY_TAGS[i]}" "${REPOSITORY_LINKS[i]}" "${REPOSITORY_PATH[i]}" 2> /dev/null
      else
        git clone --depth 1 "${REPOSITORY_LINKS[i]}" "${REPOSITORY_PATH[i]}" 2> /dev/null
      fi

      if [ -d "${REPOSITORY_PATH[i]}" ]; then
        stop_animation 0
      else
        stop_animation 1
      fi

    else
      stop_animation 1
      stat "INFO" "Warning" "Repository '${COLOR_WARNING}${REPOSITORY_FULL_NAME[i]}${COLOR_BASED}' is unreachable. Skipping."
    fi
  done
  setCursor on
}
