from django.conf import settings
from django.contrib.auth.models import User
from django.db import models
import tmdbsimple as tmdb

from common.models import TimeStampMixin


class Movie(TimeStampMixin, models.Model):
    user = models.ForeignKey(User)
    title = models.CharField(max_length=255)
    release_date = models.DateField(blank=True, null=True)
    tmdb_id = models.PositiveIntegerField(unique=True)
    media_types = models.ManyToManyField('MediaType', blank=True, null=True)
    rating = models.CharField(max_length=5, blank=True, null=True)
    genres = models.ManyToManyField('Genre', blank=True, null=True)
    tmdb_poster = models.CharField(max_length=255, blank=True, null=True)

    @classmethod
    def add_tmdb(cls, tmdb_id, user):
        tmdb.API_KEY = settings.TMDB_API_KEY
        movie = tmdb.Movies(tmdb_id)
        resp = movie.info()
        try:
            obj = cls.objects.get(
                user=user,
                tmdb_id=tmdb_id,
            )
        except cls.DoesNotExist:
            obj = cls.objects.create(
                user=user,
                title=resp.get('title', 'No Title'),
                tmdb_id=tmdb_id,
                tmdb_poster=resp.get('poster_path'),
            )
        else:
            obj.title = resp.get('title', 'No Title')
            obj.tmdb_poster = resp.get('poster_path')

        if resp.get('release_date'):
            obj.release_date = resp.get('release_date')

        # TODO: Get genres
        # TODO: Get rating
        obj.save()
        return obj

    @classmethod
    def search_tmdb(cls, query):
        tmdb.API_KEY = settings.TMDB_API_KEY
        search = tmdb.Search()
        resp = search.movie(query=query)
        return resp

    @property
    def thumbnail_url(self):
        return 'http://image.tmdb.org/t/p/w92{}'.format(self.tmdb_poster)

    def __unicode__(self):
        if self.release_date:
            return u'{} ({}) - [{}]'.format(
                self.title, self.release_date.year, self.user.username)
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
