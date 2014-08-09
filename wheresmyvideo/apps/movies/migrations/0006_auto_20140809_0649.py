# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('movies', '0005_auto_20140809_0600'),
    ]

    operations = [
        migrations.AlterField(
            model_name='movie',
            name='tmdb_id',
            field=models.PositiveIntegerField(unique=True),
        ),
    ]
