import json

from rest_framework.decorators import api_view
from rest_framework.response import Response

from .import functions


@api_view(['GET'])
def get_user_data(request):
    user = request.user
    type_ids = user.mediatype_set.all().values_list(
        'id', flat=True).order_by('name')
    media_types = user.mediatype_set.all().values('id', 'name').order_by('name')
    return Response({
        'display_name': functions.get_display_name(user),
        'first_name': user.first_name,
        'last_name': user.last_name,
        'username': user.username,
        'email': user.email,
        'id': user.id,
        'video_count': user.usermovie_set.all().count(),
        'wish_count': 0,
        'media_type_ids': type_ids,
        'media_types': media_types,
    })
