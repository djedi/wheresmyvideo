'use strict'

angular.module('app.account', [])

.controller('profileCtrl', [
    '$scope', '$window'
    ($scope, $window) ->
        $scope.profile = {
            video_count: $window.sessionStorage.video_count or 0
            wish_count: $window.sessionStorage.wish_count or 0
        }
])