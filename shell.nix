let
  nixpkgs = fetchTarball "https://github.com/NixOS/nixpkgs/tarball/nixos-25.05";
  pkgs = import nixpkgs { config = {}; overlays = []; };
in

pkgs.mkShellNoCC {
  packages = with pkgs; [
    # Frontend Development (Vue.js 3 + Vite)
    # Note: Vite will be installed via pnpm when creating Vue projects
    nodejs_22                   # LTS version (recommended for production)
    #nodePackages.npm           # npm is not used in this project
    nodePackages.pnpm           # Alternative package manager, often faster
    nodePackages.prettier
    nodePackages.typescript
    nodePackages.eslint         # Linting for JavaScript/TypeScript
    nodePackages."@vue/language-server"  # Vue Language Server for IDE support
    
    # Vue 3 Development Tools
    # Note: create-vue is installed via npm when needed: npm create vue@latest

    # Backend Development (Python FastAPI + AI/ML)
    python311
    python311Packages.pip
    python311Packages.virtualenv
    black                       # Python code formatter
    python311Packages.flake8    # Python linting
    python311Packages.mypy      # Python type checking

    # AI/ML Development Tools (Cross-platform compatible)
    python311Packages.numpy
    python311Packages.pandas

    # Database Development
    sqlite-interactive
    postgresql_15               # For local PostgreSQL development
    redis                       # For caching and message queuing

    # Java/Kotlin Development (for potential microservices)
    jdk21
    gradle_8
    maven                       # Alternative build tool

    # Development Tools & Utilities
    git
    httpie                      # API testing
    curl                        # HTTP requests
    jq                          # JSON processing
    docker                      # Container development
    docker-compose              # Multi-container development
    
    
    # Documentation & Markdown
    pandoc                      # Document conversion
    
    # Process Management & Monitoring
    tmux                        # Terminal multiplexer
    htop                        # System monitoring
  ];

  # Environment Variables
  DATABASE_URL = "postgresql://localhost:5432/essaycoach_dev";
  REDIS_URL = "redis://localhost:6379";
  NODE_ENV = "development";
  PYTHONPATH = "./backend";

  # Environment Variables for Development
  shellHook = ''
    echo "🎓 Welcome to EssayCoach Development Environment!"
    echo ""
    echo "✅ Frontend Tools (Vue 3 + Vite):"
    echo "  - Node.js: ${pkgs.nodejs_22.version} (LTS)"
    echo "  - Build Tool: Vite (installed per-project via pnpm)"
    echo "  - Package Managers: npm, pnpm"
    echo "  - Vue Tools: create-vue, Vue Language Server"
    echo "  - Code Quality: Prettier, ESLint, TypeScript"
    echo "  - Testing: Jest, Cypress, Vitest"
    echo ""
    echo "✅ Backend Tools:"
    echo "  - Python: ${pkgs.python311.version}"
    echo "  - Code Quality: Black, Flake8, MyPy"
    echo "  - AI/ML: NumPy, Pandas (cross-platform compatible)"
    echo ""
    echo "✅ Database & Infrastructure:"
    echo "  - Databases: SQLite, PostgreSQL 15, Redis"
    echo "  - Containers: Docker, Docker Compose"
    echo "  - Java: JDK ${pkgs.jdk21.version}, Gradle, Maven"
    echo ""
    echo "✅ Development Utilities:"
    echo "  - API Testing: HTTPie, curl"
    echo "  - Utilities: git, jq, pandoc, tmux"
    echo ""
    echo "🚀 Quick Start Commands:"
    echo "  Create Vue Project: pnpm create vue@latest my-project"
    echo "  Frontend Dev:       cd frontend && pnpm install && pnpm run dev"
    echo "  Backend Dev:        cd backend && poetry install && poetry run uvicorn main:app --reload"
    echo "  Docker:             docker-compose up -d"
    echo "  Tests:              pnpm run test (frontend) or poetry run pytest (backend)"
    echo ""
    echo "🔧 Environment Variables:"
    echo "  DATABASE_URL: $DATABASE_URL"
    echo "  REDIS_URL: $REDIS_URL"
    echo "  NODE_ENV: $NODE_ENV"
    echo ""
    echo "💡 Why Vite over Vue CLI?"
    echo "  - ⚡ Faster development with instant HMR"
    echo "  - 🏗️  Modern ES modules support"
    echo "  - 📦 Smaller bundle sizes"
    echo "  - 🔧 Zero-config for most projects"
    echo "  - 🎯 Built by Vue's creator (Evan You)"
    echo ""
    echo "📦 AI/ML Setup:"
    echo "  - Core libraries: NumPy, Pandas (included in Nix shell)"
    echo "  - For advanced ML: Install via Poetry in your backend project"
    echo "  - GPU support: Add CUDA libraries via Poetry when needed"
    echo ""
  '';
} 