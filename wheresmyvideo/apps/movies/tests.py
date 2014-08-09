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

    def test_search_tmdb(self):
        resp = models.Movie.search_tmdb('i dig dirt')
        self.assertEqual(resp.get('total_results'), 1)
        results = resp.get('results')
        self.assertEqual(results[0].get('title', ''), 'I Dig Dirt')
        self.assertEqual(results[0].get('id', 0), 285885)