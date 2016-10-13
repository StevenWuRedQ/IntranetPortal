angular.module("PortalApp")
.controller('UnderwritingRequestController', ['$scope', '$http', '$location', '$state', 'UnderwritingRequest', 'ptCom', function ($scope, $http, $location, $state, UnderwritingRequest, ptCom) {
    $scope.init = function () {
        $scope.data = {};
        $scope.BBLE = $location.search().BBLE || '';
        if ($state.current.data) {
            $scope.Review = $state.current.data.Review || '';
        }
        if ($scope.BBLE) {
            $scope.data = UnderwritingRequest.get({ BBLE: $scope.BBLE.trim(), }, function () {
                $scope.data.BBLE = $scope.BBLE;
                UnderwritingRequest.getAdditionalInfo($scope.data.BBLE).then(function success(res) {
                    $scope.data.Address = res.data.Address;
                    $scope.data.Status = res.data.Status || $scope.data.Status;
                    $scope.data.CompletedDate = res.data.CompletedDate || undefined;

                }, function error() {
                    console.log('fail to fetch addiontal infomation.')
                });

            }, function () {
                $scope.data.BBLE = $scope.BBLE;
            })
        }
    }

    //check input and textarea to see if there is a error attribute
    $scope.checkValidate = function (async) {
        if (!async) {
            return _.some($('input, textarea, select'), function (v) {
                return $(v).attr('error') == 'true';
            })
        } else {
            var dfd = $.Deferred();

            var err = _.some($('input, textarea, select'), function (v) {
                return $(v).attr('error') == 'true';
            });

            if (err) {
                dfd.resolve();
            } else {
                dfd.reject();
            }

            return dfd;
        }

    }

    //broadcast ptSelfCheck event make ptRequried directive check it self
    $scope.selfCheck = function () {
        $scope.$broadcast('ptSelfCheck');

        var startFlag = false
        var checkingcounter = 0;
        $scope.$on('ptSelfCheckStart', function () {
            startFlag = true;
            checkingcounter++;
        });

    }


    $scope.save = function (isSlient) {
        $scope.$broadcast('ptSelfCheck');

        if ($scope.checkValidate()) {
            ptCom.alert('Please correct Highlight Field first.');
            return;
        }

        UnderwritingRequest.saveByBBLE($scope.data).then(function () {
            if (!isSlient) {
                ptCom.alert('Save Successful!')
            }

        }, function () {
            if (!isSlient) {
                ptCom.alert('Fail to Save!')
            }
        });

    }


    $scope.requestDocSearch = function () {
        $scope.$broadcast('ptSelfCheck');
        // debugger;
        if ($scope.checkValidate()) {
            ptCom.alert('Please correct Highlight Field first.');
            return;
        }

        UnderwritingRequest.createSearch($scope.BBLE).then(function () {
            ptCom.alert('Property Search Submitted to Underwriting. Thank you!');
            $scope.data.Status = 1;
            $scope.save(true);
        }, function () {
            ptCom.alert('Fail to create search')

        })
    }

    $scope.completedOver60days = function () {
        if ($scope.data.CompletedDate == undefined){
            return false;
        }
        else {
            timenow = new Date().getTime();
            timeCompleted = new Date($scope.data.CompletedDate);
            _60days = 1000 * 60 * 60 * 24 * 60;
            return timenow - timeCompleted > _60days ? true : false;

        }
        
    }

    $scope.$watch(function () { return $location.search() }, function () {
        // debugger;
        if ($location.search().BBLE) {
            $scope.init();
        }

    }, true);

    if (!$state.current.data || !$state.current.data.Review) {
        $scope.init();
    }


}]);