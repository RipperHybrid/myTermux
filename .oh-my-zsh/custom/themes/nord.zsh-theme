# Arctic Nord frost zsh theme with user & git support

if ! type mytermux_user >/dev/null 2>&1; then
  function mytermux_user() {
    local ufile="${HOME}/.config/mytermux/user.log"
    if [[ -s "$ufile" ]]; then cat "$ufile"; else echo "${USER:-$(whoami 2>/dev/null || echo "user")}"; fi
  }
fi

user_pill="%F{4}%K{4}%F{0}❄ $(mytermux_user)%{%k%}%F{4}%f"

PROMPT='${user_pill} %F{6} %2~%f $(git_prompt_info)
%(?.%F{6}❯%f.%F{1}❯%f) '
RPROMPT='%(0?..%F{1} %f)%F{8}%T%f'

zle_highlight=(default:bold)

ZSH_THEME_GIT_PROMPT_PREFIX="%F{8} (%F{4}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%F{8})%f "
ZSH_THEME_GIT_PROMPT_DIRTY="%F{3} *%f"
ZSH_THEME_GIT_PROMPT_CLEAN="%F{2} ✔%f"
