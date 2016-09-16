angular.module("PortalApp").config(function ($stateProvider) {

    var underwriter = {
        name: 'underwriter',
        url: '',
        abstract: true,
        controller: 'UnderwriterController',
        templateUrl: '/js/Views/Underwriter/datainput.tpl.html'
    }

    var dataInput = {
        name: 'datainput',
        url: '/datainput',
        parent: 'underwriter',
        controller: 'UnderwriterController',
        templateUrl: '/js/Views/Underwriter/datainput.tpl.html'
    }
    var flipsheets = {
        name: 'flipsheets',
        url: '/flipsheets',
        parent: 'underwriter',
        controller: 'UnderwriterController',
        templateUrl: '/js/Views/Underwriter/flipsheets.tpl.html'
    }
    var rentalmodels = {
        name: 'rentalmodels',
        url: '/rentalmodels',
        parent: 'underwriter',
        controller: 'UnderwriterController',
        templateUrl: '/js/Views/Underwriter/rentalmodels.tpl.html'
    }
    var tables = {
        name: 'tables',
        url: '/tables',
        parent: 'underwriter',
        controller: 'UnderwriterController',
        templateUrl: '/js/Views/Underwriter/tables.tpl.html'
    }

    $stateProvider.state(underwriter)
                    .state(dataInput)
                    .state(flipsheets)
                    .state(rentalmodels)
                    .state(tables);

});
angular.module("PortalApp").controller("UnderwriterController", ['$scope', 'ptCom', '$location', 'ptUnderwriter', function ($scope, ptCom, $location, ptUnderwriter) {

    $scope.data = {};
    $scope.uw = ptUnderwriter;

    $scope.isActive = function (viewLocation) {
        return viewLocation === $location.path();
    };

    $scope.init = function (bble, isImport) {
        ptCom.startLoading()
        $scope.data = ptUnderwriter.load(bble, isImport);
        $scope.data.$promise.then(function () {
            $scope.applyRule();
        }).finally(function () {
            ptCom.stopLoading()

        })
    }

    $scope.save = function () {
    }


    $scope.update = function () {
        $scope.applyRule();
    }

    $scope.applyRule = function () {
        var t = $scope.data.tables;
        var d = $scope.data;
        /** table **/
        t.TaxLienSettlement = 0.09 / 12;
        t.TaxLien = d.TaxLienCertificate * (1 + (t.TaxLienSettlement * d.DealTimeMonths));
    }

}])