# EssayCoach

EssayCoach is a modern platform for essay coaching, leveraging a full-stack approach with a Vue 3 frontend built on the [Celeris Web](https://github.com/kirklin/celeris-web) framework and a Python FastAPI backend. This document provides guidance for developers collaborating on the project.

---

## Tech Stack

- **Frontend:** Vue 3, Vite, TypeScript, pnpm (built on [Celeris Web](https://github.com/kirklin/celeris-web) framework)
- **State Management:** Pinia (already configured)
- **Routing:** Vue Router (already configured)
- **Testing:** Vitest (unit) & Cypress (E2E) pre-configured in the `main/` workspace
- **Backend:** Python 3.11, FastAPI
- **Database:** PostgreSQL (development), SQLite (optional for prototyping)
- **Cache/Queue:** Redis
- **Dev Environment:** Nix (shell.nix), Poetry (Python), pnpm (Node)
- **Testing:** Vitest (main), Pytest (backend)

---

## Getting Started

### 1. Prerequisites
- [Nix](https://nixos.org/download.html) (recommended for consistent dev environments)
- [Poetry](https://python-poetry.org/docs/#installation) (if not using Nix)
- [Node.js 22+](https://nodejs.org/) (if not using Nix)
- [pnpm](https://pnpm.io/installation) (if not using Nix)

### 2. Clone the Repository
```sh
git clone https://github.com/your-org/EssayCoach.git
cd EssayCoach
```

### 3. Enter the Nix Shell (Recommended)
```sh
nix-shell
```
This will provide all necessary tools for both main and backend development.

---

## Frontend (Vue 3 + Vite)

### Setup
```sh
cd main
pnpm install
```

### Development Server
```sh
pnpm run dev
```
The app will be available at [http://localhost:5173](http://localhost:5173) by default.

### Build for Production
```sh
pnpm run build
```

---

## Backend (Python + FastAPI)

### Setup
```sh
cd backend
poetry install
```

### Development Server
```sh
poetry run uvicorn main:app --reload
```
The API will be available at [http://localhost:8000](http://localhost:8000) by default.

---

## Database
- **PostgreSQL** is the default for development. Ensure it is running and accessible at the URL in your environment variables (`DATABASE_URL`).
- **SQLite** can be used for quick prototyping (see `.gitignore` for ignored files).

---

## Environment Variables
Set these in your shell or in a `.env` file (see `.gitignore` for ignored env files):
- `DATABASE_URL` (e.g., `postgresql://localhost:5432/essaycoach_dev`)
- `REDIS_URL` (e.g., `redis://localhost:6379`)
- `NODE_ENV` (e.g., `development`)

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

- Use the Nix shell for a consistent, reproducible environment.
- For Docker-based development, see `docker-compose.yml` (if present).
- For questions, see the `/docs` folder or contact the maintainers.

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

