#!/usr/bin/env bash
cd frontend

# Explicitly preserve PATH
export PATH="$PATH"

# Set Vite environment variables
export VITE_APP_PORT=4318
export VITE_APP_TITLE="EssayCoach Development"
export VITE_APP_API_URL="http://localhost:8000"

echo "Installing frontend dependencies..."
pnpm install --silent

echo "Starting Vite development server..."
pnpm vite