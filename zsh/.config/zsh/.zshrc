# Created by Zap installer
[ -f "${XDG_DATA_HOME:-$HOME/.local/share}/zap/zap.zsh" ] && source "${XDG_DATA_HOME:-$HOME/.local/share}/zap/zap.zsh"

# Load and initialise completion system
autoload -Uz compinit; compinit
autoload bashcompinit; bashcompinit

# History
export HISTFILESIZE=1000000
export HISTSIZE=10000001
export HISTFILE=~/.zsh_history
setopt HIST_FIND_NO_DUPS
setopt INC_APPEND_HISTORY
setopt HIST_IGNORE_SPACE

# Sources
#plug "$HOME/.config/zsh/zsh-aliases.zsh"
plug "$HOME/.config/zsh/zsh-prompt.zsh"
plug "$HOME/.config/zsh/zsh-vim.zsh"

# Plugins
plug "zsh-users/zsh-autosuggestions"
plug "zap-zsh/supercharge"
plug "hlissner/zsh-autopair"
plug "zsh-users/zsh-history-substring-search"
plug "zsh-users/zsh-syntax-highlighting"

zstyle ':completion:*' special-dirs false
zstyle ':completion::complete:*' use-cache 1
