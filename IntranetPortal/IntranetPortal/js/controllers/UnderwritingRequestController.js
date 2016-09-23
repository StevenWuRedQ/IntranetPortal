angular.module("PortalApp")
.controller('UnderwritingRequestController', ['$scope', '$http', '$location', '$state', 'UnderwritingRequest', 'ptCom', function ($scope, $http, $location, $state, UnderwritingRequest, ptCom) {
    $scope.location = $location;
    $scope.state = $state;
    $scope.init = function () {
        $scope.data = {};
        $scope.BBLE = $location.search().BBLE || '';
        if ($state.current.data) {
            $scope.Review = $state.current.data.Review || '';
        }
        if ($scope.BBLE) {
            $scope.data = UnderwritingRequest.get({ BBLE: $scope.BBLE.trim(),  }, function () {
                $scope.data.BBLE = $scope.BBLE;
            }, function () {
                $scope.data.BBLE = $scope.BBLE;
            })
        }
    }
    $scope.save = function () {
        UnderwritingRequest.saveByBBLE($scope.data).then(function () {
            ptCom.alert('Save Successful!')
        }, function () {
            ptCom.alert('Fail to Save!')
        });

    }

    $scope.$watch(function () { return $location.search() }, function () {
        // debugger;
        if($location.search().BBLE){
            $scope.init();
        }
        
    }, true);

    if (!$state.current.data || !$state.current.data.Review) {
        $scope.init();
    }


}]);