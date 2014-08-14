'use strict'

angular.module('app.movies', [])

.controller('movieListCtrl', [
    '$scope', '$filter', '$http'
    ($scope, $filter, $http) ->
        $scope.movieList = []
        $scope.filteredMovies = []
        $scope.searchKeywords = ''
        $scope.row = ''

        $scope.getMovieList = ->
            resp = $http.get('http://127.0.0.1:8002/api/v1/movies/')
            resp.success((data)->
                console.debug('movie list data')
                console.debug(data)
                $scope.movieList = data
            )
            resp.error((err)->
                console.debug(err)
            )

        $scope.select = (page) ->
            start = (page - 1) * $scope.numPerPage
            end = start + $scope.numPerPage
            $scope.currentPageStores = $scope.filteredMovies.slice(start, end)
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
            $scope.filteredMovies = $filter('filter')($scope.movieList, $scope.searchKeywords)
            $scope.onFilterChange()

        # orderBy
        $scope.order = (rowName)->
            if $scope.row == rowName
                return
            $scope.row = rowName
            $scope.filteredMovies = $filter('orderBy')($scope.movieList, rowName)
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