# Wagtail + Tailwind + Vite Starter

Kurze Hinweise zum Starten und Deployment dieses Projekts.

## Voraussetzungen

- Python 3.12+
- Node.js (für Vite/Tailwind)
- Docker (optional für Production-Run)

## Lokale Entwicklung

```bash
python -m venv .venv
. .venv/bin/activate
pip install -r requirements.txt

pnpm install

python manage.py migrate
python manage.py runserver
```

## Production via Docker

1) `.env` anlegen (siehe `.env.example`) und anpassen:

```bash
cp .env.example .env
```

2) Image bauen und starten:

```bash
docker build -t wagtail-prod .
docker run --rm -p 8000:8000 --env-file .env wagtail-prod
```

Alternativ mit Compose:

```bash
docker compose up --build
```

Hinweis: Das Dockerfile baut die Vite/Tailwind Assets automatisch mit.

## Vite/Tailwind

Dev server:

```bash
pnpm dev
```

Build assets:

```bash
pnpm build
```

## Admin-User anlegen

```bash
python manage.py createsuperuser
```

Mit Docker/Compose:

```bash
docker compose run --rm web python manage.py createsuperuser
```

Automatisch beim Start (falls noch kein Superuser existiert):

- `DJANGO_SUPERUSER_EMAIL`
- `DJANGO_SUPERUSER_PASSWORD`
- `DJANGO_SUPERUSER_FIRST_NAME` (optional)
- `DJANGO_SUPERUSER_LAST_NAME` (optional)

## Deployment-Hinweise

Static Files bauen:

```bash
python manage.py collectstatic --noinput
```

Migrations ausführen:

```bash
python manage.py migrate --noinput
```

## Wichtige Umgebungsvariablen

- `DJANGO_SETTINGS_MODULE=core.settings.production`
- `SECRET_KEY` (z. B. generieren und in `.env` eintragen)
- `ALLOWED_HOSTS` (kommagetrennt, z. B. `example.com,localhost,127.0.0.1`)
