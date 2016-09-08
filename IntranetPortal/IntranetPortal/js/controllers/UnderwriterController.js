angular.module("PortalApp").config(function ($stateProvider) {

    var dataInput = {
        name: 'datainput',
        url: '/datainput',
        templateUrl: '/js/Views/Underwriter/datainput.tpl.html'
    }
    var flipsheets = {
        name: 'flipsheets',
        url: '/flipsheets',
        templateUrl: '/js/Views/Underwriter/flipsheets.tpl.html'
    }
    var rentalmodels = {
        name: 'rentalmodels',
        url: '/rentalmodels',
        templateUrl: '/js/Views/Underwriter/rentalmodels.tpl.html'
    }
    var tables = {
        name: 'tables',
        url: '/tables',
        templateUrl: '/js/Views/Underwriter/tables.tpl.html'
    }
    $stateProvider.state(dataInput);
    $stateProvider.state(flipsheets);
    $stateProvider.state(rentalmodels);
    $stateProvider.state(tables);

});
angular.module("PortalApp").controller("UnderwriterController", ['$scope', 'ptCom', '$location', function ($scope, ptCom, $location) {

    $scope.model = {};

    $scope.isActive = function (viewLocation) {
        return viewLocation === $location.path();
    };

}])