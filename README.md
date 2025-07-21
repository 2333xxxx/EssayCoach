# EssayCoach

EssayCoach is an AI-powered essay coaching platform that provides instant, multi-dimensional feedback to students while offering educators robust analytical tools. Built with Vue 3 frontend and Python Django backend, designed for scalability and educational research.

## Quick Start
**Zero-config development with Nix:**
```bash
nix develop  # Enter dev shell with all tools
# Automatically starts PostgreSQL and sets up environment

# Option 1: Start both servers simultaneously
dev          # Start backend + frontend via Overmind

# Option 2: Start individually
cd backend && python manage.py runserver   # Django backend (localhost:8000)
cd frontend && pnpm dev                    # Vite frontend (localhost:4318)
```

---

## Tech Stack

| Component | Technology |
|-----------|------------|
| **Frontend** | Vue 3 + TypeScript + Vite |
| **UI Framework** | Naive UI + UnoCSS |
| **State Management** | Pinia |
| **Backend** | Python 3.11 + Django |
| **Database** | PostgreSQL (dev/prod), SQLite (testing) |
| **Async Processing** | Django async views (MVP) → Redis + Celery |
| **Dev Environment** | Nix flakes + Poetry + pnpm |
| **Testing** | Vitest (frontend) + Pytest (backend)

---

## Getting Started

### 1. Prerequisites
- [Nix](https://nixos.org/download.html) (with flakes enabled, recommended for consistent dev environments)
- [Poetry](https://python-poetry.org/docs/#installation) (if not using Nix)
- [Node.js 22+](https://nodejs.org/) (if not using Nix)
- [pnpm](https://pnpm.io/installation) (if not using Nix)

### 2. Clone the Repository
```sh
git clone https://github.com/your-org/EssayCoach.git
cd EssayCoach
```

### 3. Enter the Nix Development Shell (Recommended)

#### Using Nix Flakes (Preferred)
```sh
nix develop
```
This will provide all necessary tools for both frontend and backend development using the flake.nix configuration.

#### What's Included
- **PostgreSQL** - Auto-starts on port 5432 with schema and mock data
- **Python Environment** - Django + FastAPI with all dependencies
- **Frontend Tools** - Node.js 22, pnpm, Vite
- **Development Tools** - Git aliases, enhanced shell, Overmind process manager
- **Database** - `essaycoach` database with `essayadmin` user (password: changeme)

#### Available Commands
```bash
# Process management (via Overmind)
dev           # Start both backend + frontend servers
dev-logs      # View combined logs
dev-stop      # Stop all services
dev-restart   # Restart all services

# Database shortcuts
pg-connect    # Connect to PostgreSQL CLI
pg-logs       # View PostgreSQL logs
pg-status     # Check PostgreSQL status

# Django shortcuts
runserver     # Start Django development server
migrate       # Run Django migrations
shell         # Django shell
```

---

## Frontend (Vue 3 + Vite)

### Setup
```sh
cd frontend
pnpm install
```

### Development Server
```sh
cd frontend
pnpm dev
```
The app will be available at [http://localhost:4318](http://localhost:4318) by default.

### Build for Production
```sh
cd frontend
pnpm build
```

---

## Backend (Python + Django)

### Setup
```sh
cd backend
# Dependencies are pre-installed via nix develop
```

### Development Server
```sh
cd backend
python manage.py runserver
```
The API will be available at [http://localhost:8000](http://localhost:8000) by default.

### Database Setup
```sh
python manage.py migrate  # Run migrations (already done in nix develop)
python manage.py createsuperuser  # Create admin user
```

---

## Database
- **PostgreSQL** is automatically configured in the nix environment
  - Starts on port 5432 with schema and mock data pre-loaded
  - Database: `essaycoach` with user `essayadmin` (password: `changeme`)
  - Environment variable: `DATABASE_URL=postgresql://essayadmin:changeme@localhost:5432/essaycoach`
- **SQLite** can be used for quick prototyping (see `.gitignore` for ignored files).

---

## Environment Variables
All environment variables are automatically configured in the nix environment:
- `DATABASE_URL` - PostgreSQL connection string (auto-configured)
- `DJANGO_SETTINGS_MODULE` - Points to Django settings
- `PYTHONPATH` - Includes project root
- `PGPORT` - PostgreSQL port (5432)

For Docker deployment, see `docker-compose.yml` for container-specific environment variables.

---

## Testing
- **Frontend:**
  ```sh
  pnpm run test
  ```
- **Backend:**
  ```sh
  poetry run pytest
  ```

---

## Branch Naming Rules

When creating branches for this project, please follow these naming conventions:

- Feature:      feature/<issue-id>-<short-description>
- Bugfix:       bugfix/<issue-id>-<short-description>
- Hotfix:       hotfix/<issue-id>-<short-description>
- Release:      release/<version>
- Documentation: docs/<short-description>
- Refactoring:  refactor/<short-description>


### General Guidelines
- Use lowercase letters and hyphens to separate words.
- Keep branch names short but descriptive.
- Avoid using special characters or spaces.

---



## Contributing
- Use feature branches and submit pull requests for review.
- Follow code style guidelines (Prettier, ESLint for main; Black, Flake8 for backend).
- Write tests for new features.
- Report bugs or request features using our [issue templates](.github/ISSUE_TEMPLATE/) - choose from Bug Report, User Story, Technical Task, Documentation Update, or Spike/Research templates.

---

## Additional Notes

- **Use the Nix shell** for a consistent, reproducible environment
- **Development scripts** are located in `scripts/dev-env/` for easy customization
- **Process management** via Overmind (see `Procfile` for service definitions)
- **For Docker-based development**, see `docker-compose.yml` (separate from nix workflow)
- **For questions**, see the `/docs` folder or contact the maintainers

### Development Environment Structure
```
scripts/dev-env/
├── bash-config.sh      # Shell configuration
├── prompt-setup.sh     # Git-aware prompt
├── aliases.sh          # Development shortcuts  
├── postgres-setup.sh   # Local database setup
├── env-vars.sh         # Environment configuration
├── welcome-message.sh  # Startup banner
├── start-backend.sh    # Django server startup
└── start-frontend.sh   # Vite server startup
```

### Current Front-End Dependencies (managed by `pnpm`)

The `main/package.json` is already pre-populated with the core libraries your Vue 3 SPA needs:

| Category | Package |
|----------|---------|
| Framework | `vue@^3` |
| State | `pinia@^3` |
| Router | `vue-router@^4` |
| Build | `vite`, `@vitejs/plugin-vue`, `@vitejs/plugin-vue-jsx` |
| Linting & Format | `eslint`, `eslint-plugin-vue`, `prettier` |
| Testing | `vitest`, `@vue/test-utils`, `cypress` |

You can add more packages at any time with `pnpm add <pkg>`.

### Planned / Upcoming Dependencies

The design documents outline additional services and libraries that are **not yet in the codebase**. These will be integrated iteratively:

- **Frontend:** Axios (API client), a component framework (Element Plus or Vuetify), richer internationalization tooling.
- **Backend:** FastAPI + SQLAlchemy + Alembic + Pydantic, JWT/OAuth2 libraries, OpenSearch / vector DB client, async workers (e.g. Celery, Redis Queue), LLM/AI SDKs.
- **DevOps / Infra:** Kubernetes toolchain (`kubectl`, `helm`), Alibaba Cloud SDKs, monitoring (Prometheus / OpenTelemetry), CI/CD pipeline scripts.

If you encounter a missing tool while implementing a feature, feel free to update `shell.nix`, `pyproject.toml`, or `package.json` and open a PR.
