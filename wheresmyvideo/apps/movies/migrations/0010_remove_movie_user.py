# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('movies', '0009_auto_20140811_1301'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='movie',
            name='user',
        ),
    ]
