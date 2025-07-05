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
            # This block ensures a self-contained PostgreSQL instance is
            # available whenever you run `nix develop`. It stores data in
            # .dev_pg/ (git-ignored) and is *only* accessible on localhost:5432.

            export PGDATA="$PWD/.dev_pg"
            export PGPORT="5432"
            export PGHOST="localhost"

            start_local_pg() {
              # Init DB if it doesn't exist
              if [ ! -d "$PGDATA" ]; then
                echo "[dev-pg] Initializing cluster in $PGDATA …"
                initdb -D "$PGDATA" --username=postgres --encoding=UTF8 >/dev/null
              fi

              # Start if not already running
              if ! pg_isready -q -h "$PGHOST" -p "$PGPORT"; then
                echo "[dev-pg] Starting PostgreSQL on port $PGPORT …"
                pg_ctl -D "$PGDATA" -o "-p $PGPORT" -l "$PGDATA/postgres.log" -w start

                # Ensure default role & database exist
                psql -U postgres -p "$PGPORT" -h "$PGHOST" -tc "SELECT 1 FROM pg_roles WHERE rolname = 'essayadmin'" | grep -q 1 || \
                  psql -U postgres -p "$PGPORT" -h "$PGHOST" -c "CREATE ROLE essayadmin LOGIN PASSWORD 'changeme';"

                psql -U postgres -p "$PGPORT" -h "$PGHOST" -tc "SELECT 1 FROM pg_database WHERE datname = 'essaycoach'" | grep -q 1 || \
                  psql -U postgres -p "$PGPORT" -h "$PGHOST" -c "CREATE DATABASE essaycoach OWNER essayadmin;"

                echo "[dev-pg] Database 'essaycoach' with user 'essayadmin' ready."
              fi
            }

            start_local_pg
            # ---------------------------------------------------
          '';
        };
      });
    };
}
