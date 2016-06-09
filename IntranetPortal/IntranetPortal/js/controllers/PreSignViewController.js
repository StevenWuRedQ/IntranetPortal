var portalApp = angular.module('PortalApp');

portalApp.controller('perAssignViewCtrl', function ($scope, PerSignItem, DxGridModel) {
    $scope.PerSignItem = PerSignItem;
})