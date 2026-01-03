#!/usr/bin/env bash

# autoload vsc and colors
autoload -Uz vcs_info
autoload -U colors && colors

# enable only git
zstyle ':vcs_info:*' enable git

# change zsh cursor shape
fix_cursor() {
    echo -ne '\e[6 q'
}

precmd_functions+=(fix_cursor)

precmd() {
    vcs_info
    prompt_git
    prompt_conda
}

setopt PROMPT_SUBST

prompt_git() {
    if [[ -n ${vcs_info_msg_0_} ]]; then
        GIT_STATUS=$(command git status --porcelain 2> /dev/null | tail -n1)
        GIT_BRANCH=$(git symbolic-ref HEAD | sed 's!refs\/heads\/!!')
        if [[ -n $GIT_STATUS ]]; then
            PROMPT_GIT_INFO="%F{1} %f:%F{1}$GIT_BRANCH%f "
        else
            PROMPT_GIT_INFO="%F{2} %f:%F{2}$GIT_BRANCH%f "
        fi
    else 
        PROMPT_GIT_INFO=""
    fi
}

prompt_conda() {
    if [[ -n $CONDA_DEFAULT_ENV ]]; then
        PROMPT_CONDA_ENV="%F{2} %f:%F{2}$CONDA_DEFAULT_ENV%f "
    else
        PROMPT_CONDA_ENV=""
    fi
}

NEWLINE=$'\n'
PROMPT='%F{202}[%F{214}%n%F{190}@%F{45}%m%F{202}]%f %F{256}at %F{214}%T %F{256}in %F{6}%~%f ${PROMPT_GIT_INFO}${PROMPT_CONDA_ENV}${NEWLINE}%F{256}%f '
# PROMPT='%F{2}%n@%m%f %F{256}at %F{214}%T %F{256}in %F{6}%~%f ${PROMPT_GIT_INFO}${PROMPT_CONDA_ENV}${NEWLINE}%F{6}%f '
