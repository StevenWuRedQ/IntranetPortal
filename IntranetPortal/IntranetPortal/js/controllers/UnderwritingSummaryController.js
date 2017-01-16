angular.module("PortalApp").controller("UnderwritingSummaryController",
[
    "$scope", "ptCom", "ptUnderwriting", "DocSearch",
    function ($scope, ptCom, ptUnderwriting, DocSearch) {

        $scope.showStoryHistory = function () {
            //debugger;
            var scope = angular.element("#uwrview").scope();
            if (scope.data && scope.data.Id) {
                auditLog.toggle("UnderwritingRequest", scope.data.Id);
            }
        };
        $scope.loadAdditionalInfo = function (bble) {
            $scope.search = DocSearch.get({ BBLE: bble.trim() });
        };
        try {
            var searchs = ptCom.parseSearch(location.search);
            if (searchs) {
                $scope.BBLE = searchs.BBLE || "";
                $scope.viewmode = searchs.mode || 0;
            }
            ptCom.setGlobal("BBLE", $scope.BBLE);
            ptCom.setGlobal("viewmode", $scope.viewmode);
            $scope.loadAdditionalInfo($scope.BBLE);
        } catch (ex) {
            ptCom.setGlobal("BBLE", "");
            ptCom.setGlobal("viewmode", 0);
        }

        $scope.$on("$stateChangeSuccess",
            function (e, arg) {
                if (arg && arg.name && arg.name === 'underwriter.datainput') {
                    try {
                        if (parent.previewControl) {
                            parent.previewControl.maximize();
                        }
                    } catch (e) {

                    }

                }
            });
    }
]);