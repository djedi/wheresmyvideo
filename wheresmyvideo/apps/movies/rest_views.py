from rest_framework import viewsets
from rest_framework.decorators import api_view
from rest_framework.response import Response

from . import models
from . import serializers


class MovieViewSet(viewsets.ModelViewSet):
    queryset = models.Movie.objects.all()
    serializer_class = serializers.MovieSerializer

    def get_queryset(self):
        qs = models.Movie.objects.filter(
            users__in=[self.request.user]).order_by('title')
        return qs


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
