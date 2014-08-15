'use strict'

angular.module('app.account', [])

.controller('profileCtrl', [
    '$scope'
    ($scope) ->
        $scope.data = {
            video_count: '?'
            wish_count: 0
        }
])