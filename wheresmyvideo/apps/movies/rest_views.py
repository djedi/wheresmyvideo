from rest_framework import viewsets
from rest_framework.decorators import api_view

from . import models
from . import serializers
from rest_framework.response import Response


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
    movie = models.Movie.add_tmdb(tmdb_id, request.user)
    return Response({'movie': {'title': movie.title, 'id': movie.id}})
