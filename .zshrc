export ZSH=$HOME/.oh-my-zsh
ZSH_THEME="ma"
plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
  bgnotify
  zsh-fzf-history-search
)

PATH="$PREFIX/bin:$HOME/.local/bin:$PATH"
export PATH

LINK="https://github.com/RipperHybrid"
export LINK

LINK_SSH="git@github.com:RipperHybrid"
export LINK_SSH

export TERM=xterm-256color

export ZSH_AUTOSUGGEST_USE_ASYNC=true
export ZSH_AUTOSUGGEST_STRATEGY=(history)

_zsh_autosuggest_post_fetch_hook() {
  stty sane 2>/dev/null
}
ZSH_AUTOSUGGEST_PARTIAL_ACCEPT_WIDGETS=(forward-char)
ZSH_AUTOSUGGEST_ACCEPT_WIDGETS=(end-of-line vi-end-of-line)

MYTERMUX_USER_FILE="${HOME}/.config/mytermux/user.log"

function mytermux_user() {
  if [[ -s "${MYTERMUX_USER_FILE}" ]]; then
    cat "${MYTERMUX_USER_FILE}"
  fi
}

function setuser() {
  local name="${1}"
  if [[ -z "${name}" ]]; then
    read "name?Username: "
  fi
  name="${name//\%/}"
  if [[ -z "${name}" ]]; then
    echo -e "INFO: empty name — keeping the auto-detected user."
    return 1
  fi
  mkdir -p "${HOME}/.config/mytermux"
  print -rn -- "${name}" > "${MYTERMUX_USER_FILE}"
  echo -e "Username set to '${name}'. It shows in the prompt on the next shell."
}

source $ZSH/oh-my-zsh.sh

[[ -f $HOME/.config/lf/icons ]] && source $HOME/.config/lf/icons

source $HOME/.aliases

command_not_found_handler() {
  local cmd="$1"
  local cnf_bin="$PREFIX/libexec/termux/command-not-found"

  stty sane 2>/dev/null || stty echo icanon icrnl onlcr 2>/dev/null

  if [[ ! -x "$cnf_bin" ]]; then
    echo "zsh: command not found: $cmd"
    return 127
  fi

  local output=$("$cnf_bin" "$cmd" 2>&1)

  local pkgs=()
  local pkgs_text
  pkgs_text=$(printf '%s\n' "$output" | sed -n -e 's/.*pkg install \([^ ]*\).*/\1/p' -e 's/.* in package \([^ ]*\).*/\1/p' | tr -d "'" | awk '!seen[$0]++')
  if [[ -n "${pkgs_text}" ]]; then
    pkgs=("${(@f)pkgs_text}")
  fi

  if [[ ${#pkgs[@]} -gt 0 ]]; then
    echo ""
    [[ -n "$output" ]] && echo "$output"
    echo ""

    trap 'stty sane 2>/dev/null; echo ""; echo -e "\e[34mINFO\e[0m: Installation aborted."; return 127' INT

    PS3=$'\n\e[93mEnter a number to install, or select Exit: \e[0m'
    select pkg in "${pkgs[@]}" "Exit Normally"; do
      if [[ "$pkg" == "Exit Normally" ]]; then
        trap - INT
        stty sane 2>/dev/null
        echo -e "\e[34mINFO\e[0m: Installation aborted."
        return 127
      elif [[ -n "$pkg" ]]; then
        trap - INT
        stty sane 2>/dev/null
        echo -e "\n\e[34mINFO\e[0m: Installing \e[92m$pkg\e[0m..."
        pkg install -y "$pkg"
        stty sane 2>/dev/null
        if command -v "$cmd" >/dev/null 2>&1; then
          echo -e "\n\e[92mSUCCESS\e[0m: Executing '$cmd'...\n"
          eval "$@"
          return 0
        fi
        return 0
      else
        echo -e "\e[91mERROR\e[0m: Invalid selection. Try again."
      fi
    done
    trap - INT
    stty sane 2>/dev/null
    return 127
  fi

  if [[ -n "$output" ]]; then
    echo ""
    echo "$output"
  else
    echo "zsh: command not found: $cmd"
  fi

  stty sane 2>/dev/null
  return 127
}

for name in "${(k)aliases[@]}"; do
  cmd="${aliases[$name]%% *}"
  case "$cmd" in
    if|for|while|until|case) continue ;;
  esac
  cmd="${cmd/#\~/$HOME}"
  command -v "$cmd" >/dev/null 2>&1 || unalias "$name"
done

for name in "${(k)aliases[@]}"; do
  value="${aliases[$name]}"
  for root in "~/myTermux" "$HOME/myTermux" "~/.scripts/toys" "~/.scripts/js" "~/.config/mpd" "~/.config/ncmpcpp" "~/.config/nvim"; do
    if [[ "$value" == *"$root"* && ! -e "${root/#\~/$HOME}" ]]; then
      unalias "$name"
      break
    fi
  done
done

source $HOME/.autostart

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#767676"

if (( $+widgets[autosuggest-accept] )); then
  bindkey '^[[C' autosuggest-accept
  bindkey '^f' autosuggest-accept
fi

setopt HIST_IGNORE_SPACE
setopt TRANSIENT_RPROMPT
setopt RM_STAR_SILENT

autoload -Uz add-zsh-hook
_mytermux_precmd() {
  stty sane 2>/dev/null || stty echo icanon icrnl onlcr 2>/dev/null
}
add-zsh-hook precmd _mytermux_precmd

ttyctl -f 2>/dev/null
