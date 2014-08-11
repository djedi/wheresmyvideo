from django.db import models

from . import functions


class TimeStampMixin(models.Model):
    created_at = models.DateTimeField(blank=True, null=True)
    modified_at = models.DateTimeField(blank=True, null=True)

    def save(self, *args, **kwargs):
        if self.created_at is None:
            self.created_at = functions.now()
        self.modified_at = functions.now()
        return super(TimeStampMixin, self).save(*args, **kwargs)

    class Meta:
        abstract = True
