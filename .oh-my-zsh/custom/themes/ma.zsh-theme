# Ma minimal zsh theme with user & git support

if ! type mytermux_user >/dev/null 2>&1; then
  function mytermux_user() {
    local ufile="${HOME}/.config/mytermux/user.log"
    if [[ -s "$ufile" ]]; then cat "$ufile"; else echo "${USER:-$(whoami 2>/dev/null || echo "user")}"; fi
  }
fi

local ret_status="%(?:%{$fg_bold[green]%}%{%G➜%} :%{$fg_bold[red]%}%{%G➜%} )"
PROMPT='${ret_status}%{$fg_bold[magenta]%} $(mytermux_user)%{$reset_color%} in %{$fg_bold[cyan]%} %~%{$reset_color%} $(git_prompt_info)
%{$fg_bold[blue]%}❯%{$reset_color%} '
RPROMPT='%(0?..%F{1} %f)%F{8}%T%f'

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[blue]%} (%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$fg_bold[blue]%})%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[yellow]%} ✗%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[green]%} ✔%{$reset_color%}"

