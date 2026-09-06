# Pure — two-line minimal prompt with user & git support

if ! type mytermux_user >/dev/null 2>&1; then
  function mytermux_user() {
    local ufile="${HOME}/.config/mytermux/user.log"
    if [[ -s "$ufile" ]]; then cat "$ufile"; else echo "${USER:-$(whoami 2>/dev/null || echo "user")}"; fi
  }
fi

if [[ $EUID -eq 0 ]]; then
    PROMPT_SYMBOL="%(?:%F{1}➜ :%F{1}➜ )%f"
else
    PROMPT_SYMBOL="%(?:%F{2}❯ :%F{1}❯ )%f"
fi

PROMPT='%F{5} $(mytermux_user)%f in %F{6} %~%f $(git_prompt_info)
${PROMPT_SYMBOL}'
RPROMPT='%(0?..%F{1} %f)%F{8}%T%f'

zle_highlight=(default:bold)

ZSH_THEME_GIT_PROMPT_PREFIX="%F{8}git:(%F{5}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%F{8})%f "
ZSH_THEME_GIT_PROMPT_DIRTY="%F{3}✗"
ZSH_THEME_GIT_PROMPT_CLEAN="%F{2}✔"
