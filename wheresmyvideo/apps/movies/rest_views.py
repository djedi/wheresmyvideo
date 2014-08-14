from rest_framework import viewsets

from . import models
from . import serializers


class MovieViewSet(viewsets.ModelViewSet):
    queryset = models.Movie.objects.all()
    serializer_class = serializers.MovieSerializer

    def get_queryset(self):
        qs = models.Movie.objects.filter(users__in=[self.request.user])
        return qs
