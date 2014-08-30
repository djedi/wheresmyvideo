'use strict'

TMDB_API_KEY = 'a130bee5ca0cad68fc6faf0d00a09217'

angular.module('app.videos', [])

.controller('videoListCtrl', [
    '$scope', '$filter', '$http', '$window', 'AuthService', '$modal', 'logger', 'API'
    ($scope, $filter, $http, $window, AuthService, $modal, logger, API) ->
        $scope.videos = []
        $scope.filteredVideos = []
        $scope.searchKeywords = ''
        $scope.row = ''
        $scope.allMediaTypes = []
        $scope.mediaNames = []
        $scope.userMediaTypes = []
        $scope.ratings = [
            {rating: 'G', class: 'btn-success', on: true},
            {rating: 'PG', class: 'btn-primary', on: true},
            {rating: 'PG-13', class: 'btn-warning', on: true},
            {rating: 'R', class: 'btn-danger', on: true},
            {rating: 'NC-17', class: 'btn-danger', on: true},
            {rating: 'UR', class: 'btn-info', on: true},
            {rating: 'NR', class: 'btn-info', on: true}
        ]

        $scope.getMovieList = ->
            resp = $http.get(API.movieList, {cache: true})
            resp.success((data)->
                $scope.videos = data
            )
            resp.error((err)->
                console.log(err)
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
            for rating in $scope.ratings
                rating.on = true
                rating.class = $scope.ratingLabel(rating.rating).replace('label', 'btn')
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
            if $window.sessionStorage.media_types
                $scope.userMediaTypes = $.parseJSON($window.sessionStorage.media_types)
            else
                resp = AuthService.getUser()
                resp.success(->
                    $scope.userMediaTypes = $.parseJSON($window.sessionStorage.media_types)
                )
                resp.error(->
                    console.error('error getting user data')
                )


        $scope.inMediaType = (id, user_movie) ->
            for mt in user_movie.media_types
                if id == mt.id
                    return true
            return false

        $scope.toggleMediaType = (user_movie, media_type) ->
            if $scope.inMediaType(media_type.id, user_movie)
                for mt in user_movie.media_types
                    if mt and media_type.id == mt.id
                        idx = user_movie.media_types.indexOf(mt)
                        user_movie.media_types.splice(idx, 1)
                        break
            else
                user_movie.media_types.push(media_type)
            $http.put(API.updateUserMovieMedia, {id: user_movie.id, media_types: user_movie.media_types})
            .success((data)->
                return
            ).error((err)->
                return
            )
            return

        $scope.ratingLabel = (rating) ->
            if rating == 'G'
                return 'label-success'
            else if rating == 'PG'
                return 'label-primary'
            else if rating == 'PG-13'
                return 'label-warning'
            else if rating in ['R', 'NC-17']
                return 'label-danger'
            else
                return 'label-info'

        $scope.toggleRatingFilter = (rating) ->
            if rating.on
                rating.class = 'btn-default'
                rating.on = false
            else
                rating.on = true
                rating.class = $scope.ratingLabel(rating.rating).replace('label', 'btn')
            $scope.filteredVideos = $filter('filter')($scope.videos, (value)->
                for rating in $scope.ratings
                    if rating.rating == value.movie.rating
                        return rating.on
                if !value.rating
                    return $scope.ratings[6].on
                return true
            )
            $scope.onFilterChange()

        $scope.deleteMovie = (user_movie) ->
            modalInstance = $modal.open(
                templateUrl: "modalConfirmDelete.html"
                controller: 'ModalConfirmDelete'
            )
            modalInstance.result.then ((action) ->
                resp = $http.delete(API.movieList + user_movie.id + '/')
                resp.success(->
                    $scope.videos.splice($scope.videos.indexOf(user_movie), 1)
                    $scope.filteredVideos.splice($scope.filteredVideos.indexOf(user_movie), 1)
                    $scope.currentPageStores.splice($scope.currentPageStores.indexOf(user_movie), 1)
                )
                resp.error(->
                    logger.error('There was an error removing the video.')
                )
                return
            ), ->
                return

            return

        # init
        init = ->
            resp = $scope.getMovieList()
            resp.success(->
                $scope.search()
                $scope.select($scope.currentPage)
            )
            $scope.getUserMediaTypes()
        init()
])
.controller('ModalConfirmDelete', [
    '$scope', '$modalInstance'
    ($scope, $modalInstance) ->
        $scope.ok = ->
            $modalInstance.close 'delete'
            return

        $scope.cancel = ->
            $modalInstance.dismiss 'cancel'
            return

        return
])

.controller('videoSearchCtrl', [
    '$scope', 'TmdbService', 'logger', '$http', '$cacheFactory', 'AuthService', '$window', 'API'
    ($scope, TmdbService, logger, $http, $cacheFactory, AuthService, $window, API) ->
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
            resp = $http.post(API.addTmdb, {id: tmdb_id, media_type_id: media_type_id})
            resp.success((data) ->
                logger.logSuccess(data.movie.title + ' added successfully.')
                $httpDefaultCache = $cacheFactory.get('$http')
                $httpDefaultCache.remove(API.movieList)
            )
            resp.error((err) ->
                console.log('Error adding movie')
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
    '$scope', '$http', '$window', 'API'
    ($scope, $http, $window, API) ->
        $scope.foo = 'bar'
        $scope.selectedTypeIds = $.parseJSON($window.sessionStorage.media_type_ids)
        $scope.allMediaTypes = $.parseJSON($window.sessionStorage.all_media_types)

        $scope.toggleSelection = (id) ->
            idx = $scope.selectedTypeIds.indexOf(id)
            if idx > -1  # already in list, remove it
                $scope.selectedTypeIds.splice(idx, 1)
            else  # add it to the list
                $scope.selectedTypeIds.push(id)
            resp = $http.post(API.setMediaTypes, {type_ids: $scope.selectedTypeIds})
            resp.success((data)->)
            resp.error(->
                console.error('toggleSelection Error')
            )
            $window.sessionStorage.media_type_ids = JSON.stringify($scope.selectedTypeIds)
            mediaTypes = []
            for mt in $scope.allMediaTypes
                if mt.id in $scope.selectedTypeIds
                    mediaTypes.push(mt)
                    $window.sessionStorage.media_types = JSON.stringify(mediaTypes)
])

.directive('movieposter', ->
    return {
        restrict: 'E'
        template: '<a href="javascript:;" ng-click="openShadowbox()"><img ng-src="https://image.tmdb.org/t/p/w92{{ tmdb_poster }}" title="{{ title }}" alt="No Image"></a>'
        scope: {
            tmdb_poster: '@tmdbPoster'
            title: '@title'
        }
        link: (scope, element, attrs) ->
            scope.openShadowbox = ->
                Shadowbox.open({
                    content: 'https://image.tmdb.org/t/p/w396' + scope.tmdb_poster
                    player: 'img'
                })
    }
)