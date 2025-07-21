#!/usr/bin/env bash
cd backend

# Use the current shell's environment directly
export PYTHONPATH="$PWD/..:$PYTHONPATH"
export DJANGO_SETTINGS_MODULE="essay_coach.settings"
export DATABASE_URL="postgresql://essayadmin:changeme@localhost:5432/essaycoach"
export DJANGO_SECRET_KEY="dev-secret-key-change-in-production"

echo "Starting Django development server..."
echo "Using Python: $(which python)"
echo "Django settings: $DJANGO_SETTINGS_MODULE"

# Test if Django is available in the current environment
if python -c "import django; print(f'Django {django.get_version()} found')" 2>/dev/null; then
    echo "Django is available, running migrations and starting server..."
    
    # Run database migrations
    echo "Running Django migrations..."
    python manage.py migrate --noinput
    
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