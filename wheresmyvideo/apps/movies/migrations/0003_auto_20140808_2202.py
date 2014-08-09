# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('movies', '0002_auto_20140808_2157'),
    ]

    operations = [
        migrations.AddField(
            model_name='movie',
            name='year',
            field=models.PositiveSmallIntegerField(null=True, blank=True),
            preserve_default=True,
        ),
        migrations.AlterField(
            model_name='movie',
            name='genres',
            field=models.ManyToManyField(to=b'movies.Genre', null=True, blank=True),
        ),
        migrations.AlterField(
            model_name='movie',
            name='media_types',
            field=models.ManyToManyField(to=b'movies.MediaType', null=True, blank=True),
        ),
    ]
