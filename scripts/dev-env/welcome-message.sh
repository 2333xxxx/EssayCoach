#!/usr/bin/env bash
# Welcome message and startup information

echo "🚀 EssayCoach development environment ready!"
echo "📦 Enhanced Bash with completions, colors, and shortcuts"
echo "💡 Useful aliases: ll, tree, cat (bat), pg-connect, pg-logs, runserver, migrate"
echo "🔍 Use Ctrl+R for fuzzy history search, 'hf' for history finder"
echo "📂 Current directory: $(pwd)"
echo "🐍 Python environment configured with Django"
echo "🔗 Database URL: postgresql://essayadmin:changeme@localhost:$PGPORT/essaycoach"
echo ""
echo "🎯 Development servers can be managed with:"
echo "   dev          - Start both frontend and backend servers"
echo "   dev-stop     - Stop all servers"
echo "   dev-restart  - Restart all servers"
echo "   dev-logs     - Connect to server logs"
echo ""
echo "💡 To start development servers automatically, run: dev"