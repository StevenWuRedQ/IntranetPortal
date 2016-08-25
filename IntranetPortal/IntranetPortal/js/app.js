var portalApp = angular.module('PortalApp',
    ['ngResource', 'ngSanitize', 'ngAnimate', 'dx', 'ngMask', 'ui.bootstrap', 'ui.select', 'ui.layout', 'ngRoute', 'firebase', 'ui.router']);

angular.module('PortalApp')
    .controller('MainCtrl', ['$rootScope', '$uibModal', '$timeout', function ($rootScope, $uibModal, $timeout) {
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

        $rootScope.confirm = function (message, confrimFunc) {
            $rootScope.confirmMessage = message ? message : '';
            $rootScope.ConfirmModal = $uibModal.open({
                templateUrl: 'ConfirmModal'
            });
            $rootScope.ConfirmModal.confrimFunc = confrimFunc;
            return $rootScope.ConfirmModal.result;
        }
        $rootScope.confirmYes = function () {
            $rootScope.ConfirmModal.close(true);
            if ($rootScope.ConfirmModal.confrimFunc) {
                $rootScope.ConfirmModal.confrimFunc(true);
            }

        }
        $rootScope.confirmNo = function () {
            $rootScope.ConfirmModal.close(false);
            if ($rootScope.ConfirmModal.confrimFunc) {
                $rootScope.ConfirmModal.confrimFunc(false);
            }
        }

        $rootScope.prompt = function (message, promptFunc) {
            $rootScope.promptMessage = message ? message : '';
            $rootScope.promptModalTxt = '';
            $rootScope.promptModal = $uibModal.open({
                templateUrl: 'PromptModal'
            });
            $rootScope.promptModal.promptFunc = promptFunc;
        }
        $rootScope.promptYes = function () {
            $rootScope.promptModal.close($rootScope.promptModalTxt);
            if ($rootScope.promptModal.promptFunc) {
                //UI Modal use async call send result so use jquery instand now 
                $rootScope.promptModal.promptFunc($("#promptModalTxt").val());
            }

        }
        $rootScope.promptNo = function () {
            $rootScope.promptModal.close(false);
            if ($rootScope.promptModal.promptFunc) {
                $rootScope.promptModal.promptFunc(null)
            }
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

/**

portalApp.config(function ($locationProvider) {

    /* because need use anguler support url parameters $location.search();
     * but it only work when open html 5 model 
     * so need open html 5 model 


//$locationProvider.html5Mode({
//    enabled: true,
//    requireBase: false
//});

function TestRequirePortalApp() {
    var portalApp = angular.module('PortalApp', []);
    return portalApp;
}


*this is model define has to be the last line
*like compile script will call when use require js solove the dependency 
Import xx  xx1
 
if (typeof requirejs === "function") {
    define(["jquery", "angular", "angular-resource", "angular-route", "angular-animate", "angular-sanitize"],
        function ($, angular, ngResource, ngRoute, ngAnimate, ngSanitize) {
            //the jquery.alpha.js and jquery.beta.js plugins have been loaded.
            return RequirePortalApp();
        });
} else {
    var portalApp = RequirePortalApp();
}
*/