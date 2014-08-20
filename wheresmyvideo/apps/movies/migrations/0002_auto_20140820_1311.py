# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('movies', '0001_initial'),
    ]

    operations = [
        migrations.AlterUniqueTogether(
            name='usermovie',
            unique_together=set([(b'user', b'movie')]),
        ),
    ]
