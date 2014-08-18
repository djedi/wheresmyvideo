from rest_framework import serializers

from . import models


class MovieSerializer(serializers.ModelSerializer):
    thumbnail = serializers.URLField(source='thumbnail_url', read_only=True)
    medium_img = serializers.URLField(source='medium_img_url', read_only=True)
    large_img = serializers.URLField(source='large_img_url', read_only=True)

    class Meta:
        model = models.Movie
        exclude = ('users',)


class MediaTypeSerializer(serializers.ModelSerializer):
    class Meta:
        model = models.MediaType
        exclude = ('users',)
