### The prompt

# Left-hand prompt
PROMPT='(pyenv: $(pyenv version-name))%{$fg[cyan]%}%3/ %{$fg_bold[blue]%}✎ %{$reset_color%} ' # ☛ ☠ ✎

# function updatePrompt {

#     # Styles
#     GREEN='\[\e[0;32m\]'
#     BLUE='\[\e[0;34m\]'
#     RESET='\[\e[0m\]'

#     # Current virtualenv
#     if [[ $VIRTUAL_ENV != "" ]]; then
#         # Strip out the path and just leave the env name
#         PROMPT="$PROMPT${BLUE}{${VIRTUAL_ENV##*/}}${RESET}"
#     fi

#     PS1="$PROMPT\$ "
# }
# export -f updatePrompt

# # Bash shell executes this function just before displaying the PS1 variable
# export PROMPT_COMMAND='updatePrompt'

# Right-hand prompt
# Looks like this: (master|✚3)
RPROMPT='%{$fg[magenta]%}$(git_super_status)%{$reset_color%}'

# Git customizations
# ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[red]%}" # ☁
# ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
# ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[yellow]%} ☂" # Ⓓ
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[cyan]%} ☄" # ⓣ
# ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[green]%} ✔" # Ⓞ ☀

# ZSH_THEME_GIT_PROMPT_ADDED="%{$fg[cyan]%} ✚" # ⓐ ⑃
# ZSH_THEME_GIT_PROMPT_MODIFIED="%{$fg[yellow]%} ⚡"  # ⓜ ⑁
# ZSH_THEME_GIT_PROMPT_DELETED="%{$fg[red]%} ✖" # ⓧ ⑂
# ZSH_THEME_GIT_PROMPT_RENAMED="%{$fg[blue]%} ➜" # ⓡ ⑄
# ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg[magenta]%} ♒" # ⓤ ⑊
# ZSH_THEME_GIT_PROMPT_AHEAD="%{$fg[blue]%} 𝝙"

# More symbols to choose from:
# ☀ ✹ ☄ ♆ ♀ ♁ ♐ ♇ ♈ ♉ ♚ ♛ ♜ ♝ ♞ ♟ ♠ ♣ ⚢ ⚲ ⚳ ⚴ ⚥ ⚤ ⚦ ⚒ ⚑ ⚐ ♺ ♻ ♼ ☰ ☱ ☲ ☳ ☴ ☵ ☶ ☷
# ✡ ✔ ✖ ✚ ✱ ✤ ✦ ❤ ➜ ➟ ➼ ✂ ✎ ✐ ⨀ ⨁ ⨂ ⨍ ⨎ ⨏ ⨷ ⩚ ⩛ ⩡ ⩱ ⩲ ⩵  ⩶ ⨠
# ⬅ ⬆ ⬇ ⬈ ⬉ ⬊ ⬋ ⬒ ⬓ ⬔ ⬕ ⬖ ⬗ ⬘ ⬙ ⬟  ⬤ 〒 ǀ ǁ ǂ ĭ Ť Ŧ
