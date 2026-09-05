# Powerline — segmented arrows prompt (requires Nerd Fonts)
# Left: user@host then current folder
# Right: git branch/status, prefixed by a red ✗ after a failed command

if [[ $EUID -eq 0 ]]; then
    USER_BG=1
else
    USER_BG=4
fi

# First segment: user@host on a colored block
# Second segment: current folder on a black block, joined by a powerline arrow
PROMPT="%K{${USER_BG}}%F{0} $(mytermux_user) %F{${USER_BG}}%K{0}"$'\uE0B0'"%F{7} %2~ %k%f "
RPROMPT='%(0?..%F{1}✗ %f)$(git_prompt_info)'

zle_highlight=(default:bold)

ZSH_THEME_GIT_PROMPT_PREFIX="%F{5}git:(%F{6}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%f) "
ZSH_THEME_GIT_PROMPT_DIRTY="%F{3}✗"
ZSH_THEME_GIT_PROMPT_CLEAN=""
