# Contributing to EssayCoach

## Getting Started

### Prerequisites
- Python 3.12+
- Node.js 18+
- PostgreSQL 14+
- Nix package manager (recommended)

### Development Setup
1. Fork the repository
2. Clone your fork: `git clone https://github.com/your-username/EssayCoach.git`
3. Enter development environment: `nix develop`
4. Start services: `just dev`

## Development Workflow

### Branch Naming
- `feature/add-user-profiles`
- `fix/login-validation-error`
- `docs/update-api-spec`
- `refactor/essay-store`

### Commit Messages
```
type(scope): description

feat(auth): add JWT token refresh
fix(frontend): resolve essay loading bug
docs(api): update endpoint documentation
```

### Pull Request Process
1. Create feature branch from `main`
2. Make changes with tests
3. Run test suite: `just test`
4. Update documentation if needed
5. Submit PR with template

## Code Standards

### Python (Backend)
- Follow PEP 8
- Use type hints
- Write docstrings
- Run `ruff` for linting

### TypeScript (Frontend)
- Use strict mode
- Prefer composition API
- Follow Vue style guide
- Run `eslint` and `prettier`

### Testing Requirements
- Backend: 80% code coverage
- Frontend: Unit tests for components
- E2E: Critical user flows

## Documentation

### Code Documentation
- Add JSDoc for TypeScript functions
- Include docstrings for Python methods
- Update API documentation for new endpoints

### User Documentation
- Update README for new features
- Add migration guides for breaking changes
- Include examples in documentation

## Issue Reporting

### Bug Reports
```markdown
**Describe the bug**
Clear description of the issue

**Steps to reproduce**
1. Step 1
2. Step 2
3. Step 3

**Expected behavior**
What should happen

**Environment**
- OS: [e.g. macOS 14]
- Browser: [e.g. Chrome 120]
- Version: [e.g. 1.2.0]
```

## Development Notes

[This section will be expanded with actual contribution guidelines]