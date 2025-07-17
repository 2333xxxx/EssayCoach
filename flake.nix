{
  description = "A development environment for EssayCoach";

  inputs = {
    # --- Nixpkgs Source Selection ---
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  nixConfig = {
    extra-substituters = [
      "https://mirrors.sjtug.sjtu.edu.cn/nix-channels/store?priority=5"
    ];
    extra-trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    ];
  };

  outputs = { self, nixpkgs }:
    let
      supportedSystems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
      forEachSupportedSystem = f: nixpkgs.lib.genAttrs supportedSystems (system: f {
        pkgs = import nixpkgs {
          inherit system;
          config = {};
          overlays = [];
        };
      });
    in
    {
      devShells = forEachSupportedSystem ({ pkgs }: {
        default = pkgs.mkShell {
          packages = with pkgs; [
            docker-compose
            docker
            # Shell enhancements
            bash-completion
            readline
            fzf
            bat
            eza
            tree
            git
            # Frontend Development (Vue.js 3 + Vite)
            pnpm
            nodejs_22
            nodePackages.prettier
            nodePackages.typescript
            nodePackages.eslint
            nodePackages."@vue/language-server"

            # Backend Development (Python FastAPI + AI/ML)
            postgresql # database
            python311
            python311Packages.pip
            python311Packages.virtualenv
            black
            python311Packages.flake8
            python311Packages.mypy
            python311Packages.django
            python311Packages.fastapi
            python311Packages.uvicorn
          ];
          shellHook = ''
            # Force bash shell for this environment
            export SHELL=${pkgs.bash}/bin/bash
            
            # ---------- Enhanced Bash Configuration ----------
            
            # Enable bash completion
            if [ -f ${pkgs.bash-completion}/share/bash-completion/bash_completion ]; then
                source ${pkgs.bash-completion}/share/bash-completion/bash_completion
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
            
            # Colorful and informative prompt
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
            
            # Useful aliases with colors
            alias ls='${pkgs.eza}/bin/eza --color=auto --icons'
            alias ll='${pkgs.eza}/bin/eza -la --color=auto --icons --git'
            alias la='${pkgs.eza}/bin/eza -a --color=auto --icons'
            alias tree='${pkgs.eza}/bin/eza --tree --color=auto --icons'
            alias cat='${pkgs.bat}/bin/bat --style=plain'
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
            
            # FZF configuration for fuzzy finding
            export FZF_DEFAULT_COMMAND='find . -type f -not -path "*/\.*" 2>/dev/null'
            export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border --preview "${pkgs.bat}/bin/bat --color=always --style=numbers --line-range=:500 {}" 2>/dev/null'
            
            # Bind Ctrl+R to fzf history search
            if command -v fzf >/dev/null 2>&1; then
                bind '"\C-r": "\C-a hf \C-j"'
                alias hf='history | ${pkgs.fzf}/bin/fzf --tac --no-sort | sed "s/^[[:space:]]*[0-9]*[[:space:]]*//" | tr -d "\n" | xargs -0 -I {} bash -c "{}"'
            fi
            
            # ---------- Local PostgreSQL Dev Cluster ----------
            # This block ensures a self-contained PostgreSQL instance is available
            # whenever you run `nix develop`. It stores data in .dev_pg/
            # (git-ignored) and is only accessible on localhost via a dynamically
            # assigned port.
            #
            # On shell exit, the database is stopped, and the data directory is
            # removed to ensure a clean start for the next session.

            export PGDATA="$PWD/.dev_pg"
            export PGHOST="localhost"

            start_local_pg() {
              # Init DB if it doesn't exist
              if [ ! -d "$PGDATA" ]; then
                echo "Initializing PostgreSQL data directory..."
                initdb -D "$PGDATA" --auth=trust --no-locale --encoding=UTF8 -U postgres >/dev/null
              fi

              # Start if not already running
              if ! pg_ctl -D "$PGDATA" status > /dev/null; then
                echo "[dev-pg] Starting PostgreSQL..."
                
                # Find an available port starting from 5433 (avoiding system default 5432)
                # Use a more robust method that doesn't rely on netstat and reduces race conditions
                export PGPORT=""
                for port in $(seq 5433 5500); do
                  # Try to bind to the port using a simple TCP test
                  if ! (exec 3<>/dev/tcp/localhost/$port) 2>/dev/null; then
                    export PGPORT=$port
                    exec 3<&-
                    exec 3>&-
                    break
                  else
                    exec 3<&-
                    exec 3>&-
                  fi
                done
                
                if [ -z "$PGPORT" ]; then
                  echo "[dev-pg] ERROR: Could not find an available port in range 5433-5500"
                  echo "[dev-pg] All ports in the range appear to be in use."
                  return 1
                fi
                
                if ! pg_ctl -D "$PGDATA" -o "-p $PGPORT" -l "$PGDATA/logfile" -w start; then
                  echo "[dev-pg] ERROR: Failed to start PostgreSQL. Check logs at '$PGDATA/logfile'."
                  return 1
                fi

                echo "[dev-pg] PostgreSQL started on port $PGPORT."

                # Ensure default role & database exist
                psql -U postgres -p "$PGPORT" -h "$PGHOST" -tc "SELECT 1 FROM pg_roles WHERE rolname = 'essayadmin'" | grep -q 1 || \
                  psql -U postgres -p "$PGPORT" -h "$PGHOST" -c "CREATE ROLE essayadmin LOGIN PASSWORD 'changeme';" >/dev/null

                psql -U postgres -p "$PGPORT" -h "$PGHOST" -tc "SELECT 1 FROM pg_database WHERE datname = 'essaycoach'" | grep -q 1 || \
                  psql -U postgres -p "$PGPORT" -h "$PGHOST" -c "CREATE DATABASE essaycoach OWNER essayadmin;" >/dev/null

                echo "[dev-pg] Database 'essaycoach' with user 'essayadmin' is ready."
                
                # Load schema if database is empty (no tables exist)
                if ! psql -U essayadmin -p "$PGPORT" -h "$PGHOST" -d essaycoach -tc "SELECT 1 FROM information_schema.tables WHERE table_schema = 'public' LIMIT 1;" | grep -q 1; then
                  echo "[dev-pg] Loading database schema..."
                  psql -U essayadmin -p "$PGPORT" -h "$PGHOST" -d essaycoach -f docker/db/init/00_init.sql
                  if [ $? -eq 0 ]; then
                    echo "[dev-pg] Schema loaded successfully."
                  else
                    echo "[dev-pg] ERROR: Failed to load schema."
                  fi
                else
                  echo "[dev-pg] Database already contains tables. Skipping schema load."
                fi

                echo "[dev-pg] Loading mock data..."
                psql -U essayadmin -p "$PGPORT" -h "$PGHOST" -d essaycoach -f docker/db/init/01_add_data.sql
                if [ $? -eq 0 ]; then
                  echo "[dev-pg] Mock data loaded successfully."
                else
                  echo "[dev-pg] ERROR: Failed to load mock data."
                fi
              else
                # If already running, retrieve port from the pid file
                export PGPORT=$(head -n 4 "$PGDATA/postmaster.pid" | tail -n 1)
                echo "[dev-pg] PostgreSQL is already running on port $PGPORT."
              fi
            }

            # Stop the server and remove the data directory on exit.
            cleanup_on_exit() {
                echo -e "\n[dev-pg] Exiting shell. Cleaning up PostgreSQL..."
                # Stop the server managed by our PGDATA directory.
                if pg_ctl -D "$PGDATA" status > /dev/null; then
                    pg_ctl -D "$PGDATA" -w -m fast stop >/dev/null
                fi
                rm -rf "$PGDATA"
                echo "[dev-pg] Cleanup complete."
            }

            start_local_pg

            # Project-specific aliases (PGPORT will be available when PostgreSQL starts)
            alias pg-connect='psql -U essayadmin -d essaycoach -h localhost -p $PGPORT'
            alias pg-logs='tail -f .dev_pg/logfile'
            alias pg-status='pg_ctl -D "$PGDATA" status'
            
            # The 'trap' command ensures cleanup_on_exit is called when the shell exits.
            trap cleanup_on_exit EXIT
            
            echo "🚀 EssayCoach development environment ready!"
            echo "📦 Enhanced Bash with completions, colors, and shortcuts"
            echo "💡 Useful aliases: ll, tree, cat (bat), pg-connect, pg-logs"
            echo "🔍 Use Ctrl+R for fuzzy history search, 'hf' for history finder"
            echo "📂 Current directory: $(pwd)"
          '';
        };
      });
    };
}
