angular.module("PortalApp").controller("UnderwriterController",
                ['$scope', 'ptCom', 'ptUnderwriter', '$location',
        function ($scope, ptCom, ptUnderwriter, $location) {

            $scope.data = {};
            $scope.archive = {};
            $scope.currentDataCopy = {};

            $scope.init = function (bble) {
                //ptCom.startLoading()
                //$scope.feedData();
                $scope.load(bble);
                $scope.loadArchivedList(bble);
            }

            $scope.load = function (bble) {
                $scope.data = ptUnderwriter.load(bble);
                if ($scope.data.$promise) {
                    $scope.data.$promise.then(function () {
                        $scope.calculate();
                    })
                }
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

            /*
             * snapshot current values of forms,
             * and sava copy in database for future analysis
             */
            $scope.archive = function () {
                ptCom.prompt('Please give a name to this archive.', function (msg) {
                    //debugger;
                    if (msg != null) {
                        ptUnderwriter.archive($scope.data, msg).then(function (d) {
                            alert("Archive succesful.")
                        }, function () {
                            alert("Sorry...Some error...")
                        })
                    }

                })
                

            }

            /**
             * load all achived version in databases
             */
            $scope.loadArchivedList = function (bble) {
                ptUnderwriter.loadArchivedList(bble).then(function (d) {
                    $scope.archivedList = d.data;
                })
            }

            /**
             * load a single archived entry in database
             * @param: archive
             */
            $scope.loadArchived = function (archive) {
                //debugger;
                if (archive.Id) {
                    ptUnderwriter.loadArchived(archive.Id).then(function (d) {
                        if (d.data) {
                            //debugger;
                            angular.copy($scope.data, $scope.currentDataCopy);
                            ptCom.assignReference($scope.data, d.data, [], ['Id']);
                            $scope.archive = archive;
                            $scope.archive.isLoaded = true;
                            ptCom.alert("Load successful");

                        }
                    }, function (d) {
                        ptCom.alert("Fail to load.");
                    })
                }

            }

            $scope.restoreCurrent = function () {
                if ($scope.currentDataCopy) {
                    ptCom.assignReference($scope.data, $scope.currentDataCopy);
                    $scope.archive.isLoaded = false;
                    ptCom.alert("Restore to current version.")
                }
            }

            /*
             * Core function to apply predefined rule, 
             * and update model values 
             */
            $scope.calculate = function () {
                $scope.$applyAsync(function () {
                    ptUnderwriter.calculator.calculate($scope.data);
                });
            }

            /*
             * A predefined model to validate with excel data
             */
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

            // init controller;
            var search = $location.search();
            if (search && search.BBLE) {
                $scope.init(search.BBLE)
            } else {
                $scope.init();
            }
        }]);