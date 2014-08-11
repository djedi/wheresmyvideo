# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


def user_to_m2m(apps, schema_editor):
    movie_model = apps.get_model('movies', 'Movie')
    for movie in movie_model.objects.all():
        user = movie.user
        movie.users.add(user)


class Migration(migrations.Migration):

    dependencies = [
        ('movies', '0008_movie_users'),
    ]

    operations = [
        migrations.RunPython(user_to_m2m)
    ]
