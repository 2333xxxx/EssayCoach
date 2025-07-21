#!/usr/bin/env bash
# Enhanced colorful and informative prompt

setup_prompt() {
    # Colors
    local RED='\[\033[0;31m\]'
    local GREEN='\[\033[0;32m\]'
    local YELLOW='\[\033[0;33m\]'
    local BLUE='\[\033[0;34m\]'
    local PURPLE='\[\033[0;35m\]'
    local CYAN='\[\033[0;36m\]'
    local WHITE='\[\033[0;37m\]'
    local BOLD='\[\033[1m\]'
    local RESET='\[\033[0m\]'
    
    # Git branch function
    git_branch() {
        local branch=$(git branch 2>/dev/null | grep '^*' | colrm 1 2)
        if [ "$branch" ]; then
            local status=""
            if ! git diff --quiet 2>/dev/null; then
                status=" ±"
            fi
            echo " ($branch$status)"
        fi
    }
    
    # Set the prompt
    PS1="$GREEN\u$WHITE@$BLUE\h$WHITE:$PURPLE\w$YELLOW\$(git_branch)$WHITE\$ $RESET"
}

setup_prompt