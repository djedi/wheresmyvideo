from django.conf.urls import patterns, url

urlpatterns = patterns(
    'movies.rest_views',
    url(r'^add/tmdb/$', 'add_movie_by_tmdb_id', name='add'),
)