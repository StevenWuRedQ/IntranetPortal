﻿
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
        
        // bug fix for mortgageAmount secondMortgageAmount not saving
        // 8/26/2016
        var data1 = LeadsInfo.get({ BBLE: BBLE.trim() }, function () {
            self.ownerName = self.ownerName || data1.Owner;
            self.getOwnerSSN(BBLE);

            // disable the water tax from leads 
            // @see jira link
            // https://myidealprop.atlassian.net/browse/PORTAL-484

            //self.waterCharges = self.waterCharges || data1.WaterAmt;
            //self.propertyTaxes = self.propertyTaxes || data1.TaxesAmt;
            //self.mortgageAmount = self.mortgageAmount || data1.C1stMotgrAmt;
            //self.secondMortgageAmount = self.secondMortgageAmount || data1.C2ndMotgrAmt;

            
        });
        return data1;
    }

    return leadResearch;
});