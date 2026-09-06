# Dracula dark aesthetic zsh theme with user & git support

if ! type mytermux_user >/dev/null 2>&1; then
  function mytermux_user() {
    local ufile="${HOME}/.config/mytermux/user.log"
    if [[ -s "$ufile" ]]; then cat "$ufile"; else echo "${USER:-$(whoami 2>/dev/null || echo "user")}"; fi
  }
fi

PROMPT='%F{5}┌─[ %F{13}%B$(mytermux_user)%b%F{5} ]─[ %F{6} %2~%F{5} ] $(git_prompt_info)
%F{5}└─%(?.%F{10}λ%f.%F{9}λ %?%f) '
RPROMPT='%(1j.%F{11} %f.)%F{8}%T%f'

zle_highlight=(default:bold)

ZSH_THEME_GIT_PROMPT_PREFIX="%F{5}─[ %F{14} %F{11}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%F{5} ]%f"
ZSH_THEME_GIT_PROMPT_DIRTY="%F{9} ✗"
ZSH_THEME_GIT_PROMPT_CLEAN="%F{10} ✔"
