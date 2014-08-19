from django.contrib import admin

from . import models


admin.site.register(models.Movie)
admin.site.register(models.MediaType)
admin.site.register(models.Genre)
admin.site.register(models.UserMovie)