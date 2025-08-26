#!/usr/bin/env bash
# Environment variables for development

# Python environment variables
export PYTHONPATH="$PWD:$PYTHONPATH"
export DJANGO_SETTINGS_MODULE="essay_coach.settings"
export DJANGO_SECRET_KEY="dev-secret-key-change-in-production"
# Use postgres superuser for development simplicity
export PGPORT=${PGPORT:-5432}
export DATABASE_URL="postgresql://postgres:postgres@localhost:${PGPORT}/essaycoach"