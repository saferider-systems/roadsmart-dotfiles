#!/usr/bin/env bash

# docker
alias docker-containers-all='docker ps -a --format "table {{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}"'
alias docker-images-all='docker images --format "table {{.Repository}}\t{{.Tag}}\t{{.ID}}\t{{.Size}}"'
alias docker-compose-up='docker compose up -d'
alias dcupf='docker compose up -d && docker compose --follow logs'
alias docker-compose-down='docker compose down -v'
alias docker-remove-containers='docker rm $(docker ps -a -q)'
alias docker-remove-images='docker rmi $(docker images -a -q)'
alias docker-compose-build='docker compose up --build'
alias docker-start='docker start $(docker ps -a -q)'
alias docker-stop='docker stop $(docker ps -a -q)'
alias docker-prune='docker system prune --all'
alias docker-volume-prune='docker volume rm $(docker volume ls)'
alias docker-remove-dangling-images='docker rmi $(docker images -f "dangling=true" -q)'

# Changing "ls" to "exa"
alias la='exa -al --color=always --group-directories-first'  # all files and dirs

# bat
alias cat='batcat'

# NvChad
nvim_cd() {
    local target_dir="${1:-.}"  # Default to current directory
    
    if [ ! -d "$target_dir" ]; then
        echo "Error: Directory '$target_dir' not found"
        return 1
    fi
    
    local current_dir="$(pwd)"
    cd "$target_dir" || return 1
    nvim "$@"
    cd "$current_dir"
}
alias configrc='nvim_cd ~/.config/'
alias nvimrc='nvim_cd ~/.config/nvim'
alias zshrc='nvim_cd ~/.config/zsh'
alias nv='nvim'
alias Nv='sudo nvim'

# nnn
alias n='nnn -dr'
alias N='doas nnn -drx'

# git
alias addup='git add'
alias addall='git add .'
alias branch='git branch'
alias checkout='git checkout'
alias clone='git clone'
alias commit='git commit'
alias fetch='git fetch'
alias stat='git status'  # 'status' is protected name so using 'stat' instead
alias tag='git tag'
alias newtag='git tag -a'
alias merge='git merge'

# easier to read disk
alias df='df -h'     # human-readable sizes
alias free='free -m' # show sizes in MB
