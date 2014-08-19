from django.conf import settings
from django.contrib.auth.models import User
from django.db import models
import tmdbsimple as tmdb

from common.models import TimeStampMixin


class Movie(TimeStampMixin, models.Model):
    title = models.CharField(max_length=255)
    release_date = models.DateField(blank=True, null=True)
    tmdb_id = models.PositiveIntegerField(unique=True)
    rating = models.CharField(max_length=5, blank=True, null=True)
    genres = models.ManyToManyField('Genre', blank=True, null=True)
    tmdb_poster = models.CharField(max_length=255, blank=True, null=True)

    @classmethod
    def add_tmdb(cls, tmdb_id, user=None, media_type_id=None):
        tmdb.API_KEY = settings.TMDB_API_KEY
        tmdb_movie = tmdb.Movies(tmdb_id)
        resp = tmdb_movie.info()
        try:
            obj = cls.objects.get(
                tmdb_id=tmdb_id,
            )
        except cls.DoesNotExist:
            obj = cls.objects.create(
                title=resp.get('title', 'No Title'),
                tmdb_id=tmdb_id,
                tmdb_poster=resp.get('poster_path'),
            )
        else:
            obj.title = resp.get('title', 'No Title')
            obj.tmdb_poster = resp.get('poster_path')

        if resp.get('release_date'):
            obj.release_date = resp.get('release_date')

        if user and media_type_id:
            UserMovie.add_movie(user, obj, media_type_id)

        # Get genres
        for t_genre in resp.get('genres', []):
            genre, _ = Genre.objects.get_or_create(
                tmdb_id=t_genre['id'], name=t_genre['name'])
            obj.genres.add(genre)

        obj.save()

        # get rating
        obj.get_us_rating(tmdb_movie, save=True)

        return obj

    def get_tmdb_movie(self):
        tmdb.API_KEY = settings.TMDB_API_KEY
        tmdb_movie = tmdb.Movies(self.tmdb_id)
        tmdb_movie.info()
        return tmdb_movie

    def get_us_rating(self, tmdb_movie=None, save=False):
        if not tmdb_movie:
            tmdb_movie = self.get_tmdb_movie()
        tmdb_movie.releases()
        for c in tmdb_movie.countries:
            if c.get('iso_3166_1') == 'US':
                self.rating = c.get('certification')
        if save:
            self.save()

    def gen_genres(self, tmdb_movie=None, save=True):
        if not tmdb_movie:
            tmdb_movie = self.get_tmdb_movie()
        for t_genre in tmdb_movie.genres:
            genre, _ = Genre.objects.get_or_create(
                tmdb_id=t_genre['id'], name=t_genre['name'])
            self.genres.add(genre)

    @classmethod
    def search_tmdb(cls, query):
        tmdb.API_KEY = settings.TMDB_API_KEY
        search = tmdb.Search()
        resp = search.movie(query=query)
        return resp

    @property
    def thumbnail_url(self):
        return self.image_url(92)

    @property
    def medium_img_url(self):
        return self.image_url(185)

    @property
    def large_img_url(self):
        return self.image_url(396)

    def image_url(self, width=92):
        return 'https://image.tmdb.org/t/p/w{}{}'.format(
            width, self.tmdb_poster)

    def __unicode__(self):
        if self.release_date:
            try:
                return u'{} ({})'.format(self.title, self.release_date.year)
            except AttributeError:
                return self.title
        else:
            return self.title


class MediaType(models.Model):
    """
    Types of media/location such as DVD, Amazon Prime, iTunes, etc.
    """
    name = models.CharField(max_length=100)
    users = models.ManyToManyField(User, blank=True, null=True)

    def __unicode__(self):
        return self.name


class Genre(models.Model):
    name = models.CharField(max_length=30)
    tmdb_id = models.PositiveSmallIntegerField()

    def __unicode__(self):
        return self.name


class UserMovie(models.Model):
    user = models.ForeignKey(User)
    movie = models.ForeignKey(Movie)
    media_types = models.ManyToManyField(MediaType, blank=True, null=True)

    def __unicode__(self):
        return "{} owns {} on {}".format(self.user.username, self.movie.title, self.media_type_names)

    @classmethod
    def add_movie(cls, user, movie, media_type):
        obj, created = cls.objects.get_or_create(user=user, movie=movie)
        obj.media_types.add(media_type)
        return obj

    @property
    def media_type_names(self):
        return ', '.join([mt.name for mt in self.media_types.all()])