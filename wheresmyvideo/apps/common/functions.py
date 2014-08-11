import datetime
from django.utils import timezone


def now():
    return datetime.datetime.now().replace(
        tzinfo=timezone.get_current_timezone())
