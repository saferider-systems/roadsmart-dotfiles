#!/usr/bin/env bash

# ------------------------
# History
# ------------------------
HISTSIZE=10000
SAVEHIST=10000

# ------------------------
# PATHs
# ------------------------
# Local bin
export PATH="$HOME/.local/bin:$PATH"
# NodeJS global packages
export PATH="$HOME/.npm-global/bin:$PATH"
# Go
export GOENV="$HOME/.go/env"
export GOROOT="/usr/local/go"
export GOPATH="$HOME/.go"
export GOBIN="$GOPATH/bin"
export PATH="$GOENV:$GOBIN:$GOROOT/bin:$PATH"
# Rust/Cargo
export PATH="$HOME/.cargo/bin:$PATH"
# Python
export PATH="/usr/local/python2.7/bin:$PATH"
# Neovim
export PATH="$HOME/.local/bin/nvim/bin:$PATH"
# ------------------------
# Pager & Man
# ------------------------
export MANPAGER="sh -c 'col -bx | batcat -l man -p'"
export MANROFFOPT="-c"
export MANWIDTH=999

# ------------------------
# FZF & NNN (CLI Tools)
# ------------------------
export FZF_DEFAULT_COMMAND='ag --hidden --ignore .git -g ""'
export NNN_PLUG='r:renamer'
export NNN_TRASH=1
export NNN_COLORS='#27272727'
export NNN_FCOLORS='c1e2272e006033f7c6d6abc4'

# ------------------------
# Editor & Browser
# ------------------------
export EDITOR="/usr/bin/nvim"

# ------------------------
# Terminal
# ------------------------
export TERM="xterm-256color"

# ------------------------
# Disable Python Prompt
# ------------------------
export VIRTUAL_ENV_DISABLE_PROMPT=1
