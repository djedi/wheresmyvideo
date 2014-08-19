# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations
from django.conf import settings


class Migration(migrations.Migration):

    dependencies = [
        migrations.swappable_dependency(settings.AUTH_USER_MODEL),
        ('movies', '0014_auto_20140819_1427'),
    ]

    operations = [
        migrations.CreateModel(
            name='UserMovie',
            fields=[
                ('id', models.AutoField(verbose_name='ID', serialize=False, auto_created=True, primary_key=True)),
                ('media_types', models.ManyToManyField(to='movies.MediaType', null=True, blank=True)),
                ('movie', models.ForeignKey(to='movies.Movie')),
                ('user', models.ForeignKey(to=settings.AUTH_USER_MODEL)),
            ],
            options={
            },
            bases=(models.Model,),
        ),
        migrations.RemoveField(
            model_name='collection',
            name='media_types',
        ),
        migrations.RemoveField(
            model_name='collection',
            name='movies',
        ),
        migrations.RemoveField(
            model_name='collection',
            name='user',
        ),
        migrations.DeleteModel(
            name='Collection',
        ),
    ]
