/**
 * Author: Shaopeng Zhang
 * Date: 2016/11/02
 * Description: General Controller for underwriting
 * Update: 
 *          --- 2016/11/02
 *              1. Add Enable Editing Function to unlock datainput area.
 */
angular.module("PortalApp").controller("UnderwritingController", [
    "$scope", "ptCom", "ptUnderwriting", "$location", "$state", "DocSearch", "LeadsInfo",
    function ($scope, ptCom, ptUnderwriting, $location, $state, DocSearch, LeadsInfo) {

        $scope.data = {};
        $scope.archive = {};
        $scope.currentDataCopy = {};
        $scope.isProtectedView = true;
        $scope.debug = false;
        var float = function (data) {
            if (data)
                return parseFloat(data);
            else
                return 0.0;
        };
        var int = function (data) {
            if (data)
                return parseInt(data);
            else
                return 0;
        };
        $scope.init = function (bble) {
            if (bble) {
                ptUnderwriting.load(bble).then(function (data) {
                    if (data && data.Id) {
                        $scope.data = data;
                        ptUnderwriting.loadArchivedList(bble).then(function (list) {
                            $scope.archivedList = list;
                        });
                    } else {
                        var newData = ptUnderwriting.new();
                        newData.BBLE = bble;
                        DocSearch.get({ BBLE: bble }).$promise.then(function (search) {
                            newData.docSearch = search;
                            LeadsInfo.get({ BBLE: bble.trim() }).$promise.then(function (leadsInfo) {
                                newData.leadsInfo = leadsInfo;
                                ptUnderwriting.importData(newData);
                            });
                        });
                        $scope.data = newData;
                    }
                }, function (e) {
                    console.log(e);
                    ptCom.alert("Failed to load.");
                });
            } else {
                $scope.data = ptUnderwriting.new();
            }
        };
        $scope.save = function () {
            ptCom.confirm("Are you going to save?",
                function (response) {
                    if (response) {
                        ptUnderwriting.save($scope.data).then(function done(data) {
                            if (data) {
                                $scope.data = data;
                            }
                            ptCom.alert("Saved Successfully.");
                        }, function fail(e) {
                            console.log(e);
                            ptCom.alert("Failed to save.");
                        });
                    }
                });
        };
        // Snapshot current values of forms, and sava copy in database for future analysis
        $scope.archiveFunc = function () {
            ptCom.prompt("Please give a name to this archive.",
                function (msg) {
                    if (msg != null) {
                        ptUnderwriting.archive($scope.data, msg).then(function done(data) {
                            alert("Archived succesful.");
                        }, function fail(e) {
                            console.log(e);
                            alert("Failed to archive.");
                        });
                    }

                });
        };
        // Load a single archived entry in database
        $scope.loadArchived = function (archive) {
            //debugger;
            if (archive.Id) {
                ptUnderwriting.loadArchived(archive.Id).then(function done(data) {
                    if (data) {
                        //debugger;
                        angular.copy($scope.data, $scope.currentDataCopy);
                        ptCom.assignReference($scope.data, data, [], ["Id"]);
                        $scope.archive = archive;
                        $scope.archive.isLoaded = true;
                        ptCom.alert("Load successfully");
                    }
                }, function fail(e) {
                    console.log(e);
                    ptCom.alert("Failed to load archive.");
                });
            }

        };
        // Restore from achived version to current version
        $scope.restoreCurrent = function () {
            if ($scope.currentDataCopy) {
                ptCom.assignReference($scope.data, $scope.currentDataCopy);
                $scope.archive.isLoaded = false;
                ptCom.alert("Restored to current version.");
            }
        };
        // Core function to apply predefined rule, and update model values.
        $scope.calculate = function () {
            $scope.data.PropertyInfo.PropertyType = (function () {
                return /.*(A|B|C0|21|R).*/.exec($scope.data.PropertyInfo.TaxClass) ? 1 : 2;
            })();
            $scope.data.DealCosts.HAFA = ($scope.data.PropertyInfo.SellerOccupied || int($scope.data.PropertyInfo.NumOfTenants) > 0)
                             && !$scope.data.LienInfo.FHA
                             && !$scope.data.LienInfo.FannieMae
                             && !$scope.data.LienInfo.FreddieMac
                             && float($scope.data.DealCosts.HOI) > 0.0;
            ptUnderwriting.calculate($scope.data, $scope.debug).then(function (output) {
                if ($scope.debug) console.log(output);
                $scope.data.MinimumBaselineScenario = output.MinimumBaselineScenario;
                $scope.data.BestCaseScenario = output.BestCaseScenario;
                $scope.data.Summary = output.Summary;
                $scope.data.CashScenario = output.CashScenario;
                $scope.data.LoanScenario = output.LoanScenario;
                $scope.data.FlipScenario = output.FlipScenario;
                $scope.data.RentalModel = output.RentalModel;
            }, function (e) {
                console.log(e);
                console.log("Fail to get proxy: calculate.")
            });
        };
        // Default Disable Editing for preventing accident change.
        $scope.enableEditing = function () {
            $scope.$broadcast("pt-editable-div-unlock");
            $scope.isProtectedView = false;
        };
        // Change Status of Underwriting.
        $scope.changeStatus = function (status, msg) {
            // because the underwriting completion is not reversible, comfirm it before save to db.
            msg = msg || "Please provide note or press 'No' to cancel";
            ptCom.prompt(msg, function then(note) {
                if (note != null) {
                    if (!$scope.data || !$scope.BBLE) ptCom.alert("BBLE is missing!");
                    ptUnderwriting.changeStatus($scope.data.BBLE, status, note).then(function succ(data) {
                        ptCom.alert("Update status successfully.")
                    }, function fail(e) {
                        consoel.log(e);
                        ptCom.alert("Fail to update underwriting status.");
                    });
                } else {
                    ptCom.alert("Note is required.");
                }
            }, true);

        };
        $scope.$watch(function () {
            return $state.$current.name;
        }, function (newVal, oldVal) {
            if (newVal === "underwriter.datainput") {
                if ($scope.isProtectedView === false) {
                    $scope.enableEditing();
                }
            }
        });
        // Init controller;
        $scope.BBLE = ptCom.getGlobal("BBLE") || "";
        $scope.viewmode = ptCom.getGlobal("viewmode") || 0;
        $scope.init($scope.BBLE);
        // A predefined model to validate with excel data.
        $scope.feedData = function () {
            $scope.data.PropertyInfo.TaxClass = "A0",
            $scope.data.PropertyInfo.ActualNumOfUnits = 1;
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
        };
    }
]);