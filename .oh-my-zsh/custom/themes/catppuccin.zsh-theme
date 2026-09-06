# Catppuccin Mocha pastel zsh theme with user & git support

if ! type mytermux_user >/dev/null 2>&1; then
  function mytermux_user() {
    local ufile="${HOME}/.config/mytermux/user.log"
    if [[ -s "$ufile" ]]; then cat "$ufile"; else echo "${USER:-$(whoami 2>/dev/null || echo "user")}"; fi
  }
fi

user_pill="%F{5}%K{5}%F{0}󰄛 $(mytermux_user)%{%k%}%F{5}%f"
path_pill="%F{4}%K{4}%F{0} %2~%{%k%}%F{4}%f"

PROMPT='${user_pill} ${path_pill} $(git_prompt_info)
%(?.%F{6}❯%f.%F{1}❯%f) '
RPROMPT='%(1j.%F{3}󱪤 %f.)%F{8}%T%f'

zle_highlight=(default:bold)

ZSH_THEME_GIT_PROMPT_PREFIX="%F{3}%K{3}%F{0} "
ZSH_THEME_GIT_PROMPT_SUFFIX="%{%k%}%F{3}%f "
ZSH_THEME_GIT_PROMPT_DIRTY="%F{1} ✗"
ZSH_THEME_GIT_PROMPT_CLEAN="%F{2} ✔"
