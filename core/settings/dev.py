from .base import *

# SECURITY WARNING: don't run with debug turned on in production!
DEBUG = True

# SECURITY WARNING: keep the secret key used in production secret!
SECRET_KEY = "django-insecure-&o58wqh5q#9tl!6d7&xs+x#&5iy%lxgaac%uz&jxhoi=pzxr@%"

# SECURITY WARNING: define the correct hosts in production!
ALLOWED_HOSTS = ["*"]

EMAIL_BACKEND = "django.core.mail.backends.console.EmailBackend"

INSTALLED_APPS += [
    "django_browser_reload",
]

MIDDLEWARE += [
    "django_browser_reload.middleware.BrowserReloadMiddleware",
]


try:
    from .local import *
except ImportError:
    pass
