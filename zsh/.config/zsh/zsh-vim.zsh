#!/usr/bin/env bash

export ZVM_CURSOR_STYLE_ENABLED=false
function zle-keymap-select {
    if [[ ${KEYMAP} == vicmd ]] || [[ $1 = 'block' ]]; then
        echo -ne '\e[1 q'
    elif [[ ${KEYMAP} == main ]] || [[ ${KEYMAP} == viins ]] || [[ ${KEYMAP} = '' ]] || [[ $1 = 'beam' ]]; then
        echo -ne '\e[5 q'
    fi
}

zle -N zle-keymap-select

# fix_cursor() {
#     echo -ne '\e[5;#00FF00\a'
# }

# precmd_functions+=(fix_cursor)

# keybindings
bindkey '^A' beginning-of-line
bindkey '^E' end-of-line
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
