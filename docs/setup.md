
# Setup

## Voraussetzungen

- Python 3.12+ (lokal in `.venv`)
- Node + pnpm (Vite/Tailwind)

## Installation

```bash
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
pnpm install
python manage.py migrate
python manage.py createsuperuser
```

## Entwicklung starten

```bash
honcho start
```

Das startet:
- Django unter `http://localhost:8000/`
- Vite unter `http://localhost:5173/static/`

## Build (Production Assets)

```bash
pnpm build
```

Die gebauten Dateien landen unter `core/static/` (CSS in `core/static/css/`, andere Assets in `core/static/assets/`).

## Tooling & Hinweise

- **Tailwind v4** läuft über Vite und `assets/core.css` (`@source` für Templates).
- **django-browser-reload** ist aktiv für Template-Reloads im Debug-Modus.
- **Procfile** steuert Dev-Tasks (Django + Vite).
- **Makefile** bietet `make dev`, `make dev-all`, `make install`.
- **FOUC vermeiden**: Im Debug-Modus ist ein direkter CSS-Link auf `http://localhost:5173/static/assets/core.css` aktiv, damit Styles sofort da sind, während Vite-HMR weiter über das JS-Entry läuft.

## Troubleshooting

### Port already in use

If `honcho start` reports that port 8000 is already in use, find the process and stop it.

```bash
lsof -iTCP -sTCP:LISTEN -P | rg -n "(:8000|:8001|:8002|:3000|:5173)"
```

Then stop the process by PID:

```bash
kill <PID>
```

## Projektregeln

- In `core/` niemals `models.py`, `views.py` oder `wagtail_hooks.py` anlegen.
- Apps fachlich trennen: Content/Logik gehören in eigene Apps (`users`, `home`, `search`, ...).

## Users App mit Email-Login

Wagtail supports custom user models with some restrictions. Wagtail uses an extension of Django’s permissions framework, so your user model must at minimum inherit from `AbstractBaseUser` and `PermissionsMixin`.
