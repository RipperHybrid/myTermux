# Rounded-Custom zsh theme with user & git support

if ! type mytermux_user >/dev/null 2>&1; then
  function mytermux_user() {
    local ufile="${HOME}/.config/mytermux/user.log"
    if [[ -s "$ufile" ]]; then cat "$ufile"; else echo "${USER:-$(whoami 2>/dev/null || echo "user")}"; fi
  }
fi

user_pill="%F{7}%K{7}%F{0} $(mytermux_user)%{%k%}%F{7}%f"
path_pill="%F{7}%K{7}%F{0} %2~%{%k%}%F{7}%f"
background_jobs="%(1j.%F{0}%K{0} %F{3} %{%k%}%F{0}%f.)"
non_zero_return_value="%(0?..%F{7}%K{7} %F{1} %{%k%}%F{7}%f)"

PROMPT='$user_pill $path_pill $(git_prompt_info) %(?.%F{7}❯%f.%F{1}❯%f) '
RPROMPT='$background_jobs$non_zero_return_value%F{8}%T%f'

zle_highlight=(default:bold)

ZSH_THEME_GIT_PROMPT_PREFIX="%F{7}%K{7}%F{0} %K{7}"
ZSH_THEME_GIT_PROMPT_SUFFIX=" %{%k%}%F{7}%f "
ZSH_THEME_GIT_PROMPT_DIRTY="%F{1} ✗"
ZSH_THEME_GIT_PROMPT_CLEAN="%F{2} ✔"
