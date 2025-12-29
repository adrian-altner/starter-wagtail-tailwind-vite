#!/bin/sh
set -e

python manage.py migrate --noinput

python manage.py shell -c "import os; \
from django.contrib.auth import get_user_model; \
User = get_user_model(); \
exists = User.objects.filter(is_superuser=True).exists(); \
email = os.environ.get('DJANGO_SUPERUSER_EMAIL', ''); \
first_name = os.environ.get('DJANGO_SUPERUSER_FIRST_NAME', ''); \
last_name = os.environ.get('DJANGO_SUPERUSER_LAST_NAME', ''); \
password = os.environ.get('DJANGO_SUPERUSER_PASSWORD'); \
\
should_create = (not exists) and email and password; \
\
print('Superuser exists' if exists else 'No superuser found'); \
\
(
    User.objects.create_superuser(email=email, password=password, first_name=first_name, last_name=last_name)
    if should_create else None
); \
\
print('Superuser created' if should_create else 'Superuser not created (missing env or already exists)')"

exec "$@"
