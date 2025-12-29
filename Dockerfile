# Build frontend assets with Node.
FROM node:20-slim AS assets

WORKDIR /app
COPY package.json pnpm-lock.yaml ./
RUN corepack enable && pnpm install --frozen-lockfile
COPY assets ./assets
COPY core/templates ./core/templates
COPY home/templates ./home/templates
COPY search/templates ./search/templates
COPY postcss.config.js tailwind.config.js vite.config.js ./
RUN pnpm build

# Use an official Python runtime based on Debian 12 "bookworm" as a parent image.
FROM python:3.12-slim-bookworm AS web

# Add user that will be used in the container.
RUN useradd wagtail

# Port used by this container to serve HTTP.
EXPOSE 8000

# Set environment variables.
# 1. Force Python stdout and stderr streams to be unbuffered.
# 2. Set PORT variable used by the app server. This should match "EXPOSE".
ENV PYTHONUNBUFFERED=1 \
    PORT=8000 \
    DJANGO_SETTINGS_MODULE=core.settings.production

# Install system packages required by Wagtail and Django.
RUN apt-get update --yes --quiet && apt-get install --yes --quiet --no-install-recommends \
    build-essential \
    libpq-dev \
    libmariadb-dev \
    libjpeg62-turbo-dev \
    zlib1g-dev \
    libwebp-dev \
 && rm -rf /var/lib/apt/lists/*

# Install the project requirements.
COPY requirements.txt /
RUN pip install -r /requirements.txt

# Use /app folder as a directory where the source code is stored.
WORKDIR /app

# Set this directory to be owned by the "wagtail" user. This Wagtail project
# uses SQLite, the folder needs to be owned by the user that
# will be writing to the database file.
RUN chown wagtail:wagtail /app

# Copy the source code of the project into the container.
COPY --chown=wagtail:wagtail . .
# Copy built frontend assets from the assets stage.
COPY --from=assets --chown=wagtail:wagtail /app/core/static /app/core/static

# Entrypoint script (migrations + optional superuser).
COPY --chown=wagtail:wagtail scripts/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Use user "wagtail" to run the build commands below and the server itself.
USER wagtail

# Collect static files.
RUN python manage.py collectstatic --noinput --clear

# Runtime command that executes when "docker run" is called, it does the
# following:
#   1. Migrate the database.
#   2. Start the application server.
# WARNING:
#   Migrating database at the same time as starting the server IS NOT THE BEST
#   PRACTICE. The database should be migrated manually or using the release
#   phase facilities of your hosting platform. This is used only so the
#   Wagtail instance can be started with a simple "docker run" command.
ENTRYPOINT ["/entrypoint.sh"]
CMD ["/bin/sh", "-c", "python manage.py runserver 0.0.0.0:${PORT:-8000}"]

# Nginx image to serve static files and reverse-proxy Django.
FROM nginx:1.27-alpine AS nginx
COPY nginx/default.conf /etc/nginx/conf.d/default.conf
COPY --from=web /app/static /static

# Default build target stays as the Django app image.
FROM web AS final
