#!/usr/bin/env bash
set -Eeuo pipefail

cd frontend

# Ensure pnpm exists and show versions for clarity
if ! command -v pnpm >/dev/null 2>&1; then
  echo "ERROR: pnpm is not installed or not on PATH" >&2
  exit 1
fi

echo "Using Node: $(node -v), pnpm: $(pnpm -v)"

# New frontend template uses Vite config for port/envs and .env.* files.
# Avoid reinstalling on every run; install only if node_modules is missing.
need_install=0
if [ ! -d node_modules ]; then
  need_install=1
else
  # If key dev deps are missing (e.g., after template change), install
  if [ ! -d node_modules/@vitejs/plugin-vue-jsx ] || [ ! -d node_modules/@vitejs/plugin-vue ]; then
    need_install=1
  fi
fi

if [ "$need_install" -eq 1 ]; then
  echo "Installing frontend dependencies..."
  pnpm install --silent
else
  echo "Dependencies look OK; skipping install. Run 'pnpm i' if needed."
fi

echo "Starting Vite development server (mode: test)..."
# package.json -> scripts.dev: "vite --mode test"
pnpm run dev
