var portalApp = angular.module("PortalApp",
[
    "ngResource", "ngSanitize", "ngAnimate", "ngMask", "dx", "ui.bootstrap",
    "ui.select", "ui.layout", "ngRoute", "ui.router"
]);

angular.module("PortalApp").controller("MainCtrl",
    ["$rootScope", "$uibModal", "$timeout", "$state",
    function ($rootScope, $uibModal, $timeout, $state) {
        $rootScope.scope = $rootScope;
        $rootScope.globaldata = {};
        $rootScope.AlertModal = null;
        $rootScope.ConfirmModal = null;
        $rootScope.loadingCover = document.getElementById("LodingCover");
        $rootScope.panelLoading = false;
        $rootScope.isPromptModalArea = false;
        $rootScope.loadPanelPosition = (function () {
            var dataPanelDiv = document.getElementById("dataPanelDiv");
            if (dataPanelDiv != null) {
                return { of: "#dataPanelDiv" };
            } else {
                return { of: "body" };
            }
        })();
        $rootScope.$state = $state;
        $rootScope.alert = function (message) {
            $rootScope.alertMessage = message ? message : "";
            $rootScope.AlertModal = $uibModal.open({
                templateUrl: "AlertModal"
            });
        };
        $rootScope.alertOK = function () {
            $rootScope.AlertModal.close();
        };
        $rootScope.confirm = function (message, confrimFunc) {
            $rootScope.confirmMessage = message ? message : "";
            $rootScope.ConfirmModal = $uibModal.open({
                templateUrl: "ConfirmModal"
            });
            $rootScope.ConfirmModal.confrimFunc = confrimFunc;
            return $rootScope.ConfirmModal.result;
        };
        $rootScope.confirmYes = function () {
            $rootScope.ConfirmModal.close(true);
            if ($rootScope.ConfirmModal.confrimFunc) {
                $rootScope.ConfirmModal.confrimFunc(true);
            }

        };
        $rootScope.confirmNo = function () {
            $rootScope.ConfirmModal.close(false);
            if ($rootScope.ConfirmModal.confrimFunc) {
                $rootScope.ConfirmModal.confrimFunc(false);
            }
        };
        $rootScope.prompt = function (message, callback, /*optional*/ showArea) {
            $rootScope.promptMessage = message ? message : "";
            $rootScope.promptModalTxt = "";
            $rootScope.isPromptModalArea = showArea || false;
            $rootScope.promptModal = $uibModal.open({
                templateUrl: "PromptModal"
            });
            $rootScope.promptModal.promptFunc = callback;

        };
        $rootScope.promptYes = function () {
            $rootScope.promptModal.close($rootScope.promptModalTxt);
            if ($rootScope.promptModal.promptFunc) {
                //UI Modal use async call send result so use jquery instand now 
                $rootScope.promptModal.promptFunc($("#promptModalTxt").val());
            }

        };
        $rootScope.promptNo = function () {
            $rootScope.promptModal.close(false);
            if ($rootScope.promptModal.promptFunc) {
                $rootScope.promptModal.promptFunc(null);
            }
        };
        $rootScope.showLoading = function (divId) {
            $($rootScope.loadingCover).show();
        };
        $rootScope.hideLoading = function (divId) {
            $($rootScope.loadingCover).hide();
        };
        $rootScope.toggleLoading = function () {
            $timeout(function () {
                $rootScope.panelLoading = !$scope.panelLoading;
            });
        };
        $rootScope.startLoading = function () {
            $timeout(function () {
                $rootScope.panelLoading = true;
            });
        };
        $rootScope.stopLoading = function () {
            $timeout(function () {
                $rootScope.panelLoading = false;
            });
        };
    }]);
