# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('movies', '0012_auto_20140819_1422'),
    ]

    operations = [
        migrations.AlterField(
            model_name='collector',
            name='media_types',
            field=models.ManyToManyField(to=b'movies.MediaType', null=True, blank=True),
        ),
    ]
