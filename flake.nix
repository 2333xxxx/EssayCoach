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
            # Shell Configuration
            zsh
            zsh-autosuggestions
            zsh-syntax-highlighting
            zsh-completions
            oh-my-zsh
            starship
            zsh-powerlevel10k
            spaceship-prompt
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
            # ---------- Zsh Configuration ----------
            # Create a temporary zshrc for this session
            export ZDOTDIR="$PWD/.nix-zsh"
            mkdir -p "$ZDOTDIR"
            
            # Create Starship configuration
            cat > "$ZDOTDIR/starship.toml" << 'EOF'
# Starship configuration for EssayCoach development

format = """
$username\
$hostname\
$directory\
$git_branch\
$git_state\
$git_status\
$cmd_duration\
$line_break\
$python\
$nodejs\
$character"""

[directory]
style = "blue"

[character]
success_symbol = "[❯](purple)"
error_symbol = "[❯](red)"
vicmd_symbol = "[❮](green)"

[git_branch]
symbol = "🌱 "
format = "[$symbol$branch]($style) "
style = "bright-green"

[git_status]
format = '([\[$all_status$ahead_behind\]]($style) )'
style = "cyan"

[git_state]
format = '\([$state( $progress_current/$progress_total)]($style)\) '
style = "bright-black"

[cmd_duration]
format = "[$duration]($style) "
style = "yellow"

[python]
symbol = "🐍 "
format = '[$symbol$pyenv_prefix($version )(\($virtualenv\) )]($style)'

[nodejs]
symbol = "⬢ "
format = '[$symbol($version )]($style)'
EOF

            export STARSHIP_CONFIG="$ZDOTDIR/starship.toml"
            
            cat > "$ZDOTDIR/.zshrc" << 'EOF'
# Zsh configuration for EssayCoach development environment

# Enable completion system
autoload -U compinit && compinit

# Source zsh plugins
source ${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source ${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Add completions
fpath=(${pkgs.zsh-completions}/share/zsh/site-functions $fpath)

# ========== THEME CONFIGURATION ==========
# Choose your theme by uncommenting ONE of the following options:

# Option 1: Starship (Modern, fast, customizable)
eval "$(${pkgs.starship}/bin/starship init zsh)"

# Option 2: Powerlevel10k (Feature-rich, highly customizable)
# source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme

# Option 3: Spaceship (Minimalist, git-aware)
# source ${pkgs.spaceship-prompt}/lib/spaceship.zsh-theme

# Option 4: Oh-My-Zsh built-in themes
# export ZSH="${pkgs.oh-my-zsh}/share/oh-my-zsh"
# ZSH_THEME="robbyrussell"  # or "agnoster", "avit", "bira", etc.
# source $ZSH/oh-my-zsh.sh

# Basic zsh options
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt SHARE_HISTORY
setopt AUTO_CD

# Aliases for common development tasks
alias ll='ls -la'
alias la='ls -A'
alias l='ls -CF'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# Project-specific aliases (PGPORT will be available when PostgreSQL starts)
alias pg-connect='psql -U essayadmin -d essaycoach -h localhost -p $PGPORT'
alias pg-logs='tail -f .dev_pg/logfile'

echo "🚀 EssayCoach development environment ready!"
echo "📦 Zsh configured with autosuggestions and syntax highlighting"
echo "💡 Useful aliases: ll, la, pg-connect, pg-logs"
EOF

            # Set zsh as the shell and execute it with our config
            export SHELL=${pkgs.zsh}/bin/zsh
            
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
                  psql -U essayadmin -p "$PGPORT" -h "$PGHOST" -d essaycoach -f docker/db/init/00_init.sql >/dev/null 2>&1
                  if [ $? -eq 0 ]; then
                    echo "[dev-pg] Schema loaded successfully."
                  else
                    echo "[dev-pg] WARNING: Failed to load schema. You may need to load it manually."
                  fi
                else
                  echo "[dev-pg] Database already contains tables. Skipping schema load."
                fi

                echo "[dev-pg] Loading mock data..."
                psql -U essayadmin -p "$PGPORT" -h "$PGHOST" -d essaycoach -f docker/db/init/01_add_data.sql >/dev/null 2>&1
                if [ $? -eq 0 ]; then
                  echo "[dev-pg] Mock data loaded successfully."
                else
                  echo "[dev-pg] WARNING: Failed to load mock data. You may need to load it manually."
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

            # The 'trap' command ensures cleanup_on_exit is called when the shell exits.
            trap cleanup_on_exit EXIT
            # ---------------------------------------------------
            
            # Start zsh with our configuration
            exec ${pkgs.zsh}/bin/zsh
          '';
        };
      });
    };
}
