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
          ];
          shellHook = ''
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
          '';
        };
      });
    };
}
