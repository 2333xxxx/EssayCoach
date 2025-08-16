#!/usr/bin/env bash
cd backend

# Use the current shell's environment directly
export PYTHONPATH="$PWD/..:$PYTHONPATH"
export DJANGO_SETTINGS_MODULE="essay_coach.settings"
export DATABASE_URL="postgresql://postgres:postgres@localhost:5432/essaycoach"
export DJANGO_SECRET_KEY="dev-secret-key-change-in-production"

# PostgreSQL configuration
export PGDATA="$PWD/../.dev_pg"
export PGHOST="localhost"
export PGPORT=5432
export POSTGRES_DB="essaycoach"
export POSTGRES_USER="postgres"
export POSTGRES_PASSWORD="postgres"
export POSTGRES_HOST="localhost"
export POSTGRES_PORT="5432"

# Ensure socket directory exists
mkdir -p "$PWD/../.pg_socket"

echo "Starting Django development server..."
echo "Using Python: $(which python)"
echo "Django settings: $DJANGO_SETTINGS_MODULE"

# Function to check if PostgreSQL is running
check_postgres() {
    pg_ctl -D "$PGDATA" status >/dev/null 2>&1
}

# Function to start PostgreSQL
start_postgres() {
    echo "[dev-pg] Starting PostgreSQL..."
    
    # Initialize if not exists
    if [ ! -d "$PGDATA" ]; then
        echo "[dev-pg] Initializing PostgreSQL data directory..."
        initdb -D "$PGDATA" --auth=trust --no-locale --encoding=UTF8 -U postgres >/dev/null
    fi
    
    # Start PostgreSQL with custom socket directory
    if ! pg_ctl -D "$PGDATA" -o "-k $PWD/../.pg_socket -p $PGPORT" -l "$PGDATA/logfile" -w start; then
        echo "[dev-pg] ERROR: Failed to start PostgreSQL"
        cat "$PGDATA/logfile" 2>/dev/null || echo "No log file found"
        return 1
    fi
    
    echo "[dev-pg] PostgreSQL started successfully"
    
    # Create database if it doesn't exist (using postgres superuser)
    psql -U postgres -p "$PGPORT" -h "$PGHOST" -tc "SELECT 1 FROM pg_database WHERE datname = '$POSTGRES_DB'" | grep -q 1 || \
        psql -U postgres -p "$PGPORT" -h "$PGHOST" -c "CREATE DATABASE $POSTGRES_DB OWNER postgres;" >/dev/null
    
    echo "[dev-pg] Database '$POSTGRES_DB' with postgres superuser is ready"
    
    # Load schema if database is empty
    if ! psql -U "$POSTGRES_USER" -p "$PGPORT" -h "$PGHOST" -d "$POSTGRES_DB" -tc "SELECT 1 FROM information_schema.tables WHERE table_schema = 'public' LIMIT 1;" 2>/dev/null | grep -q 1; then
        echo "[dev-pg] Loading database schema..."
        if psql -U postgres -p "$PGPORT" -h "$PGHOST" -d "$POSTGRES_DB" -f "$PWD/../docker/db/init/00_init.sql" >/dev/null 2>&1; then
            echo "[dev-pg] Schema loaded successfully"
            if psql -U postgres -p "$PGPORT" -h "$PGHOST" -d "$POSTGRES_DB" -f "$PWD/../docker/db/init/01_add_data.sql" >/dev/null 2>&1; then
                echo "[dev-pg] Mock data loaded successfully"
            fi
        fi
    fi
}

# Check and start PostgreSQL if needed
if ! check_postgres; then
    echo "[dev-pg] PostgreSQL is not running, starting it..."
    if ! start_postgres; then
        echo "[dev-pg] ERROR: Failed to start PostgreSQL"
        exit 1
    fi
else
    echo "[dev-pg] PostgreSQL is already running"
fi

# Wait for PostgreSQL to be ready
echo "[dev-pg] Waiting for PostgreSQL to be ready..."
max_attempts=30
attempt=1
while [ $attempt -le $max_attempts ]; do
    if psql -U "$POSTGRES_USER" -p "$PGPORT" -h "$PGHOST" -d "$POSTGRES_DB" -c "SELECT 1;" >/dev/null 2>&1; then
        echo "[dev-pg] PostgreSQL is ready"
        break
    fi
    echo "[dev-pg] Waiting for PostgreSQL... (attempt $attempt/$max_attempts)"
    sleep 1
    attempt=$((attempt + 1))
done

if [ $attempt -gt $max_attempts ]; then
    echo "[dev-pg] ERROR: PostgreSQL is not ready after $max_attempts attempts"
    exit 1
fi

# Test if Django is available in the current environment
if python -c "import django; print(f'Django {django.get_version()} found')" 2>/dev/null; then
    echo "Django is available, running migrations and starting server..."
    
    # Run database migrations
    echo "Running Django migrations..."
    python manage.py migrate --noinput

    # create a superuser if it doesn't exist
    echo "Ensuring default admin superuser exists..."
    python - <<'PY'
import os
from django.db import connection
from django.contrib.auth.hashers import make_password

