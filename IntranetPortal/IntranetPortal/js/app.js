var portalApp = angular.module('PortalApp', ['ngSanitize', 'ngAnimate', 'dx', 'ngMask', 'ui.bootstrap', 'ui.select', 'ui.layout']);
angular.module('PortalApp').
controller('MainCtrl', ['$rootScope', '$uibModal', '$timeout', function ($rootScope, $uibModal, $timeout) {
    $rootScope.AlertModal = null;
    $rootScope.ConfirmModal = null;
    $rootScope.loadingCover = document.getElementById('LodingCover');
    $rootScope.panelLoading = false;

    $rootScope.alert = function (message) {
        $rootScope.alertMessage = message ? message : '';
        $rootScope.AlertModal = $uibModal.open({
            templateUrl: 'AlertModal',
        });
    }

    $rootScope.alertOK = function () {
        $rootScope.AlertModal.close();
    }

    $rootScope.confirm = function (message) {
        $rootScope.confirmMessage = message ? message : '';
        $rootScope.ConfirmModal = $uibModal.open({
            templateUrl: 'ConfirmModal'
        });
        return $rootScope.ConfirmModal.result;
    }

    $rootScope.confirmYes = function () {
        $rootScope.ConfirmModal.close(true);
    }

    $rootScope.confirmNo = function () {
        $rootScope.ConfirmModal.close(false);
    }


    $rootScope.showLoading = function (divId) {
        $($rootScope.loadingCover).show();
    }

    $rootScope.hideLoading = function (divId) {
        $($rootScope.loadingCover).hide();
    }

    $rootScope.toggleLoading = function () {
        $rootScope.panelLoading = !$scope.panelLoading;
    }
    $rootScope.startLoading = function () {
        $rootScope.panelLoading = true;
    }
    $rootScope.stopLoading = function () {
        $timeout(function () {
            $rootScope.panelLoading = false;
        });
    }
}]);