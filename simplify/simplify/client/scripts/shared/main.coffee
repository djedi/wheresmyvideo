'use strict';

if window.location.host == 'wheresmyvideo.com'
    apiRoot = 'http://api.wheresmyvideo.com/v1/'
    DEV = false
else
    apiRoot = 'http://127.0.0.1:8002/v1/'
    DEV = true

angular.module('app.controllers', [])

.constant('API', {
    login: apiRoot + 'rest-auth/login/'
    logout: apiRoot + 'rest-auth/logout/'
    register: apiRoot + 'rest-auth/register/'
    userDetails: apiRoot + 'user/'
    forgotPassword: apiRoot + 'rest-auth/password/reset/'
    mediaTypes: apiRoot + 'media-types/'
    movieList: apiRoot + 'user-movies/'
    addTmdb: apiRoot + 'movies/add/tmdb/'
    setMediaTypes: apiRoot + 'media-types/set/'
    userMediaTypes: apiRoot + 'media-types/user-set/'
    updateUserMovieMedia: apiRoot + 'user-movies/update-media-types/'
})

# overall control
.controller('AppCtrl', [
    '$scope', '$rootScope', 'AUTH_EVENTS', 'AuthService', '$location', '$http', '$window', 'API'
    ($scope, $rootScope, AUTH_EVENTS, AuthService, $location, $http, $window, API) ->
        $scope.currentUser = AuthService.getName()
        $scope.DEV = DEV

        $scope.setCurrentUser = (user) ->
            $scope.currentUser = user

        $scope.$on(AUTH_EVENTS.userSet, ->
            $scope.currentUser = AuthService.getName()
            $scope.main.name = AuthService.getName()
            $scope.main.email = AuthService.getEmail()
            $scope.main.username = AuthService.getUsername()
            $scope.main.selectedMediaTypeIds = AuthService.getSelectedMediaTypeIds()
        )

        $scope.$on(AUTH_EVENTS.loginSuccess, ->
            $scope.getMediaTypes()
        )

        $scope.$on(AUTH_EVENTS.notAuthenticated, ->
            path = $location.path()
            if not (/^\/auth/).test(path) and not (/^\/public/).test(path)
                $location.path('/auth/login')
        )

        $scope.main =
            brand: 'Where\'s My Video?'
            user: {}
            name: AuthService.getName()
            email: AuthService.getEmail()
            isAuthorized: AuthService.isAuthenticated
            allMediaTypes: []
            selectedMediaTypeIds: []
            selectedMediaTypes: []

        $scope.getMediaTypes = ->
            resp = $http.get(API.mediaTypes, {cache: true})
            resp.success((data)->
                $scope.main.allMediaTypes = data
                $window.sessionStorage.all_media_types = JSON.stringify(data)
            )
            resp.error(->
                console.error('getMediaTypes Error')
            )

        $scope.logout = ->
            resp = AuthService.logout()
            resp.success(->
                $location.path('/auth/login')
            )

        $scope.pageTransitionOpts = [
            name: 'Fade up'
            class: 'animate-fade-up'
        ,   
            name: 'Scale up'
            class: 'ainmate-scale-up'
        ,   
            name: 'Slide in from right'
            class: 'ainmate-slide-in-right'
        ,   
            name: 'Flip Y'
            class: 'animate-flip-y'
        ]

        $scope.admin =
            layout: 'wide'                                  # 'boxed', 'wide'
            menu: 'vertical'                                # 'horizontal', 'vertical'
            fixedHeader: true                               # true, false
            fixedSidebar: true                              # true, false
            pageTransition: $scope.pageTransitionOpts[0]    # unlimited, check out "_animation.scss"

        $scope.$watch('admin', (newVal, oldVal) ->
            # manually trigger resize event to force morris charts to resize, a significant performance impact, enable for demo purpose only
            # if newVal.menu isnt oldVal.menu || newVal.layout isnt oldVal.layout
            #      $window.trigger('resize')

            if newVal.menu is 'horizontal' && oldVal.menu is 'vertical'
                 $rootScope.$broadcast('nav:reset')
                 return
            if newVal.fixedHeader is false && newVal.fixedSidebar is true
                if oldVal.fixedHeader is false && oldVal.fixedSidebar is false
                    $scope.admin.fixedHeader = true 
                    $scope.admin.fixedSidebar = true 
                if oldVal.fixedHeader is true && oldVal.fixedSidebar is true
                    $scope.admin.fixedHeader = false 
                    $scope.admin.fixedSidebar = false 
                return
            if newVal.fixedSidebar is true
                $scope.admin.fixedHeader = true
            if newVal.fixedHeader is false 
                $scope.admin.fixedSidebar = false

            return
        , true)

        $scope.color =
            primary:        '#5B90BF'   # rgba(91,144,191,1)
            success:        '#A3BE8C'   # rgba(163,190,140,1)
            info:           '#B48EAD'   # rgba(180,142,173,1)
            infoAlt:        '#AB7967'   # rgba(171,121,121,1)
            warning:        '#EBCB8B'   # rgba(235,203,139,1)
            danger:         '#BF616A'   # rgba(191,97,106,1)
            gray:           '#DCDCDC'
])

.controller('HeaderCtrl', [
    '$scope'
    ($scope) ->
])

.controller('NavContainerCtrl', [
    '$scope'
    ($scope) ->
])
.controller('NavCtrl', [
    '$scope', 'taskStorage', 'filterFilter'
    ($scope, taskStorage, filterFilter) ->
        # init
        tasks = $scope.tasks = taskStorage.get()
        $scope.taskRemainingCount = filterFilter(tasks, {completed: false}).length

        $scope.$on('taskRemaining:changed', (event, count) ->
            $scope.taskRemainingCount = count
        )
])

.controller('DashboardCtrl', [
    '$scope'
    ($scope) ->

])
