# La-Round minimal zsh theme with user & git support

if ! type mytermux_user >/dev/null 2>&1; then
  function mytermux_user() {
    local ufile="${HOME}/.config/mytermux/user.log"
    if [[ -s "$ufile" ]]; then cat "$ufile"; else echo "${USER:-$(whoami 2>/dev/null || echo "user")}"; fi
  }
fi

if [[ $EUID -eq 0 ]]; then
    user_symbol="%F{1}%Bλ%b%f"
else
    user_symbol="%(?.%F{6}%Bλ%b%f.%F{1}%Bλ%b%f)"
fi

user_pill="%F{8}%K{8}%F{6} $(mytermux_user) %{%k%}%F{8}%f"
dir_path="%F{8}%K{8}%F{2} %K{0}%F{7} %2~ %{%k%}%F{0}%f"
background_jobs="%(1j.%F{2} %f.)"
non_zero_return_value="%(0?..%F{1} %f)"

# Left part of prompt
PROMPT='$user_pill $dir_path $(git_prompt_info) $user_symbol '
# Right part of prompt
RPROMPT='$background_jobs$non_zero_return_value%F{8}%T%f'
# Input in bold
zle_highlight=(default:bold)

ZSH_THEME_GIT_PROMPT_PREFIX="%F{8}%K{8}%F{6} %K{0}%F{7} "
ZSH_THEME_GIT_PROMPT_SUFFIX="%{%k%}%F{0}%f"
ZSH_THEME_GIT_PROMPT_DIRTY="%F{1} *%f"
ZSH_THEME_GIT_PROMPT_CLEAN="%F{2} ✔%f"
