angular.module("PortalApp").controller("UnderwriterController",
                ['$scope', 'ptCom', 'ptUnderwriter', '$location', '$http',
        function ($scope, ptCom, ptUnderwriter, $location, $http) {

            $scope.data = {};
            $scope.list = {/*dataSource*/ };
            $scope.init = function (bble) {
                //ptCom.startLoading()
                $scope.data = ptUnderwriter.load(bble);
                if ($scope.data.$promise) {
                    $scope.data.$promise.then(function () {
                        $scope.calculate();
                    })
                }
                //$scope.feedData();
            }

            // a predefined model to validate with excel data
            $scope.feedData = function () {
                $scope.data.PropertyInfo.TaxClass = 'A0',
                $scope.data.PropertyInfo.ActualNumOfUnits = 1
                $scope.data.PropertyInfo.SellerOccupied = true;
                $scope.data.PropertyInfo.PropertyTaxYear = 4297.0;
                $scope.data.DealCosts.HOI = 20000.0;
                $scope.data.DealCosts.AgentCommission = 2500;
                $scope.data.RehabInfo.AverageLowValue = 205166;
                $scope.data.RehabInfo.RenovatedValue = 510000;
                $scope.data.RehabInfo.RepairBid = 75000;
                $scope.data.RehabInfo.DealTimeMonths = 6;

                $scope.data.LienInfo.FirstMortgage = 340000;
                $scope.data.LienInfo.SecondMortgage = 284000;
                $scope.data.LienCosts.PropertyTaxes = 9113.32;
                $scope.data.LienCosts.WaterCharges = 1101.33;
                $scope.data.LienCosts.PersonalJudgements = 14892.09;
                $scope.update();
            }

            $scope.calculate = function () {
                $scope.$applyAsync(function () {
                    ptUnderwriter.applyRule($scope.data);
                });
            }

            $scope.save = function () {
                ptUnderwriter.save($scope.data).then(function (d) {
                    //debugger;
                    if (d.data) {
                        $scope.data = d.data;
                    }
                    alert("Save Successful");
                }, function () {
                    alert("fail to save");
                })

            }

            $scope.onSelectionChange = function () {

            }

            // init controller;
            var search = $location.search();
            if (search && search.BBLE) {
                $scope.init(search.BBLE)
            } else {
                $scope.init();
            }
        }]);