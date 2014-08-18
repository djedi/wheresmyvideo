from django.conf.urls import patterns, url

urlpatterns = patterns(
    'accounts.rest_views',
    url(r'^user/$', 'get_user_data', name='get_user_data'),
)