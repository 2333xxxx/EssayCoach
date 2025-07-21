#!/usr/bin/env bash
# Enhanced Bash Configuration

# Force bash shell for this environment
export SHELL="$(which bash)"

# Enable bash completion
BASH_COMPLETION_PATH="$(find /nix/store -name bash_completion -type f -path "*/share/bash-completion/*" 2>/dev/null | head -1)"
if [ -f "$BASH_COMPLETION_PATH" ]; then
    source "$BASH_COMPLETION_PATH"
fi

# Enhanced readline configuration for better editing
export INPUTRC="$PWD/.nix-inputrc"
cat > "$INPUTRC" << 'EOF'
# Enhanced readline configuration
set editing-mode emacs
set completion-ignore-case on
set completion-map-case on
set show-all-if-ambiguous on
set completion-query-items 200
set page-completions off
set bell-style none
set colored-stats on
set colored-completion-prefix on
set menu-complete-display-prefix on

# History search with arrow keys
"\e[A": history-search-backward
"\e[B": history-search-forward

# Improved word movement
"\e[1;5C": forward-word
"\e[1;5D": backward-word

# Quick directory navigation
"\C-l": clear-screen
EOF

# Enhanced bash history
export HISTCONTROL=ignoreboth:erasedups
export HISTSIZE=10000
export HISTFILESIZE=20000
export HISTTIMEFORMAT="%Y-%m-%d %H:%M:%S "
shopt -s histappend
shopt -s checkwinsize
shopt -s autocd
shopt -s cdspell
shopt -s dirspell