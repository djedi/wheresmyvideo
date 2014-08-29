from base import *


DEBUG = True
TEMPLATE_DEBUG = DEBUG

DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.sqlite3',
        'NAME': os.path.join(BASE_DIR, 'db.sqlite3'),
    }
}

INSTALLED_APPS += [
    'django_extensions',
    'debug_toolbar',
]

# for dev, disable CORS & CSRF protection
MIDDLEWARE_CLASSES.append('common.middleware.DisableCSRF')
CORS_ORIGIN_ALLOW_ALL = True