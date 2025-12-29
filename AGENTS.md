# Repository Guidelines

## Project Structure & Module Organization

- Current contents: a local Python virtual environment at `.venv/` only. No source, test, or asset directories are present yet.
- Recommended layout when you add code:
  - `src/` for application code
  - `tests/` for automated tests
  - `assets/` or `public/` for static files (images, fonts, etc.)
  - `scripts/` for helper tooling

## Build, Test, and Development Commands

- No build, test, or dev commands are defined yet. Add them alongside your chosen tooling (for example in `pyproject.toml`, `package.json`, or `Makefile`).
- Example conventions once tooling exists:
  - `make dev` to run the local server
  - `make test` to run the test suite
  - `make lint` to run formatting and lint checks

## Coding Style & Naming Conventions

- No style or lint configuration is checked in. When you add one, document it here and enforce it via CI.
- Recommended defaults (adjust if you adopt a different stack):
  - 2 or 4 spaces per indent, no tabs
  - `snake_case` for Python files and functions
  - `kebab-case` for filenames

## Testing Guidelines

- No testing framework is configured. If you add one, document:
  - the framework name (e.g., `pytest`, `vitest`)
  - where tests live (`tests/`, `src/**/__tests__/`)
  - how to run tests and any coverage targets

## Commit & Pull Request Guidelines

- No Git history is available in this directory. If this becomes a Git repo, define a commit convention (for example, Conventional Commits: `feat: ...`, `fix: ...`).
- PRs should include a short description, testing notes, and screenshots for UI changes.

## Security & Configuration Tips

- Keep secrets out of the repo. Use `.env` files for local configuration and document required variables in a sample file like `.env.example`.
- Do not commit `.venv/` to version control unless the team explicitly chooses to vendor it.
