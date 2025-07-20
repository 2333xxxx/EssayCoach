# EssayCoach Database Setup Guide

This project provides **two different PostgreSQL setups** for development. Understanding when and how to use each one will help you choose the right approach for your needs.

## 🎯 Quick Summary

| Feature | Docker PostgreSQL | Nix PostgreSQL |
|---------|------------------|----------------|
| **Port** | 5432 | 5433+ (auto-detected) |
| **Data Persistence** | ✅ Persistent | ❌ Temporary |
| **Startup** | Manual (`docker-compose up`) | Automatic (`nix develop`) |
| **Use Case** | Production-like testing | Quick development |
| **Cleanup** | Manual | Automatic on exit |

## 🐳 Option 1: Docker PostgreSQL (Port 5432)

### What it is:
A containerized PostgreSQL instance that closely mimics production environments.

### When to use:
- **Schema development** - When you want to preserve your database schema between sessions
- **Data persistence** - When you need to keep test data across development sessions  
- **Production testing** - When you want to test against a production-like environment
- **Team collaboration** - When you want consistent database state across team members

### How it works:
```bash
# Start the database
docker-compose up -d postgres

# Connect using psql
psql -h localhost -p 5432 -U essayadmin -d essaycoach

# Stop the database
docker-compose down
```

### Data storage:
- **Persistent data**: `./docker/db/data/` (git-ignored)
- **Init scripts**: `./docker/db/init/` (version controlled)
- **Configuration**: Environment variables in `docker-compose.yml`

### Init Scripts Directory (this folder):
Place any `.sql` files in this directory and they will be executed **once** when the container is first created. The `docker-compose.yml` mounts this directory at `/docker-entrypoint-initdb.d` so that PostgreSQL will run them automatically.

**Example workflow:**
1. Design your schema in PgModeler → export as `01_schema.sql` to this folder
2. (Optional) Add seed data in `02_seed.sql`  
3. Run `docker-compose up -d postgres` to start the database with schema & seed data loaded

## ⚡ Option 2: Nix Development PostgreSQL (Port 5433+)

### What it is:
A lightweight, temporary PostgreSQL instance that starts automatically when you enter the development environment.

### When to use:
- **Quick development** - When you want to start coding immediately without setup
- **Fresh testing** - When you want a clean database for each development session
- **Lightweight work** - When you don't need persistent data
- **Isolation** - When you want to avoid conflicts with other PostgreSQL instances

### How it works:
```bash
# Start development environment (auto-starts PostgreSQL)
nix develop

# The output will show you the assigned port:
# [dev-pg] PostgreSQL started on port 5433.
# [dev-pg] Database 'essaycoach' with user 'essayadmin' is ready.

# Connect using the environment variables
psql -h $PGHOST -p $PGPORT -U essayadmin -d essaycoach

# Exit the shell (auto-stops and cleans up PostgreSQL)
exit
```

### Smart port detection:
The Nix setup automatically finds an available port starting from 5433:
- If 5433 is free → uses 5433
- If 5433 is busy → tries 5434, 5435, etc.
- Avoids conflicts with Docker PostgreSQL (5432)
- Tests up to port 5500

### Data lifecycle:
```bash
nix develop     # → Creates .dev_pg/ directory with fresh database
# ... do development work ...
exit           # → Stops PostgreSQL and deletes .dev_pg/ directory
```

## 🔧 Connection Details

Both setups use identical credentials for easy switching:

```bash
# Database credentials (same for both)
POSTGRES_USER=essayadmin
POSTGRES_PASSWORD=changeme
POSTGRES_DB=essaycoach
POSTGRES_HOST=localhost

# Only the port differs:
DOCKER_PORT=5432        # Docker PostgreSQL
NIX_PORT=5433+          # Nix PostgreSQL (auto-detected)
```

## 🚀 Getting Started

### For Schema Development:
```bash
# 1. Use Docker for persistent schema work
docker-compose up -d postgres

# 2. Create your schema files in this directory
echo "CREATE TABLE users (id SERIAL PRIMARY KEY, name VARCHAR(100));" > 01_schema.sql

# 3. Restart to apply init scripts
docker-compose down && docker-compose up -d postgres
```

### For Quick Development:
```bash
# Just start coding - PostgreSQL auto-starts
nix develop

# Your database is ready immediately!
# Check the port in the startup message
```

## 🔍 Troubleshooting

### "Port 5432 already in use"
- **Docker**: Another PostgreSQL is running. Stop it or use different port in `docker-compose.yml`
- **Nix**: No problem! It automatically finds the next available port

### "Connection refused"  
- **Docker**: Run `docker-compose up -d postgres` first
- **Nix**: Make sure you're inside the `nix develop` shell

### "Database doesn't exist"
- **Docker**: Check if init scripts ran. Restart with `docker-compose down && docker-compose up -d postgres`
- **Nix**: Database is created automatically. If issues persist, exit and re-enter the shell

### Data disappeared
- **Docker**: Check `./docker/db/data/` directory exists and has correct permissions
- **Nix**: This is expected behavior! Data is temporary and cleaned up on exit

## 💡 Pro Tips

1. **Use Docker for schema design** and **Nix for quick coding**
2. **Environment variables** are set automatically in the Nix shell (`$PGHOST`, `$PGPORT`)
3. **Both databases** can run simultaneously on different ports
4. **Init scripts** only run once when Docker container is first created
5. **Clean slate**: Delete `./docker/db/data/` to reset Docker database completely

## 🔗 Related Files

- `docker-compose.yml` - Docker PostgreSQL configuration
- `flake.nix` - Nix PostgreSQL setup in shellHook
- `.env.sample` - Environment variable examples
- `.gitignore` - Excludes data directories and temporary files 