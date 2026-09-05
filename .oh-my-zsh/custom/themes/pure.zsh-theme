# Pure — two-line minimal prompt
# Line 1: current folder (last 3 segments) + git branch
# Line 2: ➜ turns green on success, red on failure

if [[ $EUID -eq 0 ]]; then
    PROMPT_SYMBOL="%(?:%F{1}➜ :%F{1}➜ )%f"
else
    PROMPT_SYMBOL="%(?:%F{2}➜ :%F{1}➜ )%f"
fi

PROMPT='%F{6}%3~%f $(git_prompt_info)
${PROMPT_SYMBOL}'
RPROMPT=''

zle_highlight=(default:bold)

ZSH_THEME_GIT_PROMPT_PREFIX="%F{8}git:(%F{5}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%f) "
ZSH_THEME_GIT_PROMPT_DIRTY="%F{3}✗"
ZSH_THEME_GIT_PROMPT_CLEAN=""
