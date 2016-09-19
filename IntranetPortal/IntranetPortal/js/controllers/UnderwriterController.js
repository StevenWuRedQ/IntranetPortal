angular.module("PortalApp").config(function ($stateProvider) {

    var underwriter = {
        name: 'underwriter',
        url: '/underwriter',
        controller: 'UnderwriterController'
    }

    var dataInput = {
        name: 'underwriter.datainput',
        url: '/datainput',
        //controller: 'UnderwriterController',
        templateUrl: '/js/Views/Underwriter/datainput.tpl.html'
    }
    var flipsheets = {
        name: 'underwriter.flipsheets',
        url: '/flipsheets',
        //controller: 'UnderwriterController',
        templateUrl: '/js/Views/Underwriter/flipsheets.tpl.html'
    }
    var rentalmodels = {
        name: 'underwriter.rentalmodels',
        url: '/rentalmodels',
        //controller: 'UnderwriterController',
        templateUrl: '/js/Views/Underwriter/rentalmodels.tpl.html'
    }
    var tables = {
        name: 'underwriter.tables',
        url: '/tables',
        //controller: 'UnderwriterController',
        templateUrl: '/js/Views/Underwriter/tables.tpl.html'
    }

    $stateProvider.state(underwriter)
                    .state(dataInput)
                    .state(flipsheets)
                    .state(rentalmodels)
                    .state(tables);

});
angular.module("PortalApp").controller("UnderwriterController", ['$scope', 'ptCom', 'ptUnderwriter', function ($scope, ptCom, ptUnderwriter) {

    $scope.data = {};
    $scope.uw = ptUnderwriter;


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

    $scope.applyFixedRules = function () {
        var t = $scope.data.Tables;

        if (!$scope.fixedRulesApplied) {
            $scope.fixedRulesApplied = 1;

            // Table -> liens
            t.Liens.TaxLienSettlement = 0.09 / 12;
            t.Liens.PropertyTaxesSettlement = 1.0;
            t.Liens.WaterChargesSettlement = 1.0;
            t.Liens.HPDChargesSettlement = 1.0;
            t.Liens.ECBDOBViolationsSettlement = 0.35;
            t.Liens.DOBCivilPenaltiesSettlement = 1.0;
            t.Liens.PersonalJudgementsSettlement = 0.4;
            t.Liens.HPDJudgementsSettlement = 0.15;
            t.Liens.RelocationLienSettlement = .09 / 365;
            t.Liens.HOILienSettlement = 0.75;



        }
    };

    $scope.applyRule = function () {
        var t = $scope.data.Tables;
        var d = $scope.data;
        var float = parseFloat;

        $scope.applyFixedRules();

        // DataInputs
        d.PropertyInfo = (function () { return /.*(A|B|C0|21|R).*/.exec(d.TaxClass) ? "Residential" : "Not Residential" })();

        // Tables -> Liens
        t.Liens.TaxLien = float(d.TaxLienCertificate) * (1.0 + (t.Liens.TaxLienSettlement * float(d.DealTimeMonths)));
        t.Liens.PropertyTaxes = float(d.PropertyTaxes) * t.Liens.PropertyTaxesSettlement;
        t.Liens.WaterCharges = float(d.WaterCharges) * t.Liens.WaterChargesSettlement;
        t.Liens.HPDCharges = float(d.HPDCharges) * t.Liens.HPDChargesSettlement;
        t.Liens.ECBDOBViolations = float(d.ECBDOBViolations) * (1.0 + 0.0075 * float(d.DealTimeMonths)) * t.Liens.ECBDOBViolationsSettlement;
        t.Liens.DOBCivilPenalties = float(d.DOBCivilPenalty) * t.Liens.DOBCivilPenaltiesSettlement;
        t.Liens.PersonalJudgements = float(d.PersonalJudgements) * t.Liens.PersonalJudgementsSettlement;
        t.Liens.HPDJudgements = float(d.HPDJudgements) * t.Liens.HPDJudgementsSettlement;
        t.Liens.IRSNYSTaxLienSettlement = (function () {
            return float(d.IRSNYSTaxLiens) < 12500 ? 1.0 : 0.0
        })();
        t.Liens.IRSNYSTaxLien = float(d.IRSNYSTaxLiens) * t.Liens.IRSNYSTaxLienSettlement;
        t.Liens.RelocationLien = (function () {

            function getTodayDate(){
                return new Date(new Date().toJSON().slice(0,10));
            }
            if (!d.RelocationLienDate)
                return 0.0;
            else {
                return float(d.RelocationLien) * (1.0 + (getTodayDate().getTime() + 180*24*60*60*1000 - new Date(d.RelocationLienDate).getTime()) * t.Liens.RelocationLienSettlement)
            }
        })();

        t.Liens.MoneySpent = float(d.MoneySpent);
        t.Liens.HOILien = (function () {
            var c1 = d.SellerOccupied;
            var c2 = d.NumOfTenants > 0;
            var c3 = d.FHA;
            var c4 = d.FannieMae;
            var c5 = d.FreddieMac;
            var c6 = d.HOI;

            return (c1 | c2) & c3 & c4 & c5 & c6 ? float(d.HOI) * t.Liens.HOILienSettlement - 10000.00 : float(d.HOI) * t.Liens.HOILienSettlement;

        })();
        t.Liens.COSTermination = float(d.COSTermination);
        t.Liens.Tenants = float(d.NumOfTenants) * 5000.00;
        t.Liens.Agent = float(d.AgentCommission);
        
    }

}])
