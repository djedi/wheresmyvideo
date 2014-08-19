'use strict'

TMDB_API_KEY = 'a130bee5ca0cad68fc6faf0d00a09217'
MOVIE_LIST_URL = 'http://127.0.0.1:8002/api/v1/movies/'
ADD_TMDB_MOVIE_URL = 'http://127.0.0.1:8002/api/v1/movies/add/tmdb/'
SET_MEDIA_TYPES_URL = 'http://127.0.0.1:8002/api/v1/media-types/set/'
USER_MEDIA_TYPES_URL = 'http://127.0.0.1:8002/api/v1/media-types/user-set/'

angular.module('app.videos', [])

.controller('videoListCtrl', [
    '$scope', '$filter', '$http', '$window', 'AuthService'
    ($scope, $filter, $http, $window, AuthService) ->
        $scope.videos = []
        $scope.filteredVideos = []
        $scope.searchKeywords = ''
        $scope.row = ''
        $scope.mediaNames = []
        $scope.userMediaTypes = []

        $scope.getMovieList = ->
            resp = $http.get(MOVIE_LIST_URL, {cache: true})
            resp.success((data)->
                $scope.videos = data
            )
            resp.error((err)->
                console.debug(err)
            )

        $scope.select = (page) ->
            start = (page - 1) * $scope.numPerPage
            end = start + $scope.numPerPage
            $scope.currentPageStores = $scope.filteredVideos.slice(start, end)

        # on page change: change numPerPage, filtering string
        $scope.onFilterChange = ->
            $scope.select(1)
            $scope.currentPage = 1
            $scope.row = ''

        $scope.onNumPerPageChange = ->
            $scope.select(1)
            $scope.currentPage = 1

        $scope.onOrderChange = ->
            $scope.select(1)
            $scope.currentPage = 1


        $scope.search = ->
            $scope.filteredVideos = $filter('filter')($scope.videos, $scope.searchKeywords)
            $scope.onFilterChange()

        # orderBy
        $scope.order = (rowName)->
            if $scope.row == rowName
                return
            $scope.row = rowName
            $scope.filteredVideos = $filter('orderBy')($scope.videos, rowName)
            $scope.onOrderChange()

        # pagination
        $scope.numPerPageOpt = [3, 5, 10, 20]
        $scope.numPerPage = $scope.numPerPageOpt[2]
        $scope.currentPage = 1
        $scope.currentPageStores = []

        $scope.getMediaTypeName = (id) ->
            return $scope.mediaNames[id]

        $scope.getUserMediaTypes = ->
            ids = AuthService.getSelectedMediaTypeIds()
            for type in $.parseJSON($window.sessionStorage.all_media_types)
                if type.id in ids
                    $scope.userMediaTypes.push(type)

        $scope.inMediaType = (id, mediaTypes) ->
            return id in mediaTypes

        $scope.toggleMediaType = (video, media_type_id) ->
            # TODO: add media type to movie
            if media_type_id in video.media_types
                video.media_types.splice(video.media_types.indexOf(media_type_id), 1)
            else
                video.media_types.push(media_type_id)
            return null

        # init
        init = ->
            resp = $scope.getMovieList()
            resp.success(->
                $scope.search()
                $scope.select($scope.currentPage)
            )
            mediaTypes = $.parseJSON($window.sessionStorage.all_media_types)
            for mt in mediaTypes
                $scope.mediaNames[mt.id] = mt.name
            $scope.getUserMediaTypes()
        init()
])

.controller('videoSearchCtrl', [
    '$scope', 'TmdbService', 'logger', '$http', '$cacheFactory', 'AuthService', '$window'
    ($scope, TmdbService, logger, $http, $cacheFactory, AuthService, $window) ->
        $scope.query = ''
        $scope.searchMsg = null
        $scope.data = {
            results: []
            total_results: 0
        }
        $scope.currentPage = 1
        $scope.RESULTS_PER_PAGE = 20  # tmdb constant, can't really change this
        $scope.userMediaTypes = []

        $scope.search = (query) ->
            if query
                $scope.currentPage = 1
                $scope.searchMsg = 'Searching for "' + query + '"...'
                TmdbService.get({
                    method: 'search',
                    what: 'movie',
                    query: query,
                    page: $scope.currentPage,
                }, (data)->
                    console.debug(data)
                    $scope.searchMsg = null
                    $scope.data = data
                )

        $scope.pageChanged = ->
            $scope.data.results = []
            $scope.searchMsg = 'Loading new page...'
            TmdbService.get({
                method: 'search',
                what: 'movie',
                query: $scope.query,
                page: $scope.currentPage,
            }, (data)->
                $scope.searchMsg = null
                $scope.data = data
            )

        $scope.addMovie = (tmdb_id, media_type_id)->
            resp = $http.post(ADD_TMDB_MOVIE_URL, {id: tmdb_id, media_type_id: media_type_id})
            resp.success((data) ->
                logger.logSuccess(data.movie.title + ' added successfully.')
                $httpDefaultCache = $cacheFactory.get('$http')
                $httpDefaultCache.remove(MOVIE_LIST_URL)
            )
            resp.error((err) ->
                console.debug('Error adding movie')
            )

        $scope.getUserMediaTypes = ->
            ids = AuthService.getSelectedMediaTypeIds()
            for type in $.parseJSON($window.sessionStorage.all_media_types)
                if type.id in ids
                    $scope.userMediaTypes.push(type)

        init = ->
            $scope.getUserMediaTypes()
        init()
])

#.factory({
#    TmdbService: [
#        '$resource',
#        ($resource) ->
#            url = 'http://api.themoviedb.org/3/:method/:what'
#            return $resource(url,
#                {api_key: TMDB_API_KEY, callback: 'JSON_CALLBACK'},
#                {get: {method: 'JSONP', requestType: 'json'}}
#            )
#    ]
#})

.factory('TmdbService', ($resource) ->
    url = 'http://api.themoviedb.org/3/:method/:what'
    return $resource(url,
        {api_key: TMDB_API_KEY, callback: 'JSON_CALLBACK'},
        {get: {method: 'JSONP', requestType: 'json'}}
    )
)

.controller('mediaTypesCtrl', [
    '$scope', '$http', '$window'
    ($scope, $http, $window) ->
        $scope.foo = 'bar'
        $scope.selectedTypes = $.parseJSON($window.sessionStorage.media_types)
        $scope.mediaTypes = $.parseJSON($window.sessionStorage.all_media_types)

        $scope.toggleSelection = (id) ->
            idx = $scope.selectedTypes.indexOf(id)
            if idx > -1  # already in list, remove it
                $scope.selectedTypes.splice(idx, 1)
            else  # add it to the list
                $scope.selectedTypes.push(id)
            resp = $http.post(SET_MEDIA_TYPES_URL, {type_ids: $scope.selectedTypes})
            resp.success((data)->)
            resp.error(->
                console.error('toggleSelection Error')
            )
            $window.sessionStorage.media_types = JSON.stringify($scope.selectedTypes)
            #console.debug($scope.selectedTypes)
])