from django.conf import settings
from django.contrib.auth.models import User
from django.db import models
import tmdbsimple as tmdb


class Movie(models.Model):
    user = models.ForeignKey(User)
    title = models.CharField(max_length=255)  # For searching & sorting
    release_date = models.DateField(blank=True, null=True)
    # https://www.themoviedb.org
    tmdb_id = models.PositiveIntegerField(blank=True, null=True)
    media_types = models.ManyToManyField('MediaType', blank=True, null=True)
    rating = models.CharField(max_length=5, blank=True, null=True)
    genres = models.ManyToManyField('Genre', blank=True, null=True)
    tmdb_poster = models.CharField(max_length=255, blank=True, null=True)

    @classmethod
    def add_tmdb(cls, tmdb_id, user):
        tmdb.API_KEY = settings.TMDB_API_KEY
        movie = tmdb.Movies(tmdb_id)
        resp = movie.info()
        print resp
        return cls.objects.create(
            user=user,
            title=resp.get('title', ''),
            release_date=resp.get('release_date'),
            tmdb_id=tmdb_id,
            tmdb_poster=resp.get('poster_path'),
        )

    def __unicode__(self):
        if self.year:
            return u'{} ({}) - [{}]'.format(
                self.title, self.year, self.user.username)
        else:
            return u'{} -[{}]'.format(self.title, self.user.username)


class MediaType(models.Model):
    """
    Types of media/location such as DVD, Amazon Prime, iTunes, etc.
    """
    name = models.CharField(max_length=100)

    def __unicode__(self):
        return self.name


class Genre(models.Model):
    name = models.CharField(max_length=30)
    tmdb_id = models.PositiveSmallIntegerField()

    def __unicode__(self):
        return self.name