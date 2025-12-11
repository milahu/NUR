# Generated variables
export DIRENV_LOG_FORMAT="$(print -P "%B%F{8}┃ %%s%f")"
TIMEFMT="$(print -P "%B%F{8}┃ Duration: %%*Es, CPU: %%P, Memory: %%MkB%f")"

# Completions
compdef '_values passwords $(gopass ls --flat)' gopass-env
compdef '_values passwords $(gopass ls --flat)' gopass-ydotool
source @zsh-complete-git-commit-message@

# Abbreviations (TODO: Troubleshoot programs.zsh.zsh-abbr, contribute solution)
source @zsh-abbr@

# Syntax highlighting (TODO: Use programs.zsh.syntaxHighlighting)
source @zsh-syntax-highlighting@
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main regexp)
ZSH_HIGHLIGHT_REGEXP+=('^[[:blank:][:space:]]*('${(j:|:)${(k)ABBR_REGULAR_USER_ABBREVIATIONS}}')$' 'fg=cyan,bold')
ZSH_HIGHLIGHT_STYLES[arg0]='fg=white,bold'
ZSH_HIGHLIGHT_STYLES[precommand]='fg=white,italic'
ZSH_HIGHLIGHT_STYLES[reserved-word]='fg=cyan'

# Workaround for starship/starship#4205
source @zsh-starship-issue-4205@

# Terminal title
zstyle ':prezto:module:terminal' auto-title 'yes'
zstyle ':prezto:module:terminal:multiplexer-title' format '%1~'
zstyle ':prezto:module:terminal:tab-title' format '%1~'
zstyle ':prezto:module:terminal:window-title' format '%1~'
source @zsh-prezto-terminal@

# Click
source @zsh-click@

# Workaround for direnv/direnv#443
source @zsh-completion-sync@
