"""
WSGI config for wheresmyvideo project.

It exposes the WSGI callable as a module-level variable named ``application``.

For more information on this file, see
https://docs.djangoproject.com/en/dev/howto/deployment/wsgi/
"""

import os
os.environ.setdefault("DJANGO_SETTINGS_MODULE", "wheresmyvideo.settings.prod")

from raven.contrib.django.raven_compat.middleware.wsgi import Sentry
from django.core.wsgi import get_wsgi_application
application = Sentry(get_wsgi_application())
