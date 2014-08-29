from base import *


DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.postgresql_psycopg2',
        'NAME': os.environ.get('DB_NAME'),
        'USER': os.environ.get('DB_USERNAME'),
        'PASSWORD': os.environ.get('DB_PASSWORD'),
        'HOST': '127.0.0.1',
        'PORT': '5432',
    }
}

INSTALLED_APPS += [
    'gunicorn',
    'raven.contrib.django.raven_compat',
]

# Setnry settings
RAVEN_CONFIG = {
    'dsn': 'http://14841332d1f24d79b03c12d2fb65cc70:1a5077a523c244048341381ec20'
           '8a5ed@redseam.info/10',
}