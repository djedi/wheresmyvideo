from rest_framework import serializers

from . import models


class MovieSerializer(serializers.ModelSerializer):
    thumbnail = serializers.URLField(source='thumbnail_url', read_only=True)
    medium_img = serializers.URLField(source='medium_img_url', read_only=True)
    large_img = serializers.URLField(source='large_img_url', read_only=True)

    class Meta:
        model = models.Movie
        exclude = ('created_at', 'modified_at')
        depth = 1
        read_only_fields = ('genres', 'tmdb_poster', 'tmdb_id')


class GenreSerializer(serializers.ModelSerializer):
    class Meta:
        model = models.Genre


class MediaTypeSerializer(serializers.ModelSerializer):
    class Meta:
        model = models.MediaType
        exclude = ('users',)


class UserMovieSerializer(serializers.ModelSerializer):
    movie = MovieSerializer(read_only=True)
    media_types = MediaTypeSerializer(read_only=True)

    class Meta:
        model = models.UserMovie
        exclude = ('user',)
        depth = 1