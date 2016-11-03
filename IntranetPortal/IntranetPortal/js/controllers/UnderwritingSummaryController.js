angular.module("PortalApp").controller("UnderwritingSummaryController", ['$scope', 'ptCom', 'ptUnderwriter', 'DocSearch', function ($scope, ptCom, ptUnderwriter, DocSearch) {

    $scope.showStoryHistory = function () {
        //debugger;
        var scope = angular.element('#uwrview').scope();
        if (scope.data && scope.data.Id) {
            auditLog.toggle('UnderwritingRequest', scope.data.Id);
        }
    }

    $scope.markCompleted = function(status, msg) {
        // because the underwriting completion is not reversible, comfirm it before save to db.
        msg = 'Please provide Note or press no to cancel';
        ptCom.prompt(msg, function (result) {
            //debugger;
            if (result != null && $scope.search) {
                debugger;
                DocSearch.markCompleted($scope.search.BBLE, status, result).then(function succ(d) {
                    $scope.search.UnderwriteStatus = d.data.UnderwriteStatus;
                    $scope.search.UnderwriteCompletedBy = d.data.UnderwriteCompletedBy;
                    $scope.search.UnderwriteCompletedOn = d.data.UnderwriteCompletedOn;
                    $scope.search.UnderwriteCompletedNotes = d.data.UnderwriteCompletedNotes;
                }, function err() {
                    console.log("fail to update docsearch");
                });
            }

        }, true);

    }
    $scope.loadAdditionalInfo = function (bble) {
        $scope.search = DocSearch.get({ BBLE: bble.trim()})
    }
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
}]);