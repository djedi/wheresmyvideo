from django.conf.urls import patterns, include, url
from django.contrib import admin

from rest_framework import routers

from movies import rest_views as movie_views


router = routers.DefaultRouter()
router.register(r'movies', movie_views.MovieViewSet)
router.register(r'media-types', movie_views.MediaTypeViewSet)


urlpatterns = patterns(
    '',
    url(r'^$', 'accounts.views.index', name='home'),
    # url(r'^movies/', include('movies.urls')),

    # rest_framework api
    url(r'^api/v1/', include('accounts.api_urls')),
    url(r'^api/v1/', include('movies.api_urls')),
    url(r'^api/v1/', include(router.urls)),
    url(r'api-auth/', include('rest_framework.urls',
                              namespace='rest_framework')),
    url(r'rest-auth/', include('rest_auth.urls')),

    url(r'^admin/', include(admin.site.urls)),
)
