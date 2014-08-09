from django.contrib.auth.models import User
from django.test import TestCase
from . import models


class MovieTestCase(TestCase):
    def setUp(self):
        self.user = User.objects.create_user(
            'tester', 'tester@sample.com', 'test')

    def test_add_tmdb(self):
        matrix = models.Movie.add_tmdb(603, self.user)
        self.assertEqual(matrix.title, 'The Matrix')
        self.assertEqual(matrix.release_date, '1999-03-30')
        self.assertEqual(matrix.tmdb_id, 603)
        self.assertEqual(matrix.tmdb_poster, '/gynBNzwyaHKtXqlEKKLioNkjKgN.jpg')
