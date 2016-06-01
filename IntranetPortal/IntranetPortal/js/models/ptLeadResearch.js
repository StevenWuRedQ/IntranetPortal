
angular.module('PortalApp').factory('LeadResearch', function ($http,LeadsInfo) {

    var leadResearch = function () {

    }


    leadResearch.prototype.getOwnerSSN = function (BBLE) {
        var self = this;
        $http.post("/api/homeowner/ssn/" + BBLE, JSON.stringify(self.ownerName)).
            success(function (ssn, status, headers, config) {
                self.ownerSSN = ssn;
            });
    }

    leadResearch.prototype.initFromLeadsInfo = function(BBLE)
    {
        var self = this;
        var data1 = LeadsInfo.get({ BBLE: BBLE.trim() }, function () {
            self.ownerName = data1.Owner;
            self.waterCharges = data1.WaterAmt;
            self.propertyTaxes = data1.TaxesAmt;
            self.mortgageAmount = data1.C1stMotgrAmt;
            self.secondMortgageAmount = data1.C2ndMotgrAmt;
            self.getOwnerSSN(BBLE);
        });
        return data1;
    }
    //leadResearch.prototype.func
    //def function
    //leadResearch.func
    //constructor
    return leadResearch;
});