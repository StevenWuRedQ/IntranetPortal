angular.module("PortalApp")
.controller('UnderwritingRequestController', ['$scope', '$http', '$location', 'UnderwritingRequest', function ($scope, $http, $location, UnderwritingRequest) {

    $scope.BBLE = $location.search().BBLE || '';
    $scope.init = function (BBLE) {
        if (BBLE) {
            $scope.data = UnderwritingRequest.get({ BBLE: BBLE.trim() })
        }

    }
    $scope.save = function () {
        $scope.data.$save({ BBLE: $scope.BBLE.trim() })
    }




    $scope.init($scope.BBLE);

}]);