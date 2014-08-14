'use strict'

TMDB_API_KEY = 'a130bee5ca0cad68fc6faf0d00a09217'

angular.module('app.videos', [])

.controller('videoListCtrl', [
    '$scope', '$filter', '$http'
    ($scope, $filter, $http) ->
        $scope.videos = []
        $scope.filteredVideos = []
        $scope.searchKeywords = ''
        $scope.row = ''

        $scope.getMovieList = ->
            resp = $http.get('http://127.0.0.1:8002/api/v1/movies/')
            resp.success((data)->
                console.debug('video list data')
                console.debug(data)
                $scope.videos = data
            )
            resp.error((err)->
                console.debug(err)
            )

        $scope.select = (page) ->
            start = (page - 1) * $scope.numPerPage
            end = start + $scope.numPerPage
            $scope.currentPageStores = $scope.filteredVideos.slice(start, end)
            # console.log start
            # console.log end
            # console.log $scope.currentPageStores

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

        # init
        init = ->
            resp = $scope.getMovieList()
            resp.success(->
                $scope.search()
                $scope.select($scope.currentPage)
            )
        init()
])

.controller('videoSearchCtrl', [
    '$scope', 'TmdbService'
    ($scope, TmdbService) ->
        $scope.query = ''
        $scope.searchMsg = null
        $scope.data = {
            results: []
            total_results: 0
        }
        $scope.currentPage = 1

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
])

.factory({
    TmdbService: [
        '$resource',
        ($resource) ->
            url = 'http://api.themoviedb.org/3/:method/:what'
            return $resource(url,
                {api_key: TMDB_API_KEY, callback: 'JSON_CALLBACK'},
                {get: {method: 'JSONP', requestType: 'json'}}
            )
    ]
})

#.factory('TmdbService', ($resource) ->
#    url = 'http://api.themoviedb.org/3/:method/:what'
#    return $resource(url,
#        {api_key: TMDB_API_KEY, callback: 'JSON_CALLBACK'},
#        {get: {method: 'JSONP', requestType: 'json'}}
#    )
#)

