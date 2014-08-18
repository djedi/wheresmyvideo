from rest_framework.decorators import api_view
from rest_framework.response import Response

from .import functions


@api_view(['GET'])
def get_user_data(request):
    user = request.user
    type_ids = user.mediatype_set.all().values_list('id', flat=True)
    return Response({
        'display_name': functions.get_display_name(user),
        'first_name': user.first_name,
        'last_name': user.last_name,
        'username': user.username,
        'email': user.email,
        'id': user.id,
        'video_count': user.movie_set.all().count(),
        'wish_count': 0,
        'media_types': type_ids,
    })
