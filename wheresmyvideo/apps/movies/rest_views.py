from rest_framework import viewsets
from rest_framework.decorators import api_view
from rest_framework.generics import get_object_or_404
from rest_framework.response import Response

from . import models
from . import serializers


MOVIES_PER_PAGE = 20


class MovieViewSet(viewsets.ModelViewSet):
    queryset = models.Movie.objects.all()
    serializer_class = serializers.MovieSerializer
    paginate_by = MOVIES_PER_PAGE


@api_view(['POST'])
def add_movie_by_tmdb_id(request):
    tmdb_id = request.DATA.get('id')
    media_type_id = request.DATA.get('media_type_id')
    movie = models.Movie.add_tmdb(tmdb_id, request.user, media_type_id)
    return Response({'movie': {'title': movie.title, 'id': movie.id}})


class MediaTypeViewSet(viewsets.ModelViewSet):
    queryset = models.MediaType.objects.all().order_by('name')
    serializer_class = serializers.MediaTypeSerializer

    def get_queryset(self):
        user_id = self.request.GET.get('user', None)
        qs = models.MediaType.objects.all()
        if user_id:
            qs = qs.filter(users__id=user_id)
        return qs.order_by('name')


@api_view(['POST'])
def set_user_media_types(request):
    type_ids = request.DATA.get('type_ids')
    request.user.mediatype_set.clear()
    for _id in type_ids:
        request.user.mediatype_set.add(_id)
    return Response({'success': True})


@api_view(['GET'])
def get_user_media_type_ids(request):
    type_ids = request.user.mediatype_set.all().values_list('id', flat=True)
    return Response({'type_ids': type_ids})


class UserMovieViewSet(viewsets.ModelViewSet):
    queryset = models.UserMovie.objects.select_related(
        'movie', 'media_types').all()
    serializer_class = serializers.UserMovieSerializer

    def get_queryset(self):
        queryset = self.queryset.filter(user=self.request.user)
        return queryset.order_by('movie__title')


@api_view(['PUT'])
def update_user_movie_media_types(request):
    user_movie_id = request.DATA.get('id')
    media_types = request.DATA.get('media_types')
    user_movie = get_object_or_404(models.UserMovie, pk=user_movie_id)
    user_movie.media_types.clear()
    for mt in media_types:
        user_movie.media_types.add(mt['id'])
    return Response({'success': True, 'id': user_movie.id, 'media_types': media_types})