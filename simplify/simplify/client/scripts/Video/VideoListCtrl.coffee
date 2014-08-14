'use strict'

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