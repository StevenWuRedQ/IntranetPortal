angular.module("PortalApp")
    .controller("UnderwritingRequestController",
    [
        "$scope", "$http", "$location", "$state", "UnderwritingRequest", "ptCom", "DocSearch",
        function($scope, $http, $location, $state, UnderwritingRequest, ptCom, DocSearch) {
            $scope.init = function(bble) {
                $scope.data = {};
                if ($scope.BBLE) {
                    $scope.data = UnderwritingRequest.get({ BBLE: $scope.BBLE.trim() },
                        function() {
                            $scope.search = DocSearch.get({ BBLE: bble.trim() });
                        });
                }
            };
            $scope.cleanForm = function() {
                var oldId = $scope.data.Id;
                $scope.data = {};
                $scope.data.Id = oldId;
                $scope.formCleaned = true;
            };

            // Check input and textarea to see if there is a error attribute
            $scope.checkValidate = function(async) {
                if (!async) {
                    return _.some($("input, textarea, select"),
                        function(v) {
                            return $(v).attr("error") === "true";
                        });
                } else {
                    var dfd = $.Deferred();

                    var err = _.some($("input, textarea, select"),
                        function(v) {
                            return $(v).attr("error") === "true";
                        });

                    if (err) {
                        dfd.resolve();
                    } else {
                        dfd.reject();
                    }

                    return dfd;
                }

            };

            // Broadcast ptSelfCheck event make ptRequried directive check it self
            $scope.selfCheck = function() {
                $scope.$broadcast("ptSelfCheck");
                var startFlag = false;
                var checkingcounter = 0;
                $scope.$on("ptSelfCheckStart",
                    function() {
                        startFlag = true;
                        checkingcounter++;
                    });
            };
            $scope.save = function(isSlient) {
                $scope.$broadcast("ptSelfCheck");
                if ($scope.checkValidate()) {
                    ptCom.alert("Please correct Highlight Field first.");
                    return;
                }
                UnderwritingRequest.saveByBBLE($scope.data, $scope.BBLE).then(function() {
                        if (!isSlient) {
                            ptCom.alert("Save Successful!");
                        }
                    },
                    function() {
                        if (!isSlient) {
                            ptCom.alert("Fail to Save!");
                        }
                    });

            };
            $scope.requestDocSearch = function(isResubmit) {
                $scope.$broadcast("ptSelfCheck");
                // debugger;
                if ($scope.checkValidate()) {
                    ptCom.alert("Please correct Highlight Field first.");
                    return;
                }
                UnderwritingRequest.createSearch($scope.BBLE).then(function(r) {
                        //debugger;
                        $scope.search.CreateDate = new Date().toISOString();
                        ptCom.alert("Property Search Submitted to Underwriting. Thank you!");
                        $scope.data.Status = 1;
                        if (isResubmit) {
                            debugger;
                            $scope.search.CompletedOn = undefined;
                            $scope.search.Expired = false;
                            $scope.formCleaned = false;
                        }
                        $scope.save(true);
                    },
                    function() {
                        ptCom.alert("Fail to create search");
                    });
            };
            $scope.remainDays = function() {
                if (!$scope.search || !$scope.search.CompletedOn) {
                    return "more than 60";
                } else {
                    var timenow = new Date().getTime();
                    var timeCompleted = new Date($scope.search.CompletedOn);
                    var diff = timenow - timeCompleted;
                    var dayinmsec = 1000 * 60 * 60 * 24;
                    return 60 - Math.ceil(diff / dayinmsec);
                }

            };
            $scope.completedOver60days = function() {
                if (!$scope.search || $scope.search.CompletedOn == undefined) {
                    return false;
                } else {
                    return $scope.remainDays() < 0 ? true : false;
                }

            };
            $scope.viewmode = ptCom.getGlobal("viewmode") || ptCom.parseSearch(location.search).mode || 0;
            $scope.BBLE = ptCom.getGlobal("BBLE") || ptCom.parseSearch(location.search).BBLE || "";
            $scope.init($scope.BBLE);
        }
    ]);