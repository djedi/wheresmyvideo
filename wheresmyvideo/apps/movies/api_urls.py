from django.conf.urls import patterns, url

urlpatterns = patterns(
    'movies.rest_views',
    url(r'^movies/add/tmdb/$', 'add_movie_by_tmdb_id', name='add'),
    url(r'^media-types/set/$', 'set_user_media_types', name='set_media_types'),
    url(r'^media-types/user-set/$', 'get_user_media_type_ids',
        name='get_user_types'),
)