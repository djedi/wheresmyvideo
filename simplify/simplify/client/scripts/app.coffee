'use strict';

angular.module('app', [
    # Angular modules
    'ngRoute'
    'ngAnimate'
    'ngResource'

    # 3rd Party Modules
    'ui.bootstrap'
    'easypiechart'
    'ui.tree'
    'ngMap'
    'ngTagsInput'
    'ui.gravatar'

    # Custom modules
    'app.controllers'
    'app.directives'
    'app.auth'
    'app.account'
    'app.localization'
    'app.nav'
    'app.ui.ctrls'
    'app.ui.directives'
    'app.ui.services'
    'app.form.validation'
    'app.ui.form.ctrls'
    'app.ui.form.directives'
    'app.videos'
    'app.tables'
    'app.task'
    'app.chart.ctrls'
    'app.chart.directives'
    'app.page.ctrls'
])
    
.config([
    '$routeProvider'
    ($routeProvider) ->

        routes = [
            'auth/login', 'auth/register', 'auth/forgot-password',
            'videos/list', 'videos/add', 'videos/media-types'
            'dashboard'
            'ui/typography', 'ui/buttons', 'ui/icons', 'ui/grids', 'ui/widgets', 'ui/components', 'ui/boxes', 'ui/timeline', 'ui/nested-lists', 'ui/pricing-tables', 'ui/maps'
            'tables/static', 'tables/dynamic', 'tables/responsive'
            'forms/elements', 'forms/layouts', 'forms/validation', 'forms/wizard'
            'charts/charts', 'charts/flot', 'charts/chartjs'
            'pages/404', 'pages/500', 'pages/blank', 'pages/forgot-password', 'pages/invoice', 'pages/lock-screen', 'pages/profile', 'pages/signin', 'pages/signup'
            'mail/compose', 'mail/inbox', 'mail/single'
            'tasks/tasks'
        ]

        setRoutes = (route) ->
            url = '/' + route
            config =
                templateUrl: 'views/' + route + '.html'

            $routeProvider.when(url, config)
            return $routeProvider

        routes.forEach( (route) ->
            setRoutes(route)
        )
        $routeProvider
            .when('/', { redirectTo: '/videos/list'} )
            .when('/public/:username', { templateUrl: 'views/videos/list.html', controller: 'videoListCtrl'})
            .when('/404', { templateUrl: 'views/pages/404.html'} )
            .otherwise( redirectTo: '/404' )
])

.config([
    'gravatarServiceProvider', (gravatarServiceProvider) ->
        gravatarServiceProvider.defaults = {
            size: 100,
            "default": 'mm'  # Mystery man as default for missing avatars
        }

        # Use https endpoint
        gravatarServiceProvider.secure = false
])

$(window).load(->
    Shadowbox.init({
        skipSetup: true
    })
)