# Target credentials
email_candidates = ['admin', 'admin@example.com']
password = 'admin'
hashed = make_password(password)

with connection.cursor() as cur:
    # Try to update existing admin-like user by email
    updated = False
    for email in email_candidates:
        cur.execute(
            'UPDATE "user"\n'
            'SET user_credential = %s, user_role = %s, user_status = %s,\n'
            '    is_superuser = TRUE, is_staff = TRUE, is_active = TRUE\n'
            'WHERE user_email = %s\n'
            'RETURNING user_id',
            [hashed, 'admin', 'active', email]
        )
        if cur.rowcount:
            updated = True
            break

    if not updated:
        # Insert a new admin user with the requested username/email 'admin'
        cur.execute('SELECT COALESCE(MAX(user_id)+1, 1) FROM "user"')
        next_id = cur.fetchone()[0]
        cur.execute(
            'INSERT INTO "user" (user_id, user_fname, user_lname, user_email, user_role, user_status, user_credential, is_superuser, is_staff, is_active)\n'
            'VALUES (%s, %s, %s, %s, %s, %s, %s, TRUE, TRUE, TRUE)',
            [next_id, 'Admin', 'User', 'admin', 'admin', 'active', hashed]
        )

print('Admin user ensured (email: "admin" or "admin@example.com")')
PY

    # Ensure default groups exist and add admin to 'admin' group
    echo "Ensuring default groups and admin membership..."
    python - <<'PY'
from django.db import connection

group_names = ['admin', 'lecturer', 'student']

with connection.cursor() as cur:
    # Create groups if missing
    for name in group_names:
        cur.execute('INSERT INTO auth_group (name) SELECT %s WHERE NOT EXISTS (SELECT 1 FROM auth_group WHERE name=%s)', [name, name])

    # Get admin user_id (prefer 'admin' email)
    cur.execute('SELECT user_id FROM "user" WHERE user_email = %s OR user_email = %s ORDER BY user_email = %s DESC LIMIT 1', ['admin', 'admin@example.com', 'admin'])
    row = cur.fetchone()
    if row:
        admin_id = row[0]
        # Find admin group id
        cur.execute('SELECT id FROM auth_group WHERE name = %s', ['admin'])
        gid = cur.fetchone()[0]
        # Assign membership if not exists
        cur.execute('INSERT INTO core_user_groups (user_id, group_id) SELECT %s, %s WHERE NOT EXISTS (SELECT 1 FROM core_user_groups WHERE user_id=%s AND group_id=%s)', [admin_id, gid, admin_id, gid])

print('Default groups ensured and admin added to admin group')
PY

    # Ensure custom permission and baseline group permissions (idempotent)
    echo "Ensuring core user permissions and assignments..."
    python - <<'PY'
from django.db import connection

# Get content_type id for core.user
with connection.cursor() as cur:
    cur.execute("SELECT id FROM django_content_type WHERE app_label=%s AND model=%s", ['core', 'user'])
    row = cur.fetchone()
    if not row:
        # In case content types not ready yet; skip silently
        raise SystemExit(0)
    ct_id = row[0]

    # Ensure custom permission exists
    cur.execute("""
        INSERT INTO auth_permission (name, content_type_id, codename)
        SELECT %s, %s, %s
        WHERE NOT EXISTS (
            SELECT 1 FROM auth_permission WHERE content_type_id=%s AND codename=%s
        )
    """, ['Can view student stats', ct_id, 'view_student_stats', ct_id, 'view_student_stats'])

    # Resolve permission ids we care about
    wanted = ['add_user','change_user','delete_user','view_user','view_student_stats']
    cur.execute(
        "SELECT codename, id FROM auth_permission WHERE content_type_id=%s AND codename = ANY(%s)",
        [ct_id, wanted]
    )
    perm_map = dict(cur.fetchall())

    # Resolve group ids
    cur.execute("SELECT name, id FROM auth_group WHERE name = ANY(%s)", [['admin','lecturer','student']])
    group_map = dict(cur.fetchall())

    def grant(group, codes):
        gid = group_map.get(group)
        if not gid:
            return
        for code in codes:
            pid = perm_map.get(code)
            if not pid:
                continue
            cur.execute(
                "INSERT INTO auth_group_permissions (group_id, permission_id)\n"
                "SELECT %s, %s\n"
                "WHERE NOT EXISTS (SELECT 1 FROM auth_group_permissions WHERE group_id=%s AND permission_id=%s)",
                [gid, pid, gid, pid]
            )

    # Admin: full perms
    grant('admin', wanted)
    # Lecturer: view_user + view_student_stats
    grant('lecturer', ['view_user','view_student_stats'])
    # Student: no model-level perms here

print('Core user permissions ensured and assigned to groups')
PY

    # Start the development server
    echo "Starting Django development server..."
    python manage.py runserver
else
    echo "ERROR: Django not found in Python environment"
    echo "Python version: $(python --version)"
    echo "Python executable: $(which python)"
    echo "Trying to import Django..."
    python -c "import django" || echo "Import failed"
    exit 1
fi
