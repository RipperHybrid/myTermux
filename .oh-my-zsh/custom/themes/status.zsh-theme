status_user=''
if [[ -s "${HOME}/.config/mytermux/user.log" ]]; then
    status_user="$(mytermux_user)@%m "
fi

PROMPT='%F{8}◆ %f${status_user}%F{8}· %~%f\n%(?.%F{2}❯%f.%F{1}❯ %?%f) $(git_prompt_info)'
RPROMPT='%F{8}%T%f'

zle_highlight=(default:bold)

ZSH_THEME_GIT_PROMPT_PREFIX="%F{8}git:(%F{5}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%f) "
ZSH_THEME_GIT_PROMPT_DIRTY="%F{3}✗"
ZSH_THEME_GIT_PROMPT_CLEAN=""