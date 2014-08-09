# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('movies', '0004_movie_tmdb_poster'),
    ]

    operations = [
        migrations.AddField(
            model_name='movie',
            name='release_date',
            field=models.DateField(null=True, blank=True),
            preserve_default=True,
        ),
        migrations.RemoveField(
            model_name='movie',
            name='year',
        ),
    ]
