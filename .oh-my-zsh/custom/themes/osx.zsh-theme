# macOS styled zsh theme with user & git support

if ! type mytermux_user >/dev/null 2>&1; then
  function mytermux_user() {
    local ufile="${HOME}/.config/mytermux/user.log"
    if [[ -s "$ufile" ]]; then cat "$ufile"; else echo "${USER:-$(whoami 2>/dev/null || echo "user")}"; fi
  }
fi

PROMPT="%F{8}%K{8}%(?:%F{1}● %F{3}● %F{2}●:%F{1} %F{1}● ●)%{%k%}%F{8}%f "
PROMPT+="%F{8}%K{8}%F{6} $(mytermux_user)%{%k%}%F{8}%f "
PROMPT+="%F{8}%K{8}%F{7} %2~%{%k%}%F{8}%f "
PROMPT+='$(git_prompt_info) %(?.%F{6}❯%f.%F{1}❯%f) '

background_jobs="%(1j.%F{3} %f.)"
non_zero_return_value="%(0?..%F{1} %f)"

RPROMPT='$background_jobs$non_zero_return_value%F{8}%T%f'

ZSH_THEME_GIT_PROMPT_PREFIX="%F{8}%K{8}%F{4} %F{7}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{%k%}%F{8}%f "
ZSH_THEME_GIT_PROMPT_DIRTY=" %F{3}"
ZSH_THEME_GIT_PROMPT_CLEAN=" %F{2}✔"
