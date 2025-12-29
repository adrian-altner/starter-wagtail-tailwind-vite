# Changelog

## 0.0.1 - 2025-12-29

- Add `.env`-based production settings for `SECRET_KEY` and `ALLOWED_HOSTS`.
- Add Docker Compose config for local production-like runs.
- Add entrypoint to run migrations and auto-create a superuser when missing.
- Add Vite/Tailwind asset build in Docker image via multi-stage build.
- Fix Vite CSS lookup for manifest entries that are CSS-only.
- Serve static files in production via nginx.
- Include templates in the asset build so Tailwind generates utility classes.
- Update docs for Docker/production usage and superuser setup.
