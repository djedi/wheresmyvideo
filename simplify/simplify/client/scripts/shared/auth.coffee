'use strict';

USER_DETAILS_URL = 'http://127.0.0.1:8002/api/v1/user/'

angular.module('app.auth', [])

.constant('AUTH_EVENTS', {
    loginSuccess: 'auth-login-success',
    loginFailed: 'auth-login-failed',
    logoutSuccess: 'auth-logout-success',
    sessionTimeout: 'auth-session-timeout',
    notAuthenticated: 'auth-not-authenticated',
    notAuthorized: 'auth-not-authorized',
    userSet: 'auth-user-set',
})

.factory('AuthService', ($http, logger, $window, $rootScope, AUTH_EVENTS, $cacheFactory) ->
    authService = {
        name: null
    }

    authService.login = (credentials) ->
        login_url = 'http://127.0.0.1:8002/rest-auth/login/'
        resp = $http.post(login_url, {
            username: credentials.username,
            password: credentials.password,
        })
        resp.success((data) ->
            if data.key
                $window.sessionStorage.token = data.key
                authService.getUser()
            else
                logger.logError('Sorry, there was a problem logging in.')
        )
        resp.error((data) ->
            reported = false
            if data.error
                logger.logError(data.error)
                reported = true
            if data.detail
                if data.detail == 'Invalid token'
                    $window.sessionStorage.clear()
                    logger.logError('You had an invalid token in your session
                        cache. It has been removed. Please try to log in again.')
                    reported = true
                else
                    logger.logError(data.detail)
                    reported = true
            if not reported
                logger.logError('Sorry, there was an error trying to log you in.')

        )
        return resp

    authService.logout = ->
        logout_url = 'http://127.0.0.1:8002/rest-auth/logout/'
        resp = $http.get(logout_url)
        resp.success((data)->
            logger.logSuccess(data.success)
            $window.sessionStorage.clear()
            $rootScope.$broadcast(AUTH_EVENTS.userSet)
            $httpDefaultCache = $cacheFactory.get('$http')
            $httpDefaultCache.removeAll()
        )
        resp.error((data)->
            console.debug('LOG OUT ERROR')
            console.debut(data)
        )
        return resp

    authService.getUser = ->
        resp = $http.get(USER_DETAILS_URL, {cache: true})
        resp.success((data) ->
            $window.sessionStorage.username = data.username
            $window.sessionStorage.email = data.email
            $window.sessionStorage.first_name = data.first_name
            $window.sessionStorage.last_name = data.last_name
            $window.sessionStorage.name = data.display_name
            $window.sessionStorage.video_count = data.video_count
            $window.sessionStorage.wish_count = data.wish_count or 0
            $window.sessionStorage.media_type_ids = JSON.stringify(data.media_type_ids)
            $window.sessionStorage.media_types = JSON.stringify(data.media_types)
            authService.name = data.display_name
            $rootScope.$broadcast(AUTH_EVENTS.userSet)
        )
        resp.error(->
            console.debug("Couldn't get user data")
        )
        return resp

    authService.isAuthenticated = ->
        return !!$window.sessionStorage.token

    authService.getName = ->
        return $window.sessionStorage.name

    authService.getEmail = ->
        return $window.sessionStorage.email

    authService.getSelectedMediaTypeIds = ->
        if $window.sessionStorage.media_type_ids
            return $.parseJSON($window.sessionStorage.media_type_ids)
        else
            return []

    return authService
)

.run(($rootScope, AUTH_EVENTS, AuthService, $location) ->
    $rootScope.$on('$routeChangeSuccess', (event, next) ->
        if not AuthService.isAuthenticated()
            $rootScope.$broadcast(AUTH_EVENTS.notAuthenticated)
    )
)

.factory('authInterceptor', ($rootScope, $q, $window) ->
    return {
        request: (config) ->
            config.headers = config.headers || {}
            if $window.sessionStorage.token
                config.headers.Authorization = 'Token ' + $window.sessionStorage.token
            return config
        response: (response) ->
            if response.status == 401
                console.debug('REDIRECT TO SIGN IN')
            return response || $q.when(response)
    }
)
.config(($httpProvider) ->
    $httpProvider.interceptors.push('authInterceptor')
)

.controller('SignUpCtrl', [
    '$scope', '$rootScope', '$http', 'AUTH_EVENTS', 'AuthService', 'logger', '$location'
    ($scope, $rootScope, $http, AUTH_EVENTS, AuthService, logger, $location) ->
        $scope.credentials = {
            username: '',
            password: '',
            email: '',
        }
        $scope.signUp = (credentials)->
            url = 'http://127.0.0.1:8002/rest-auth/register/'
            resp = $http.post(url, {
                username: credentials.username,
                email: credentials.email,
                password: credentials.password,
            })
            resp.success((data) ->
                console.debug(data)
                resp1 = AuthService.login(credentials)
                resp1.success(->
                    $rootScope.$broadcast(AUTH_EVENTS.loginSuccess)
                    $location.path('/')
                )
                resp1.error(->
                    $rootScope.$broadcast(AUTH_EVENTS.loginFailed)
                )
            )
            resp.error((error) ->
                console.debug('ERROR')
                console.debug(error)
                logger.logError(error.user.username)
            )
])
.controller('SignInCtrl', [
    '$scope', '$rootScope', '$http', 'logger', 'AUTH_EVENTS', 'AuthService', '$location'
    ($scope, $rootScope, $http, logger, AUTH_EVENTS, AuthService, $location) ->
        $scope.credentials = {
            username: '',
            password: '',
        }
        $scope.login = (credentials)->
            resp = AuthService.login(credentials)
            resp.success((data)->
                $rootScope.$broadcast(AUTH_EVENTS.loginSuccess)
                $location.path('/')
            )
            resp.error(->
                $rootScope.$broadcast(AUTH_EVENTS.loginFailed)
            )
])