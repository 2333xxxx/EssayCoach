{
  description = "A development environment for EssayCoach";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/25.05";
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
                for port in $(seq 5433 5500); do
                  if ! netstat -ln | grep -q ":$port "; then
                    export PGPORT=$port
                    break
                  fi
                done
                
                if [ -z "$PGPORT" ]; then
                  echo "[dev-pg] ERROR: Could not find an available port in range 5433-5500"
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
              else
                # If already running, retrieve port from the pid file
                export PGPORT=$(head -n 5 "$PGDATA/postmaster.pid" | tail -n 1)
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
