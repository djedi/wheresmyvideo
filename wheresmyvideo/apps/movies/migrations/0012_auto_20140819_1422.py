# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations
from django.conf import settings


class Migration(migrations.Migration):

    dependencies = [
        migrations.swappable_dependency(settings.AUTH_USER_MODEL),
        ('movies', '0011_mediatype_users'),
    ]

    operations = [
        migrations.CreateModel(
            name='Collector',
            fields=[
                ('id', models.AutoField(verbose_name='ID', serialize=False, auto_created=True, primary_key=True)),
                ('media_types', models.ManyToManyField(to='movies.MediaType')),
                ('movies', models.ManyToManyField(to='movies.Movie')),
                ('user', models.ForeignKey(to=settings.AUTH_USER_MODEL)),
            ],
            options={
            },
            bases=(models.Model,),
        ),
        migrations.RemoveField(
            model_name='movie',
            name='media_types',
        ),
        migrations.RemoveField(
            model_name='movie',
            name='users',
        ),
    ]
