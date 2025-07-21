#!/usr/bin/env bash
# Useful aliases with colors

# File listing aliases
alias ls='eza --color=auto --icons'
alias ll='eza -la --color=auto --icons --git'
alias la='eza -a --color=auto --icons'
alias tree='eza --tree --color=auto --icons'
alias cat='bat --style=plain'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# Enhanced directory navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias ~='cd ~'
alias -- -='cd -'

# File operations with confirmations
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# Git aliases
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline'
alias gd='git diff'

# Django aliases
alias runserver='python manage.py runserver'
alias migrate='python manage.py migrate'
alias makemigrations='python manage.py makemigrations'
alias createsuperuser='python manage.py createsuperuser'
alias shell='python manage.py shell'
alias dbshell='python manage.py dbshell'

# PostgreSQL aliases
alias pg-connect='psql -U essayadmin -d essaycoach -h localhost -p $PGPORT'
alias pg-logs='tail -f .dev_pg/logfile'
alias pg-status='pg_ctl -D "$PGDATA" status'

# FZF configuration for fuzzy finding
export FZF_DEFAULT_COMMAND='find . -type f -not -path "*/\.*" 2>/dev/null'
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border --preview "bat --color=always --style=numbers --line-range=:500 {}" 2>/dev/null'

# Bind Ctrl+R to fzf history search
if command -v fzf >/dev/null 2>&1; then
    alias hf='history | fzf --tac --no-sort | sed "s/^[[:space:]]*[0-9]*[[:space:]]*//" | tr -d "\n" | xargs -0 -I {} bash -c "{}"'
fi

# Overmind aliases for easy development
alias dev='env overmind start'
alias dev-stop='overmind kill'
alias dev-restart='overmind restart'
alias dev-logs='overmind connect'