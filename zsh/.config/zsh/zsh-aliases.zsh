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
alias ls='exa -al --color=always --group-directories-first' # my preferred listing
alias la='exa -a --color=always --group-directories-first'  # all files and dirs
alias ll='exa -l --color=always --group-directories-first'  # long format
alias lt='exa -aT --color=always --group-directories-first' # tree listing

# bat
alias cat='bat'
