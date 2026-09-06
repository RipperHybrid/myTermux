# Powerline — segmented arrows prompt with user & git support

if ! type mytermux_user >/dev/null 2>&1; then
  function mytermux_user() {
    local ufile="${HOME}/.config/mytermux/user.log"
    if [[ -s "$ufile" ]]; then cat "$ufile"; else echo "${USER:-$(whoami 2>/dev/null || echo "user")}"; fi
  }
fi

if [[ $EUID -eq 0 ]]; then
    USER_BG=1
else
    USER_BG=4
fi

PROMPT="%K{${USER_BG}}%F{0}  $(mytermux_user) %K{0}%F{${USER_BG}}%F{7}  %2~ %K{8}%F{0}%f"
PROMPT+='$(git_prompt_info)%{%k%}%F{8}%f '
RPROMPT='%(0?..%F{1}✗ %f)%F{8}%T%f'

zle_highlight=(default:bold)

ZSH_THEME_GIT_PROMPT_PREFIX="%K{8}%F{5}  %F{6}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%K{8} "
ZSH_THEME_GIT_PROMPT_DIRTY="%F{3}✗"
ZSH_THEME_GIT_PROMPT_CLEAN="%F{2}✔"
