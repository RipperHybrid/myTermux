# Cyberpunk / Neon Synthwave zsh theme with user & git support

if ! type mytermux_user >/dev/null 2>&1; then
  function mytermux_user() {
    local ufile="${HOME}/.config/mytermux/user.log"
    if [[ -s "$ufile" ]]; then cat "$ufile"; else echo "${USER:-$(whoami 2>/dev/null || echo "user")}"; fi
  }
fi

PROMPT='%F{11}⚡ %F{13}%B$(mytermux_user)%b%f %F{14} %2~%f $(git_prompt_info)
%(?.%F{11}❯%F{14}❯%F{13}❯%f.%F{9}❯❯❯ %?%f) '
RPROMPT='%F{8}[ %F{14}%T%F{8} ]%f'

zle_highlight=(default:bold)

ZSH_THEME_GIT_PROMPT_PREFIX="%F{14} (%F{11}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%F{14})%f "
ZSH_THEME_GIT_PROMPT_DIRTY="%F{9} ✗"
ZSH_THEME_GIT_PROMPT_CLEAN="%F{10} ✔"
