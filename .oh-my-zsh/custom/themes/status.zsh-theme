# Status bar zsh theme with user & git support

if ! type mytermux_user >/dev/null 2>&1; then
  function mytermux_user() {
    local ufile="${HOME}/.config/mytermux/user.log"
    if [[ -s "$ufile" ]]; then cat "$ufile"; else echo "${USER:-$(whoami 2>/dev/null || echo "user")}"; fi
  }
fi

PROMPT='%F{8}┌─[ %F{5} $(mytermux_user)%F{8} ]─[ %F{6} %~%F{8} ] $(git_prompt_info)
%F{8}└─%(?.%F{2}❯%f.%F{1}❯ %?%f) '
RPROMPT='%F{8}%T%f'

zle_highlight=(default:bold)

ZSH_THEME_GIT_PROMPT_PREFIX="%F{8}─[ %F{4} %F{3}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%F{8} ]%f"
ZSH_THEME_GIT_PROMPT_DIRTY="%F{1} ✗"
ZSH_THEME_GIT_PROMPT_CLEAN="%F{2} ✔"