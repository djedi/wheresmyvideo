# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('movies', '0006_auto_20140809_0649'),
    ]

    operations = [
        migrations.AddField(
            model_name='movie',
            name='created_at',
            field=models.DateTimeField(null=True, blank=True),
            preserve_default=True,
        ),
        migrations.AddField(
            model_name='movie',
            name='modified_at',
            field=models.DateTimeField(null=True, blank=True),
            preserve_default=True,
        ),
    ]
